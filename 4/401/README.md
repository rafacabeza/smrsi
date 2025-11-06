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

Perfecto 👍 Aquí tienes la **guía en formato Markdown** para configurar **RAID 1 (espejo)** en **Windows 11**, ideal para tus alumnos del módulo **IFC201 – Seguridad informática**.
Está pensada para usar **VirtualBox**, pero también aplica a equipos físicos.

---

# Guía: Configuración de RAID 1 (espejo) en Windows 11

## 1. Introducción

El **RAID 1**, también llamado **espejo**, consiste en **duplicar los datos en dos discos**.
Si uno de ellos falla, el sistema puede seguir funcionando con el otro sin pérdida de información.
En Windows 11, esta configuración se puede realizar con **Discos dinámicos** o con **Espacios de almacenamiento**.

---

## 2. Requisitos previos

* Windows 11 instalado (preferiblemente en una máquina virtual o equipo de pruebas).
* **Dos discos secundarios** de igual tamaño para crear el RAID (por ejemplo, 4 GB cada uno).
* **Permisos de administrador** en el sistema.

---

## 3. Crear los discos en VirtualBox

1. Abre la configuración de tu máquina virtual.
2. Ve a **Almacenamiento → Controladora SATA → Agregar disco duro**.
3. Crea **dos discos nuevos** (por ejemplo, 4 GB cada uno).
4. Inicia Windows 11.

---

## 4. Comprobar los discos en Windows

1. Abre el **Administrador de discos**:

   * Pulsa `Win + X` → selecciona **Administración de discos**
   * O ejecuta `diskmgmt.msc` desde el menú Inicio.
2. Deberías ver:

   * Disco 0 → el disco del sistema.
   * Disco 1 y Disco 2 → los discos nuevos sin inicializar.

---

## 5. Inicializar los discos

1. Si aparece una ventana para **inicializar discos**, selecciona **GPT (GUID Partition Table)**.
2. Si no aparece, haz clic derecho sobre cada disco → **Inicializar disco** → GPT.
3. Luego, clic derecho sobre el área “No asignado” → **Nuevo volumen simple** y **no lo formatees aún** (solo verifica que funcionan).

---

## 6. Convertir los discos a dinámicos

Para crear un RAID 1 por software, los discos deben ser **dinámicos**.

1. En el **Administrador de discos**, clic derecho sobre **Disco 1** → **Convertir en disco dinámico**.
2. Marca **Disco 1** y **Disco 2**, y acepta.
3. Espera a que el sistema complete la conversión.

---

## 7. Crear el volumen reflejado (RAID 1)

1. Clic derecho sobre el espacio **no asignado** de uno de los discos dinámicos → **Nuevo volumen reflejado**.
2. Se abrirá el asistente:

   * Añade **Disco 1** y **Disco 2** al espejo.
   * Asigna una letra de unidad (por ejemplo, `E:`).
   * Formatea en **NTFS** y ponle un nombre (por ejemplo, `RAID1_DATOS`).
3. Pulsa **Finalizar** y confirma el aviso de conversión a dinámico.

💡 Windows empezará a **sincronizar los discos** automáticamente.
Durante ese proceso, el estado mostrará “**Sincronizando**”.

---

## 8. Verificar el RAID 1

1. En el Administrador de discos, el volumen aparecerá como:

   ```
   Reflejado (E:)  NTFS  Correcto (Sincronizado)
   ```
2. Puedes comprobarlo también desde **Explorador de archivos → Este equipo**:

   * Aparece la nueva unidad `E:` con el nombre `RAID1_DATOS`.

---

## 9. Probar la redundancia (opcional)

Para simular un fallo:

1. Apaga la máquina virtual.
2. En VirtualBox, **desconecta uno de los discos RAID**.
3. Inicia Windows: el volumen reflejado seguirá accesible (pero en modo degradado).
4. Si reconectas el disco, Windows lo volverá a sincronizar automáticamente.

---

## 10. Alternativa moderna: Espacios de almacenamiento


Windows 11 también permite crear espejos mediante **Espacios de almacenamiento**, una interfaz más sencilla:

1. Con la máquina parada añade dos discos nuevos para crear otro RAID 1.
2. Abre **Panel de control → Sistema y seguridad → Espacios de almacenamiento**.
3. Haz clic en **Crear un nuevo grupo y espacio de almacenamiento**.
4. Selecciona los dos discos y elige:

   * **Resiliencia: Espejo bidireccional (RAID 1)**
   * **Sistema de archivos: NTFS**
5. Asigna un nombre y una letra de unidad.
6. Crea el espacio: Windows lo gestionará automáticamente.

Ventajas:

* Más fácil de usar.
* Permite ampliar o reemplazar discos fácilmente.
* Admite unidades de distinto tamaño.

---

## 11. Conclusión

Has configurado un **RAID 1 (espejo)** en Windows 11 utilizando discos virtuales.
Esta técnica proporciona **redundancia de datos**, protegiendo la información frente a fallos de disco, aunque **no aumenta el rendimiento ni la capacidad total**.

---

## 12. Comandos útiles (PowerShell)

**NO HACER**

Si prefieres hacerlo por línea de comandos:

```powershell
# Ver discos disponibles
Get-Disk

# Convertir discos a dinámicos
Set-Disk -Number 1 -IsDynamic $true
Set-Disk -Number 2 -IsDynamic $true

# Crear volumen reflejado (RAID 1)
New-Volume -DiskNumber 1,2 -FriendlyName "RAID1_DATOS" -FileSystem NTFS -DriveLetter E -StoragePoolFriendlyName "Primordial" -ResiliencySettingName Mirror
```

