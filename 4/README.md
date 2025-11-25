# Seguridad pasiva: Dispositivos de almacenamiento y seguridad de los datos

## Introducción

La **seguridad pasiva** busca **proteger la información y los equipos frente a pérdidas, fallos o accesos no autorizados**, sin intervenir directamente en el funcionamiento normal del sistema.
Incluye medidas como el uso adecuado de **dispositivos de almacenamiento**, **copias de seguridad**, **cifrado** o **redundancia** de datos.

---

## Conceptos sobre el alojamiento

El **alojamiento de datos** se refiere al **lugar físico o lógico donde se guardan los archivos** de un sistema.
Se deben tener en cuenta varios factores:

* **Dispositivo:** tipo de hardware donde se almacenan los datos (disco duro, SSD, cinta, etc.).
* **Soporte:** medio físico en el que se graban los datos. 
* **Rendimiento:** velocidad de acceso y transferencia.
* **Disponibilidad:** posibilidad de acceder a la información cuando se necesita.
* **Accesibilidad física:** facilidad o dificultad de acceso físico al dispositivo (local, remoto, extraíble).

---

### **Principales dispositivos y soportes. Características**

| **Tipo**                 | **Ejemplo**                    | **Ventajas**                       | **Inconvenientes**                                    |
| ------------------------ | ------------------------------ | ---------------------------------- | ----------------------------------------------------- |
| **Discos duros (HDD)**   | SATA, SAS                      | Gran capacidad, bajo coste         | Mecánicos, sensibles a golpes                         |
| **Unidades SSD**         | NVMe, SATA                     | Alta velocidad, sin partes móviles | Más caros, vida útil limitada por ciclos de escritura |
| **Cintas magnéticas**    | LTO                            | Muy alta capacidad, duraderas      | Acceso secuencial, lentas                             |
| **DVD / Blu-ray**        | -                              | Bajo coste, buena conservación     | Capacidad limitada                                    |
| **Memorias USB / SD**    | -                              | Portátiles y rápidas               | Riesgo de pérdida o daño físico                       |
| **Nube (Cloud Storage)** | Google Drive, OneDrive, AWS S3 | Acceso remoto, sincronización      | Depende de Internet, coste recurrente                 |

---

## **Tipos de almacenamiento**

| **Tipo**             | **Descripción**                                                       |
| -------------------- | --------------------------------------------------------------------- |
| **Primario**         | Memoria RAM: temporal y volátil, no se usa para copias de seguridad.  |
| **Secundario**       | Almacenamiento persistente (discos, SSD).                             |
| **Terciario**        | Medios de archivado (cintas, Blu-ray).                                |
| **En red (NAS/SAN)** | Acceso compartido por red local o Internet.                           |
| **En la nube**       | Espacio de almacenamiento remoto gestionado por un proveedor externo. |

---

## **Almacenamiento redundante y distribuido**

Para garantizar la **disponibilidad y seguridad de los datos**, se utilizan técnicas de **redundancia** y **distribución**:

* **RAID (Redundant Array of Independent Disks):** combina varios discos para mejorar rendimiento o tolerancia a fallos.

  * **RAID 0:** velocidad (sin redundancia)
  * **RAID 1:** espejo (seguridad)
  * **RAID 5 / 6:** datos distribuidos con paridad
  * **RAID 10:** combina velocidad y seguridad
* **Almacenamiento distribuido:** los datos se guardan en varios servidores o ubicaciones (como en la nube o en sistemas como Ceph, GlusterFS).

---

## **Almacenamiento remoto y extraíble. Protocolos de almacenamiento en red**

* **Almacenamiento remoto:** el dispositivo se encuentra en otra ubicación y se accede por red (NAS, servidores, nube).
* **Almacenamiento extraíble:** dispositivos portátiles como USB, discos externos o tarjetas SD.

### **Protocolos comunes de almacenamiento en red**

| **Protocolo**                 | **Descripción**                                  | **Uso común**                  |
| ----------------------------- | ------------------------------------------------ | ------------------------------ |
| **NFS (Network File System)** | Compartición de archivos en entornos Linux/Unix. | Servidores Linux               |
| **SMB/CIFS**                  | Compartición de archivos en redes Windows.       | Entornos mixtos                |
| **FTP / SFTP**                | Transferencia de archivos (SFTP con cifrado).    | Copias remotas y mantenimiento |
| **iSCSI**                     | Transmite comandos de disco por IP.              | Redes SAN                      |
| **WebDAV**                    | Acceso a archivos vía HTTP/HTTPS.                | Nube o intranets               |

---

## **Aseguramiento de los datos**

El aseguramiento de los datos busca **mantener su integridad, disponibilidad y confidencialidad**.

