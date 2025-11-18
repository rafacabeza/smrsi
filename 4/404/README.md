# Uso de rsync y rsnapshot+

> NOTA:
> "remoteserver" se va llama "isardvdi"
> El cliente ubuntu se llama "ubuntu22"

## Objetivos de la práctica

1. Entender y practicar `rsync` (modo local y remoto, opciones básicas y `--dry-run`).
2. Configurar `rsnapshot` para hacer backups incrementales (local y remotos).
3. Establecer **autenticación por clave SSH** sin contraseña (clave generada con los valores por defecto de `ssh-keygen`) y usarla para backups automatizados.
4. Comprobar seguridad básica y opciones para ejecutar `rsnapshot` de forma segura y automatizada.

---

## Requisitos previos

* Dos máquinas accesibles por SSH: **máquina Backup** (donde ejecutarás `rsnapshot`, llamémosla `backupserver`) y **máquina Origen** (la que quieres respaldar, `remoteserver`). Pueden ser VMs locales o VPS.
* En ambas: `rsync` instalado. En la máquina de backup: `rsnapshot` instalado.
* Usuario con privilegios para leer los datos a respaldar (frecuente: ejecutar `rsnapshot` como root en `backupserver`, y conectar como un usuario `backupuser` en `remoteserver` que pueda ejecutar `rsync` con `sudo` si necesitas leer archivos root).
* Conexión de red SSH entre ambos.

---

## Nota sobre claves SSH por defecto

Si generas una clave SSH con `ssh-keygen` sin indicar tipo ni nombre, OpenSSH usa **el tipo por defecto actual (ed25519)** y propone el nombre de fichero por defecto (`~/.ssh/id_ed25519` para ese tipo). Esto es el comportamiento por defecto moderno de `ssh-keygen`. ([Stack Overflow][1])

---

## 1 — Preparación e inspección (en backupserver)

1. Actualiza/instala paquetes:

```bash
## en Debian/Ubuntu
sudo apt update
sudo apt install -y rsync rsnapshot openssh-client openssh-server
## en remoteserver instala rsync y openssh-server
```

2. Crea un usuario de backup en `remoteserver` (ejemplo `backupuser`) — en `remoteserver`:

```bash
sudo adduser --gecos "" backupuser
sudo passwd backupuser
## ponemos contraseña pero sería conveniente quitarla después
## (opcionalmente darle permisos sudo solo para rsync, ver más abajo)
```

---

## 2 — Generar la clave SSH usando los valores por defecto

En `backupserver` (ejecuta como el usuario que va a iniciar las conexiones; si vas a ejecutar `rsnapshot` como root entonces genera las claves para root con `sudo -i` o `sudo ssh-keygen`):

```bash
## En backupserver, como el usuario que vaya a ejecutar rsnapshot (ej: root)
ssh-keygen
```

* Pulsa Enter para aceptar la ruta y nombre por defecto (p. ej. `~/.ssh/id_ed25519`).
* Si se te pregunta por passphrase: para backups totalmente desatendidos es habitual dejarla vacía (`Enter` dos veces). **Recomendación de seguridad:** si prefieres seguridad extra, protege la clave con passphrase y usa `ssh-agent` para cargarla; para backups automatizados en servidores suele usarse clave **sin passphrase** y aplicar restricciones en `authorized_keys`. ([Stack Overflow][1])

---

## 3 — Copiar la clave pública a remoteserver (método simple)

