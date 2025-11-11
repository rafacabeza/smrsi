# Tutorial Básico SSH

SSH es uno de los temas que tratarás en el módulo **Servicios en Red**. No se trata de estudiar dos veces lo mismo, pero esta es una herramienta muy usada en copias de seguridad remota. Por ese motivo vamos a ver de forma rápida qué es y cómo usar SSH.

## ¿Qué es SSH?

**SSH (Secure Shell)** es un protocolo que permite **conectarse de forma segura a otra máquina a través de la red**, normalmente para administrar servidores Linux o transferir archivos.

Proporciona:

* **Autenticación cifrada** (usuario/contraseña o clave pública/privada)
* **Comunicación segura** (todo el tráfico viaja cifrado)
* **Ejecución remota de comandos**
* **Transferencia de archivos (scp, sftp)**

---

## Plataformas donde se puede usar SSH

| Plataforma                               | Cliente SSH disponible                           | Servidor SSH disponible                                                               |
| ---------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------- |
| **Linux (Ubuntu, Debian, Fedora, etc.)** | ✅ (preinstalado normalmente)                     | ✅ (instalable con `openssh-server`)                                                   |
| **macOS**                                | ✅ (cliente integrado)                            | ✅ (opcional, en Preferencias del Sistema o con `sudo systemsetup -setremotelogin on`) |
| **Windows 10/11**                        | ✅ (cliente integrado en PowerShell y CMD)        | ✅ (servidor opcional desde “Características opcionales”)                              |
| **Android / iOS**                        | Aplicaciones como Termius, JuiceSSH, Blink, etc. | ❌ (solo cliente)                                                                      |

---

## Instalación en Ubuntu

En Ubuntu, SSH se compone de dos partes:

1. **Cliente SSH** – se usa para conectarse a otros equipos.
   Normalmente ya viene instalado. Puedes comprobarlo con:

   ```bash
   ssh -V
   ```

2. **Servidor SSH (para aceptar conexiones remotas)**
   Puedes comprobar si ya lo tienes instalado:

   ```bash
   sudo systemctl status ssh
   ss -ltn # comprobar si hay alguna línea con el puerto 22
   ```

   Instálalo con:

   ```bash
   sudo apt update
   sudo apt install openssh-server
   ```

   Luego verifica su estado:

   ```bash
   sudo systemctl status ssh
   ```

   Si no está activo, inícialo con:

   ```bash
   sudo systemctl enable --now ssh
   ```

---

## Conexión desde un equipo remoto

Sintaxis básica:

```bash
ssh usuario@ip_del_servidor
```

Por ejemplo:

```bash
ssh juan@192.168.1.100
```

El sistema te pedirá la contraseña del usuario remoto (a menos que tengas configurada autenticación sin clave).

> OJO!! Antes de aceptar el fingerprint mira el siguiente apartado

---

## Comprobación del “fingerprint” (huella digital)

La **primera vez** que te conectas por SSH, aparece un mensaje como este:

```
The authenticity of host '192.168.1.100 (192.168.1.100)' can't be established.
ED25519 key fingerprint is SHA256:abcd1234...
Are you sure you want to continue connecting (yes/no)?
```

👉 Antes de aceptar, puedes **verificar el fingerprint del servidor** desde el propio servidor:

```bash
sudo ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub
```

Ejemplo de salida:

```
256 SHA256:abcd1234... root@servidor (ED25519)
```

Debes comparar este valor con el que aparece en tu cliente.
Si coinciden, puedes escribir `yes` y continuar.
El fingerprint se guarda en `~/.ssh/known_hosts` para futuras conexiones.

---

## Copiar archivos con `scp`

`scp` (secure copy) permite **transferir archivos** cifrados entre equipos.

**De local a remoto:**

```bash
scp archivo.txt usuario@192.168.1.100:/home/usuario/
```

**De remoto a local:**

```bash
scp usuario@192.168.1.100:/home/usuario/archivo.txt .
```

**Copiar carpetas recursivamente:**

```bash
scp -r carpeta/ usuario@192.168.1.100:/home/usuario/
```

---

## Conexión sin contraseña (autenticación con claves)

Esto permite conectarte sin introducir la contraseña cada vez, usando **claves asimétricas**.

### 1. Generar las claves en tu cliente

En tu máquina local:

```bash
ssh-keygen
```

(Solo pulsa Enter para aceptar los valores por defecto y no establecer passphrase.)

Esto crea:

```
~/.ssh/id_rsa        ← clave privada
~/.ssh/id_rsa.pub    ← clave pública
```

### 2. Copiar la clave pública al servidor

```bash
ssh-copy-id usuario@192.168.1.100
```

(O manualmente con:)

```bash
cat ~/.ssh/id_rsa.pub | ssh usuario@192.168.1.100 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 3. Probar la conexión sin contraseña

```bash
ssh usuario@192.168.1.100
```

Ahora no debería pedirte la contraseña 🎉

---

## Resumen rápido

| Acción                   | Comando                                                   |
| ------------------------ | --------------------------------------------------------- |
| Instalar servidor SSH    | `sudo apt install openssh-server`                         |
| Ver estado               | `sudo systemctl status ssh`                               |
| Conectarse               | `ssh usuario@host`                                        |
| Copiar archivo           | `scp origen destino`                                      |
| Ver fingerprint          | `sudo ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub` |
| Crear claves             | `ssh-keygen`                                              |
| Copiar clave al servidor | `ssh-copy-id usuario@servidor`                            |
