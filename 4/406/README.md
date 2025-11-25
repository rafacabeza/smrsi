# 406 Práctica de Restic

##  📌  **0. Situación de partida**

### **Objetivos de la práctica**

Los alumnos aprenderán a:

1. Inicializar repositorios Restic (local y remoto).
2. Configurar variables de entorno y contraseñas.
3. Hacer backups manuales.
4. Ejecutar políticas de retención con `forget --prune`.
5. Automatizar las copias en Linux y Windows.
6. Restaurar ficheros y carpetas.
7. Montar un repositorio backup como unidad.

### **Máquinas necesarias**

Máquinas que vamos a usar:

* **1 servidor Ubuntu** (192.168.100.1)
* **1 cliente Ubuntu** (192.168.100.10)
* **1 cliente Windows** (192.168.100.11)

---

## 🧩 **1. Preparación del servidor Ubuntu — IP 192.168.100.1**

### 1.1 Crear usuario "backupuser"

```bash
sudo adduser backupuser
```

### 1.2 Crear carpeta para repositorios Restic

```bash
sudo mkdir /backups
sudo chown backupuser:backupuser /backups
```

El servidor **solo guarda datos**, no ejecuta Restic.

---

## 🧩 **2. Cliente Ubuntu — IP 192.168.100.10**

### 2.1 Instalar Restic

```bash
sudo apt update
sudo apt install restic -y
```

---

### 2.2 Crear repositorio local

Ejemplo en `/home/isard/backup_local`:

```bash
mkdir /home/isard/backup_local
restic init -r /home/isard/backup_local
## init → inicializa un repositorio vacío
## -r ruta → indica dónde crear el repositorio
```

---

### 2.3 Crear repositorio remoto

Usa SSH:

```bash
#OJO. El repositorio debe existir
restic init -r sftp:backupuser@192.168.100.1:/backups/ubuntu10
```

---

### 2.4 Guardar contraseña en archivo + variables temporales

```bash
echo "Alumno123" > ~/.restic_pass
chmod 600 ~/.restic_pass
```

Variables para usar repositorio remoto:

```bash
export RESTIC_PASSWORD_FILE=~/.restic_pass
export RESTIC_REPOSITORY="sftp:backupuser@192.168.100.1:/backups/ubuntu10"
```

---

## 🧩 **3. Cliente Windows — IP 192.168.100.11**

### 3.1 Instalar Restic

Descargar `restic.exe` y colocarlo en:

```
C:\Windows\System32\
```

(para que funcione desde cualquier ruta).

---

### 3.2 Crear repositorio local

```powershell
mkdir  C:\backup_local
restic init -r C:\backup_local
```

---

### 3.3 Crear repositorio remoto (vía SSH)

Instala **OpenSSH client** (Windows 10/11 ya incluye OpenSSH).

```powershell
restic init -r sftp:backupuser@192.168.100.1:/backups/windows11
```

---

### 3.4 Variables de entorno permanentes (repositorio remoto)

Contraseña en archivo:

```
C:\Users\Alumno\.restic_pass
```

En PowerShell:

```powershell
[System.Environment]::SetEnvironmentVariable("RESTIC_PASSWORD_FILE","C:\Users\Alumno\.restic_pass","User")
[System.Environment]::SetEnvironmentVariable("RESTIC_REPOSITORY","sftp:backupuser@192.168.100.1:/backups/windows11","User")
```

Reabrir PowerShell.

---

## 🧩 **4. Backups manuales (Ubuntu y Windows)**

### 4.1 Backup de una carpeta

Ubuntu:

```bash
restic backup /home/isard/Documentos
## backup → realiza la copia
## ruta → carpeta o archivo a guardar
```

Windows:

```powershell
restic backup C:\Users\Alumno\Documents
```

### 4.2 Backup de varias carpetas con etiquetas

```bash
restic backup ~/Documentos ~/Fotos --tag diario --tag ubuntu
```

Windows:

```powershell
restic backup C:\Docs C:\Fotos --tag diario --tag windows
```

---

## 🧩 **5. Política de retención con `forget --prune`**

### 5.1 Mantener últimos 7 snapshots diarios

```bash
restic forget --keep-daily 7 --prune
## forget → selecciona snapshots a eliminar
## --prune → elimina físicamente los datos sobrantes
```

### 5.2 Mantener:

* 7 diarios
* 4 semanales
* 6 mensuales

```bash
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

Recomendación: **probar antes con dry-run**:

```bash
restic forget --keep-daily 7 --dry-run
```

---

## 🧩 **6. Automatización de copias**

### 6.1 Linux – cron

Editar crontab:

```bash
crontab -e
```

Añadir:

```bash
0 */6 * * * restic backup /home/isard/Documentos --tag auto
## Cada 6 horas
```

---

### 6.2 Windows – Programador de tareas

1. Abrir **"Task Scheduler"**
2. Crear tarea básica
3. Acción → **Start a Program**
4. Programa:

```
restic.exe
```

Argumentos:

```
backup C:\Users\Alumno\Documents --tag auto
```

---

## 🧩 **7. Consultar snapshots**

Listar todos:

```bash
restic snapshots
```

Listar solo del host:

```bash
restic snapshots --host pc-ubuntu
```

Listar por etiqueta:

```bash
restic snapshots --tag diario
```

---

## 🧩 **8. Restaurar datos**

### 8.1 Restaurar un archivo específico

```bash
restic restore latest --target /tmp/restore --include "/home/isard/Documentos/ejemplo.txt"
```

Windows:

```powershell
restic restore latest --target C:\restore --include "C:\Users\Alumno\Documents\ejemplo.txt"
```

---

### 8.2 Restaurar carpeta completa

```bash
restic restore latest --target /tmp/restore
```

---

## 🧩 **9. Montar un repositorio como unidad**

Esta parte es **interesante y práctica**, porque se ve el contendido de los snapshots como un “explorador de backups”.

### 9.1 Ubuntu

```bash
mkdir ~/mnt_backup
restic mount ~/mnt_backup
```

* Podrán navegar como si fuese un filesystem:
  `/snapshots/ID/`
  `/latest/`
  `/hosts/`
  `/tags/`

Desmontar:

```bash
fusermount -u ~/mnt_backup
```

---

### 9.2 Windows

Requiere **WinFsp** + **restic mount**

Instalar WinFsp → montar:

```powershell
restic mount R:
```

Se vería como una unidad “R:”.
