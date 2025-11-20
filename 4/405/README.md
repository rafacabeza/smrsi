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

* Vamos a usar dos máquinas. Un ubuntu server que se llama **isard**, un ubunt desktop que se llama **ubuntu22**.
* El ubuntu server debe tener el servicio ssh activo. Compruébalo. Abre sesión y verifica que es así:
  * `sudo systemctl status ssh`, debe indicar que el servicio está activo
  * `ss -ltn` debe mostrar el puerto 22 en espera.
* En ambas: `rsync` instalado. Compruebalo con el comando `rsync -V`.
* En la máquina de ubuntu22: `rsnapshot` instalado. Compruébalo usando `rsnapshot version`

---

## Nota sobre claves y conexión SSH

Vamos a conectar los usuarios isard y root de "ubuntu22" a la máquina "isard":

- Prueba la conexión como "isard"

```bash
ssh isard@server
```

- OJO Si no funciona, deberías hacer la configuración siguiente:

```bash
ssh-keygen
ssh-copy-id isard@server
#ojo, puedes cambiar server por su IP
#Prueba la conexión sin contraseña:
ssh isard@server
```

- Configura la conexión como root. Debemos hacer el intercambio de claves del root, el que teníamos es del usuario "isard":

```bash
sudo su
ssh-keygen
ssh-copy-id isard@server
#ojo, puedes cambiar server por su IP
#Prueba la conexión sin contraseña:
ssh isard@server
```
---

## 1 — Carpetas de datos

Crea las siguientes carpetas que vamos a usar como origen de datos:

- En ubuntu22: `/home/isard/origen`

```bash
mkdir origen
```

- En el server isard: `/home/isard/datos`

```bash
sudo mkdir datos
```

Guarda en ellas algunos ficheros. Puedes usar `touch` o `echo`

---

## 2 — Carpetas de destino:

- Vamos a hacer dos copias de seguridad. Las dos dentro de la máquina ubuntu22
  - Una copia en `/home/isard/backup`. Créala. La vamos a usar con "rsync".
  - Una copia en `/backup`, créala usando sudo porque será propiedad del root. Vamos a usarla con "rsnapshot".


## 3 — Copias con rsync

Vamos a sincronizar las dos carpetas: `origen` (local) y `datos` (remota). Queremos que estén sincronizadas en `/home/isard/backup`

### Sincronización manual

```bash
#copia de la carpeta local
#copia inicial
rsync -avz /home/isard/origen/ /home/isard/backup/origen/  
#para reflejar los ficheros borrados en ejecuciones posteriores
rsync -avz --delete /home/isard/origen/ /home/isard/backup/origen/  

#copia de la carpeta remota
#copia inicial
rsync -avz isard@server:~/datos/ /home/isard/backup/datos/  
#para reflejar los ficheros borrados en ejecuciones posteriores
rsync -avz --delete isard@server:~/datos/ /home/isard/backup/datos/  
```

### Sincronización automática

Necesitamos editar el "crontab". Ejecutamos `crontab -e`

Vamos a hacerla cada minuto. Ahí tienes el comando de ejemplo. Fíjate en las rutas de arriba y ajusta el crontab:

```bash
* * * * * /usr/bin/rsync -av /ruta/origen/ /ruta/destino/
```

Haz algún cambio y espera un minuto para ver que los cambios se sincronizan.


## 4 — Copias con rsnapshot

- Hay que editar el fichero /etc/rsnapshot. 
- Vamos a ajustar algunas cosas:
- La carpeta destino de nuestras copias:

```
#¡ojo, usa tabuladores y no espacios!
snapshot_root   /backup
```
- Hay que descomentar la línea siguiente para que rsnapshot pueda usar ssh

```
cmd_ssh   /usr/bin/ssh
```

- Ajusta los intervalos de rotación: 7 copias diarias, 4 semanales, 12 mensuales. Busca la parte de "BACKUP LEVELS":

```
# De nuevo, tabuladores y no espacios!
retain		daily   7
retain		weekly  4
retain		monthly 12
```

- Ajusta los elementos de backup:

```
backup  /home/isard/origen/               origen/
backup  isard@server:/home/isard/datos/   datos/
```

- Comprueba que la sintaxis es correcta:

```
rsnapshot configtest
```

- Si es correcta prueba la ejecución de rsnapshot con sus diferentes niveles y comprueba que las copias se hacen correctamente:

```
rsnapshot daily
rsnapshot weekly
```


#### Vamos a ver cómo automarizar las copias

Instrucciones típicas de cron para ejecutar rsnapshot. Observa que:

- A las 3 se hace copia diaria
- A las 4, los domingos, se hace copia semanal (se toma la más antigua diaria y se nombra como semanal)
- A las 5 de todos los días 1 de mes, se hace la copia mensual tomando la semanal disponibe más antigua

```
# Con crontab -e. Debemos indicar el usuario root

0 3 * * *    root    /usr/bin/rsnapshot daily
0 4 * * 0    root    /usr/bin/rsnapshot weekly
0 5 1 * *    root    /usr/bin/rsnapshot monthly

# Con sudo crontab -e ya está implícito el uso de root.

0 3 * * * /usr/bin/rsnapshot daily
0 4 * * 0 /usr/bin/rsnapshot weekly
0 5 1 * * /usr/bin/rsnapshot monthly
```

- ¿Qué deberías cambiar en rsnapshot.conf para que se guardaran copias de los últimos 5 años?
- ¿Y en cron?
