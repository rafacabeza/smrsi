# Párctica de creación de RAID en Windows y Linux

Copia este texto en un documento de word u open office. 
Realiza la práctica y toma capturas de pantalla explicativas que debes pegar en cada uno de los pasos realizados.

# PARTE 1: Configuración de RAID 1 en Ubuntu Server (VirtualBox)

## 1. Introducción

**RAID 1 (mirroring)** es una configuración de almacenamiento redundante que **duplica los datos en dos discos**. Si uno falla, el sistema puede seguir funcionando con el otro.
En esta práctica configuraremos **RAID 1 por software** en **Ubuntu Server** dentro de **VirtualBox**.

---

## 2. Requisitos previos

* **VirtualBox** instalado en tu equipo.
* **ISO de Ubuntu Server** (por ejemplo, Ubuntu Server 24.04).
* Una **máquina virtual** con:

  * 1 disco principal para el sistema (por ejemplo, 20 GB).
  * 2 discos adicionales **idénticos** (por ejemplo, 4 GB cada uno) para el RAID.

---

## 3. Crear discos virtuales en VirtualBox

1. Abre la configuración de tu máquina virtual.
2. Ve a **Almacenamiento → Controladora SATA → Agregar disco duro**.
3. Crea dos discos nuevos de tamaño igual (por ejemplo, 4 GB).
4. Asegúrate de que ambos aparezcan conectados antes de iniciar la máquina.

---

## 4. Verificar los discos en Ubuntu

Inicia la máquina y entra con tu usuario.
Comprueba los discos disponibles:

```bash
sudo fdisk -l
```

Deberías ver algo como:

```
/dev/sda  -> disco del sistema
/dev/sdb  -> disco 1 del RAID
/dev/sdc  -> disco 2 del RAID
```

---

## 5. Instalar la herramienta `mdadm`

`mdadm` es el programa que gestiona RAID por software en Linux.

```bash
sudo apt update
sudo apt install mdadm -y
```

---

## 6. Crear las particiones para RAID

Usa `fdisk` para crear una partición en cada disco de datos:

```bash
sudo fdisk /dev/sdb
```

Dentro de `fdisk`:

```
n   → nueva partición
p   → primaria
1   → número de partición
Enter → usar inicio por defecto
Enter → usar tamaño completo
t   → cambiar tipo
fd  → Linux RAID autodetect
w   → guardar cambios
```

Repite lo mismo para `/dev/sdc`.

---

## 7. Crear el array RAID 1

```bash
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

Confirma con `y` si te pregunta.

Verifica el estado:

```bash
cat /proc/mdstat
```

---

## 8. Crear el sistema de archivos y montar

Formatea el volumen RAID:

```bash
sudo mkfs.ext4 /dev/md0
```

Crea un punto de montaje y móntalo:

```bash
sudo mkdir /mnt/raid1
sudo mount /dev/md0 /mnt/raid1
```

Comprueba:

```bash
df -h
```

---

## 9. Guardar la configuración RAID

Para que el RAID se monte automáticamente al reiniciar:

```bash
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

Añade la entrada al archivo `/etc/fstab`:

```bash
sudo blkid
```

Copia el **UUID** de `/dev/md0` y edita el fichero:

```bash
sudo nano /etc/fstab
```

Agrega al final:

```
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  /mnt/raid1  ext4  defaults  0  0
```

---

## 10. Verificación

Reinicia el sistema y verifica que el RAID se monte correctamente:

```bash
mount | grep md0
```

Y comprueba el estado del RAID:

```bash
sudo mdadm --detail /dev/md0
```

---

## 11. Simular fallo de disco (opcional)

Para probar la tolerancia a fallos:

```bash
sudo mdadm --manage /dev/md0 --fail /dev/sdb1
sudo mdadm --detail /dev/md0
```

Para eliminar y reemplazar el disco:

```bash
sudo mdadm --manage /dev/md0 --remove /dev/sdb1
sudo mdadm --manage /dev/md0 --add /dev/sdb1
```

## PARTE 2: Configuración de RAID 5 en Ubuntu.

- Elabora una guía para configurar una uniad RAID 5 utilizando 3 discos duros.
- Puedes usar chatgpt pero los pasos serán casi idénticos a los de RAID 1 y la herramienta que uses debe ser la misma: mdadm (además de fdisk, mkfs.ext4, mount, nano, ...)