Usa `ssh-copy-id` para instalar la `~/.ssh/id_ed25519.pub` en `remoteserver`:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub backupuser@remoteserver.example.com
## si ssh-copy-id no existe, puedes hacer:
cat ~/.ssh/id_ed25519.pub | ssh backupuser@remoteserver.example.com 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys'
```

Prueba la conexión sin contraseña:

```bash
ssh backupuser@remoteserver.example.com 'echo OK; whoami; hostname'
```

Si devuelve `OK` y el usuario/host, la autenticación por clave funciona.

---

## 4 — Asegurar la clave (opcional pero recomendado)

> Esto no lo vamos a hacer. Lo dejamos para que lo investigue quien quiera.

Para una clave **sin passphrase** usada en backups automáticos, restringe su uso en `remoteserver` añadiendo parámetros antes de la clave en `~/.ssh/authorized_keys`, por ejemplo:

```text
from="IP_del_backupserver",no-agent-forwarding,no-pty,command="/usr/bin/rsync --server --sender -logDtprRe.iLsfx ." ssh-ed25519 AAAA...== backup@backupserver
```

* `from="..."` limita origen.
* `no-pty` y `no-agent-forwarding` reducen vectores de abuso.
* `command="..."` fuerza que la conexión solo pueda ejecutar rsync; **esto requiere cuidado** (puedes dejarlo para control estricto).
  (Estas son opciones avanzadas; úsalas si entiendes sus implicaciones.)

---

## 5 — (Opcional) permitir que `backupuser` ejecute `rsync` con sudo sin contraseña

Si quieres que `backupuser` en `remoteserver` pueda rsync de rutas que requieren root (p. ej. `/etc` o `/var`), añade una regla sudoers en `remoteserver`:

```bash
## en remoteserver como root (usa visudo o crea archivo)
echo 'backupuser ALL=(root) NOPASSWD: /usr/bin/rsync' | sudo tee /etc/sudoers.d/backupuser-rsync
sudo chmod 440 /etc/sudoers.d/backupuser-rsync
```

Luego el servidor de backup pedirá que el comando remoto sea `sudo rsync` (ver configuración rsnapshot más abajo). La técnica es la recomendada en prácticas con rsnapshot para leer ficheros protegidos. ([Unix & Linux Stack Exchange][2])

---

## 6 — Práctica con rsync (comandos útiles)

Prueba un `dry-run` y luego una sincronización real.

1. **Simular** la copia remota `/etc` a local `/backups/remoteserver/etc`:

```bash
sudo mkdir -p /backups/remoteserver/etc
sudo rsync -avz --numeric-ids --delete --dry-run backupuser@remoteserver.example.com:/etc/ /backups/remoteserver/etc/
```

2. **Real** (si necesitas `sudo` remoto en remoteserver):

```bash
sudo rsync -avz --numeric-ids --delete --rsync-path="sudo rsync" backupuser@remoteserver.example.com:/etc/ /backups/remoteserver/etc/
```

Explicación rápida de opciones:

* `-a` archivo (recursivo + preserva permisos, enlaces, etc.)
* `-v` verbose
* `-z` compresión en tránsito
* `--numeric-ids` para preservar UID/GID en lugar de mapear nombres
* `--delete` borrar ficheros en destino que fueron borrados en origen
* `--rsync-path="sudo rsync"` indica que en remoto se ejecute `sudo rsync`.

Haz varios `--dry-run` hasta que entiendas el comportamiento.

---

## 7 — Configurar rsnapshot (archivo y líneas clave)

Edita `/etc/rsnapshot.conf` (o copia ejemplo a `~/.rsnapshot.conf` para pruebas). Puntos esenciales a configurar:

Ejemplo mínimo (fragmento):

```
## /etc/rsnapshot.conf (fragmento)
snapshot_root   /var/backups/rsnapshot/
no_create_root  1

cmd_ssh         /usr/bin/ssh
cmd_rsync       /usr/bin/rsync

## rsync_long_args se usa para transferencias remotas
rsync_long_args --delete --numeric-ids --relative --delete-excluded

## intervalos (retenciones)
retain  hourly  6
retain  daily   7
retain  weekly  4