---

### **Copia de seguridad**

Una **copia de seguridad (backup)** es una réplica de los datos que permite recuperarlos en caso de pérdida, fallo o ataque.

**Tipos de copia:**

Desde un enfoque tradicional podemos hablar de:

* **Completa:** copia todos los datos.
* **Incremental:** copia solo los datos modificados desde la última copia (completa o incremental).
* **Diferencial:** copia los datos modificados desde la última copia completa.
* **Espejo (mirror):** mantiene una copia exacta en tiempo real.

Hacer una copia completa es costoso, lento pero permite una restauración directa y rápida. Las copias incrementales y diferenciales permiten ocupar menos tamaño en el backup y hacer copias más rápidas pero la restauración se hace más complicada y lenta.

Actualmente hay sistemas más sofisticados que usan el concepto deduplicación. Se trata de copiar sólo lo que ha cambiado como si se tratara de una copia diferencial pero a su vez conseguir que se acceda a la estructura de ficheros como si se hubiera hecho una copia completa.

**Buenas prácticas:**

* Aplicar la regla **3-2-1**:
  3 copias de los datos,
  2 medios distintos,
  1 copia fuera del sitio (offsite o nube).

---

### **Imágenes de respaldo**

Una **imagen de respaldo** es una copia exacta de un disco o partición, incluyendo sistema operativo, configuraciones y aplicaciones.
Permite **restaurar un equipo completo** rápidamente tras un fallo.

**Ejemplos de programas:** Clonezilla, Acronis True Image, Macrium Reflect.

---

### **Programas de copia de seguridad**

* **Windows:** Propios del sistema: historial de archivos, robocopy. Creados por terceros: Acronis, Cobian Backup. 
* **Linux:** `rsync`, `rsnapshot`, `Timeshift`, `Deja Dup`, `Borg`.
* **Multiplataforma:** Veeam, Duplicati, Restic.

De forma breve comentario sobre ellos:

* Algunos de ellos como rsync o robocopy sólo permiten copiar y sincronizar carpetas, no son sistemas completos de copia de seguridad.
* Rsnapshot sí que consigue deduplicación efectiva pero sólo está disponible en linux y la restauración de archivos resulta poco intuitiva.
* Veeam. Orientado a entornos profesionales; automatización completa, respaldo de VMs, servidores y PCs; sí tiene deduplicación y compresión avanzadas.
* Acronis Cyber Protect / True Image: Backup profesional/doméstico; permite automatización, clonación de discos, protección antiransomware; sí tiene deduplicación (según edición).
* Cobian Backup. Gratis y sencillo; automatiza copias de archivos en Windows; sin deduplicación, sin cifrado moderno, pensado para backups simples.
* Duplicati. Interfaz web, fácil para usuarios domésticos; cifrado + deduplicación; soporta muchos destinos cloud; algo más lento y pesado que Restic/Borg.
* Restic. Multiplataforma, muy fácil de usar; cifrado integrado, deduplicación por chunks (fragmentos), automatizable; ideal para nube (S3, rclone, SSH).
* BorgBackup. Muy eficiente en deduplicación y compresión; requiere más configuración; sólo Linux/Unix; excelente rendimiento en servidores.

*Nosotros vamos a aprender a usar rsync, rsnapshot y restic*

---

### **Recuperación de datos**

Proceso de **restaurar archivos perdidos, dañados o eliminados**.
Puede hacerse desde:

* Copias de seguridad previas.
* Imágenes de disco.
* Software especializado de recuperación (Recuva, TestDisk, PhotoRec).

---

### **Encriptación y ocultación de datos**

**Cifrado:** convierte los datos en un formato ilegible sin la clave.

* **Tipos:**

  * Cifrado completo del disco (BitLocker, LUKS).
  * Cifrado de archivos o carpetas (VeraCrypt, 7-Zip).
* **Ventaja:** protege datos frente a robos o accesos no autorizados.

**Ocultación (Steganografía):** esconde información dentro de otros archivos (por ejemplo, en una imagen o audio).
Se usa para proteger o disimular información sensible.

## Prácticas

Vamos a desarrollar estos contenidos desde un punto de vista práctico. Cada una de las siguientes prácticas deben realizarse en escritorios máquinas virtuales. 

Debes copiar el guión en un documento word u open office y pegar tus capturas de pantalla con dos finalidades:

- Demostrar que has realizado el trabajo
- Poder estudiar y revisar los resultados de tu trabajo

Lista de prácticas:

- [RAID](401). 
- [Copia de seguridad en Windows](402). // No la vamos a hacer este curso
- [Conexión SSH](403).
- [Uso de rsync y rsnaptshot](405).
- [Uso de restic](406).