# PARTE 3: Configuración de RAID 1 (Espejo) en Windows 10

## 1. Introducción

**RAID 1 (mirroring)** es una configuración de almacenamiento redundante que **duplica los datos en dos discos**. Si uno falla, el sistema puede seguir funcionando con el otro.
En esta práctica configuraremos **RAID 1 por software** en **Windows 10** dentro de **VirtualBox**, sin necesidad de una controladora RAID.

---

## 2. Requisitos previos

* Un equipo con **Windows 10 Pro o superior**.
  (Las ediciones *Home* no incluyen la opción de discos dinámicos).
* 2 discos adicionales **idénticos** (por ejemplo, 4 GB cada uno) para el RAID.
* Derechos de administrador.

💡 En **VirtualBox**, puedes añadir dos discos adicionales a la máquina virtual desde:

> **Configuración → Almacenamiento → Controladora SATA → Agregar disco duro**

---

## 3. Verificar los discos

1. Inicia Windows 10.
2. Pulsa `Win + X` → selecciona **Administración de discos**.
3. Deberías ver:

   * Disco 0 → Sistema (C:)
   * Disco 1 y Disco 2 → Vacíos (sin asignar)

Si aparecen ventanas emergentes para inicializarlos:

* Selecciona **GPT (GUID Partition Table)**.
* No crees particiones todavía.

---

## 4. Convertir los discos a “dinámicos”

Windows usa **discos dinámicos** para crear volúmenes RAID por software.

1. En la **Administración de discos**, haz clic derecho sobre **Disco 1** → **Convertir en disco dinámico...**
2. Marca **Disco 1 y Disco 2** → **Aceptar**.

> ⚠️ Este paso borrará las particiones si las hay. Asegúrate de no tener datos en esos discos.

---

## 5. Crear el volumen reflejado (RAID 1)

1. Haz clic derecho en el **espacio no asignado** de uno de los discos dinámicos.
2. Elige **Nuevo volumen reflejado...**
3. Se abre el **Asistente para nuevo volumen reflejado**:

   * Selecciona los **dos discos**.
   * Asigna una letra de unidad (por ejemplo, **E:**).
   * Formatea con **NTFS** y asigna una etiqueta (por ejemplo, `RAID1`).
4. Haz clic en **Finalizar**.

Windows sincronizará ambos discos; durante ese tiempo el estado será **Sincronizando**.

---

## 6. Verificar el estado del RAID

En la **Administración de discos**, verás algo como:

```
Disco 1  Dinámico  4 GB  Reflejado (E:)
Disco 2  Dinámico  4 GB  Reflejado (E:)
```

* Ambos discos mostrarán el mismo volumen “Reflejado”.
* Puedes escribir o borrar archivos y los cambios se duplican automáticamente.

---

## 7. Probar la tolerancia a fallos (opcional)

1. Apaga la máquina virtual.
2. Desconecta uno de los discos RAID (por ejemplo, quita el Disco 2 desde VirtualBox).
3. Inicia Windows:

   * El sistema mostrará que el **volumen reflejado está degradado**, pero aún accesible.

4. Con la máquina apagada, añade un nuevo disco del mismo tamaño.
5. Selecciona **Activar disco** desde la Administración de discos para que Windows lo sincronice.

---

## 8. Comandos alternativos (PowerShell)

**NO HACER:**

Puedes crear y administrar RAID 1 también con **PowerShell**:

```powershell
Get-PhysicalDisk
```

→ Muestra los discos disponibles.

```powershell
New-StoragePool -FriendlyName "MiRAID1" -StorageSubsystemFriendlyName "Storage Spaces*" -PhysicalDisks (Get-PhysicalDisk -CanPool $True)
```

Luego crea el volumen reflejado:

```powershell
New-VirtualDisk -StoragePoolFriendlyName "MiRAID1" -FriendlyName "VolumenRAID1" -ResiliencySettingName Mirror -Size 40GB
```

Y finalmente:

```powershell
Initialize-Disk -VirtualDisk (Get-VirtualDisk -FriendlyName "VolumenRAID1")
New-Partition -DiskNumber 3 -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "RAID1"
```

---

## 9. Recomendación final

Para **entornos reales de empresa**, se recomienda:

* Usar **RAID por hardware** (controladora dedicada).
* O soluciones **NAS** con soporte nativo de RAID (Synology, QNAP, TrueNAS, etc.).