## líneas de backup: formato (TAB separador)
## backup  user@host:/path/    host_subdir/
backup  backupuser@remoteserver.example.com:/etc/    remoteserver/etc/
backup  backupuser@remoteserver.example.com:/home/   remoteserver/home/
```

Notas:

* `snapshot_root` es la raíz donde rsnapshot almacenará `hourly.0`, `daily.0`, etc. (ubicación por defecto suele ser `/.snapshots/` o `/var/cache/rsnapshot/` según instalación). Ajusta según espacio. ([Documentación Ubuntu][3])
* En la línea `backup` **usa TAB** entre columnas (en muchos ejemplos la separación tabular es crítica).
* Para accesos que requieran `sudo` en remoto, usa `rsync_long_args` con `--rsync-path="sudo rsync"` o configura `cmd_ssh` para añadir opciones. Ver ejemplo más abajo.

Ejemplo con `sudo` remoto (rsnapshot.conf):

```
rsync_long_args --rsync-path="sudo rsync" --delete --numeric-ids --relative --delete-excluded
backup  backupuser@remoteserver.example.com:/etc/    remoteserver/etc/
```

Prueba configuración:

```bash
sudo rsnapshot configtest
```

Y ejecuta un pase manual (verbose):

```bash
sudo rsnapshot -v -v hourly
## o probar un único backup:
sudo rsnapshot -t hourly   ## muestra qué haría (test)
```

---

## 8 — Integración con las claves SSH por defecto

`rsnapshot` usará SSH para conectar. Si generaste la clave `~/.ssh/id_ed25519` y la copiaste a `remoteserver`, no necesitas indicar más; `rsnapshot` (ejecutado por el mismo usuario que generó la clave) usará esa identidad. Para forzar un IdentityFile o ajustar opciones SSH (p. ej. puerto no estándar), puedes:

1. Crear un `~/.ssh/config` (en el usuario que corre rsnapshot, p. ej. root):

```
Host remoteserver.example.com
    User backupuser
    IdentityFile ~/.ssh/id_ed25519
    Port 22
    StrictHostKeyChecking yes
