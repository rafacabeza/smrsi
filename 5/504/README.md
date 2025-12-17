# 💾🧪 PRÁCTICA: Cuotas de disco en Ubuntu y Windows 11

## Módulo

Seguridad Informática – RA03
Seguridad activa: Sistema operativo y aplicaciones

## Duración

90 minutos (45’ Linux + 45’ Windows)

## Objetivo general

Configurar **cuotas de disco** para el usuario `alumno1`:

* **Espacio máximo:** 20 GB
* **Límite blando:** 18 GB
* **Número máximo de ficheros:** 10.000 (solo donde sea posible)

---

# 🐧 PARTE A — CUOTAS EN UBUNTU (ext4)

📌 **Nota didáctica clave**
En Linux **sí es posible** limitar:

* Espacio en disco
* Número de ficheros (inodos)

---

## 🔹 1. Escenario de partida

* Ubuntu con **un solo disco**
* `/home` está dentro del mismo sistema de archivos (`/`)
* Sistema de archivos: **ext4**
* Usuario existente: `alumno1`

---

## 🔹 2. Comprobar sistema de archivos

```bash
df -Th /
```

Debe aparecer algo como:

```
Filesystem Type  Size Used Avail Use% Mounted on
/dev/sda1  ext4   ...
```

✔ Confirmamos que es **ext4**.

---

## 🔹 3. Instalar herramientas de cuotas

```bash
sudo apt update
sudo apt install quota quotatool
```

---

## 🔹 4. Activar cuotas en el sistema de archivos

Editar `/etc/fstab`:

```bash
sudo nano /etc/fstab
```

Localizar la línea del sistema raíz (`/`) y añadir:

```text
defaults,usrquota,grpquota
```

Ejemplo:

```text
UUID=xxxx  /  ext4  defaults,usrquota,grpquota  0  1
```

---

## 🔹 5. Remontar el sistema de archivos

```bash
sudo mount -o remount /
```

Comprobar:

```bash
mount | grep quota
```

---

## 🔹 6. Crear ficheros de cuotas y escanear uso

```bash
sudo quotacheck -cum /
sudo quotaon /
```

---

## 🔹 7. Configurar cuota para alumno1

```bash
sudo edquota -u alumno1
```

Editor típico:

```
Filesystem  blocks   soft   hard   inodes   soft   hard
/dev/sda1     0     18000000 20000000   0     10000 10000
```

### Explicación:

* **blocks** → espacio (en KB)
* 18.000.000 KB ≈ **18 GB (soft)**
* 20.000.000 KB ≈ **20 GB (hard)**
* **inodes** → número de ficheros
* Máximo: **10.000**

Guardar y salir.

---

## 🔹 8. Comprobar cuota aplicada

```bash
quota -u alumno1
```

---

## 🔹 9. Prueba práctica como alumno1

```bash
su - alumno1
```

Crear archivos:

```bash
fallocate -l 19G archivo_grande
```

Resultado esperado:

* ⚠️ Aviso al superar límite blando
* ❌ Error al superar límite duro

Crear muchos ficheros:

```bash
for i in {1..10001}; do touch f$i; done
```

❌ Al llegar a 10.000 → error

---

## 🔹 10. Reflexión (Linux)

✔ Control fino
✔ Prevención de DoS local
✔ Ideal para sistemas multiusuario

---

# 🪟 PARTE B — CUOTAS EN WINDOWS 11 (NTFS)

📌 **Nota didáctica clave**
En Windows:

* ✔ Se puede limitar **espacio por usuario**
* ❌ **NO se puede limitar número de ficheros** de forma nativa

👉 Esto es muy importante que el alumnado lo entienda.

---

## 🔹 1. Escenario de partida

* Windows 11
* Sistema de archivos: **NTFS**
* Disco: **C:**
* Usuario local: `alumno1`

---

## 🔹 2. Acceder a cuotas NTFS

1️⃣ Explorador de archivos
2️⃣ Clic derecho sobre **Disco local (C:)**
3️⃣ Propiedades → **Cuota**
4️⃣ Mostrar configuración de cuota

---

## 🔹 3. Activar cuotas

Marcar:
✔ Habilitar administración de cuotas
✔ Denegar espacio en disco a los usuarios que superen el límite

---

## 🔹 4. Configurar cuota por defecto

* **Límite:** 20 GB
* **Nivel de advertencia:** 18 GB

Aplicar cambios.

---

## 🔹 5. Configurar cuota específica para alumno1

1️⃣ En la pestaña **Cuota**
2️⃣ **Entradas de cuota**
3️⃣ **Nueva entrada de cuota**
4️⃣ Seleccionar usuario `alumno1`

Asignar:

* Límite: **20 GB**
* Advertencia: **18 GB**

---

## 🔹 6. Comprobación práctica

Iniciar sesión como `alumno1`.

Copiar archivos grandes hasta:

* ⚠️ Aviso al llegar a 18 GB
* ❌ Error al superar 20 GB

Mensaje típico:

> No hay suficiente espacio en disco

---

## 🔹 7. Intento de límite de ficheros (discusión)

Pregunta al alumnado:

> ¿Podemos limitar a 10.000 archivos en Windows?

Respuesta:
❌ **No de forma nativa con NTFS quotas**

Alternativas (solo teóricas):

* FSRM (Windows Server)
* Scripts PowerShell (no fiable)
* Software de terceros

---

## 🔹 8. Comparativa final

| Característica | Ubuntu | Windows 11 |
| -------------- | ------ | ---------- |
| Límite espacio | ✔      | ✔          |
| Límite blando  | ✔      | ✔ (aviso)  |
| Límite duro    | ✔      | ✔          |
| Nº de ficheros | ✔      | ❌          |
| Por usuario    | ✔      | ✔          |
| Por grupo      | ✔      | ❌          |

---

## 📌 Evidencias a entregar

1️⃣ Captura de `quota -u alumno1` (Ubuntu)
2️⃣ Error por superar límite duro (Ubuntu)
3️⃣ Captura de configuración de cuota en C: (Windows)
4️⃣ Reflexión comparativa Linux vs Windows
