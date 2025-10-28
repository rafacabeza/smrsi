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

* **Completa:** copia todos los datos.
* **Incremental:** copia solo los datos modificados desde la última copia.
* **Diferencial:** copia los datos modificados desde la última copia completa.
* **Espejo (mirror):** mantiene una copia exacta en tiempo real.

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

Algunos programas comunes:

* **Windows:** Historial de archivos, Copias de seguridad del sistema.
* **Linux:** `rsync`, `rsnapshot`, `Timeshift`, `Deja Dup`.
* **Multiplataforma:** Veeam, Duplicati, Acronis, Cobian Backup.

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