```

2. O ajustar `cmd_ssh` en `/etc/rsnapshot.conf`:

```
cmd_ssh /usr/bin/ssh -i /root/.ssh/id_ed25519 -p 22
```

---

## 9 — Automatizar con cron

Ejemplo crontab (para `/etc/cron.d/rsnapshot` o crontab de root). Un esquema típico:

```
## /etc/cron.d/rsnapshot (ejemplo)
0 * * * * root /usr/bin/rsnapshot hourly
30 3 * * * root /usr/bin/rsnapshot daily
0 4 * * 0 root /usr/bin/rsnapshot weekly
```

Ajusta intervalos y horarios según tamaño y ventana de mantenimiento.

---

## 10 — Buenas prácticas y seguridad

* **Prueba siempre con `--dry-run` o `rsnapshot -t`** antes de activar cron.
* Si la clave es **sin passphrase**, limita el `authorized_keys` (opciones `from=`, `no-pty`, `command=`) para reducir riesgo.
* Usa `sudoers` para permitir ejecutar solo `/usr/bin/rsync` por parte del `backupuser` en remoto si necesitas respaldo de ficheros root. Esto es la práctica recomendada en muchos despliegues rsnapshot. ([Unix & Linux Stack Exchange][2])
* Vigila el uso de disco en `snapshot_root`, y controla exclusiones (`exclude`/`exclude_file`) para no copiar archivos temporales o grandes innecesarios.
* Haz rotación/monitoreo y alertas si los backups fallan (logrotate, alertas por correo en caso de error en cron).

---

## 11 — Ejercicios prácticos propuestos (guion para aula)

1. **Ejercicio 1 (30 min):** Genera una clave con `ssh-keygen` (acepta valores por defecto), instala la clave pública en remoteserver y prueba `ssh` sin contraseña. Comprueba name/type por defecto. (Verifica con `ssh -v` que usa `id_ed25519`).

   * Comprobar en `backupserver`: `ssh -v backupuser@remoteserver` → inspecciona qué fichero de identidad intenta.

2. **Ejercicio 2 (30 min):** Hacer un `rsync --dry-run` desde remoteserver:/home a /tmp/backup-test; luego ejecutar real y comprobar permisos y UID/GID con `--numeric-ids`.

3. **Ejercicio 3 (45 min):** Configurar un `rsnapshot.conf` mínimo, añadir dos `backup` points (p. ej. `/etc` y `/home` de remoteserver), ejecutar `sudo rsnapshot -t hourly` y luego `sudo rsnapshot hourly` y revisar `/var/backups/rsnapshot` (o `snapshot_root`) para ver los enlaces duros (hard links).

4. **Ejercicio 4 (opcional, seguridad, 30 min):** Configurar `sudoers` en remoteserver para que `backupuser` pueda ejecutar `/usr/bin/rsync` sin contraseña y ajustar `rsync_long_args` con `--rsync-path="sudo rsync"`. Probar que se copian ficheros que requieren root.

5. **Ejercicio 5 (30 min):** Forzar fallo (por ejemplo, cambiar permisos en destino) y revisar los logs para aprender a interpretar errores y recuperar.

---

## 12 — Problemas comunes y solución rápida

* **SSH pide contraseña**: la clave pública no se instaló correctamente o el `ssh` está buscando otra identidad. Ver `ssh -v` para diagnosticar. Confirma permisos `~/.ssh` (700) y `authorized_keys` (600).
* **rsnapshot dice error al parsear / backup line**: comprueba separadores (deben ser `TAB`, no espacios) en las líneas `backup`. Usa `rsnapshot configtest`. ([Server Fault][4])
* **Errores de permisos al rsync**: si necesitas leer archivos de root en remoto, usa `--rsync-path="sudo rsync"` y configura `sudoers` para `/usr/bin/rsync`.

## 14.  Dónde ejecutar rsnapshot

### 1. Ejecutar **rsnapshot en el servidor de backup**

**Es la opción más común y recomendable**.

#### ✅  Ventajas

* **Centralización**: todas las tareas de backup (configuración, logs, rotación, retención) se gestionan en un solo sitio.
* **Más seguro**: el servidor de backup accede a las máquinas de origen *solo en lectura*, mediante SSH con clave pública.
* **Ahorra recursos** en los equipos de origen (no cargan con procesos de copia ni de rotación).
* **Fácil de automatizar** con `cron` o `systemd` timers.
* **Mejor integridad**: si una máquina de origen falla o se borra algo, el backup sigue disponible en el servidor.

#### ⚠️ Requisitos

* El servidor de backup debe poder conectarse **por SSH sin contraseña** a los equipos origen (`backupuser@remoteserver` en tu caso).
* Las rutas en `rsnapshot.conf` deben usar el prefijo SSH, por ejemplo:

  ```
  backup  backupuser@remoteserver.example.com:/home/usuario/  remoto/
  ```

---

### 2. Ejecutar **rsnapshot en cada máquina origen**

(Es decir, que cada equipo guarde sus propias copias locales o en red)

#### ✅ Ventajas

* Menos exposición de red: no se necesita que el servidor acceda por SSH a los equipos origen.
* Puede ser útil si las máquinas están **aisladas o sin acceso saliente**.

#### ⚠️ Desventajas

* **Gestión dispersa**: cada máquina tiene su propia configuración, logs, retenciones y programaciones.
* **Mayor riesgo de pérdida**: si una máquina falla, pierdes sus backups locales.
* **Más mantenimiento**: actualizaciones y comprobaciones duplicadas en muchos sistemas.

---

### ⚖️ **Conclusión**

> 💡 Lo mejor es usar **rsnapshot en el servidor de backup**, conectando a las máquinas origen por SSH con clave pública.

Así:

* Las máquinas origen no necesitan scripts ni tareas cron.
* El servidor mantiene versiones históricas con poco espacio (gracias a los hardlinks).
* Puedes restaurar datos fácilmente desde un único punto.

