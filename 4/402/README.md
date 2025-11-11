# Copia de seguridad en MS Windows

Vamos a hacer un repaso completo de las **opciones de copia de seguridad que Windows 11 ofrece “out of the box”**, sin instalar software adicional. Windows 11 tiene varias herramientas integradas para proteger tus datos: **Historial de archivos, Copia de seguridad de Windows (también llamada Copia de seguridad y restauración – Windows 7), y Restaurar sistema / puntos de restauración**. Vamos paso a paso:

---

## 1 **Historial de archivos**

### Qué es:

* Herramienta diseñada para hacer copias automáticas de **archivos personales** (Documentos, Imágenes, Vídeos, Escritorio, Favoritos de Edge/IE).
* Permite restaurar versiones anteriores de archivos en caso de borrado o modificación accidental.

### Cómo usarlo:

1. Conecta un **disco externo** o un **recurso de red** donde guardar las copias.
2. Ve a **Configuración → Cuentas → Copia de seguridad** o directamente busca **Historial de archivos** en el menú de inicio.
3. Activa **Hacer copia de seguridad automáticamente de mis archivos**.
4. Selecciona **unidad** donde se guardarán las copias.
5. Configura:

   * **Frecuencia de copia**: cada 10 min, 15 min, 1 h, etc.
   * **Tiempo de conservación**: hasta que el espacio se agote, 1 mes, 1 año, etc.
6. Los archivos se guardan automáticamente y se pueden restaurar desde **Configuración → Copia de seguridad → Restaurar archivos desde un historial de archivos**.

**Pros:**

* Automatizado y fácil de configurar.
* Mantiene varias versiones de los archivos.

**Limitaciones:**

* Solo copia archivos personales (no aplicaciones ni configuración del sistema).

---

## 2 **Copia de seguridad de Windows / Copia de seguridad y restauración (Windows 7)**

### Qué es:

* Heredada de Windows 7.
* Permite hacer **imágenes del sistema completo**, además de copia de carpetas específicas.
* Puede restaurar el sistema completo en caso de fallo grave.

### Cómo usarlo:

1. Ve a **Configuración → Actualización y seguridad → Copia de seguridad → Más opciones → Copia de seguridad con Historial de archivos → Ir a Copia de seguridad y restauración (Windows 7)**.
2. Selecciona **Configurar copia de seguridad**.
3. Escoge un disco externo o una ubicación de red.
4. Decide entre:

   * **Dejar que Windows elija** (Documentos, Imágenes, Configuración del sistema).
   * **Elegir yo mismo** las carpetas y unidades.
5. Configura la frecuencia (diaria, semanal) y programa la copia.
6. Permite crear un **disco de reparación del sistema** para restaurar Windows si no arranca.

**Pros:**

* Permite restaurar **todo el sistema**, no solo archivos.
* Compatible con versiones antiguas de Windows.
* Copia tanto archivos personales como configuraciones y programas (en la imagen del sistema).

**Limitaciones:**

* Menos moderno que Historial de archivos.
* Ocupa más espacio (sobre todo con imágenes del sistema).

---

## 3 **Restaurar sistema / Puntos de restauración**

### Qué es:

* No es una copia de archivos personales.
* Permite **volver a un estado anterior de Windows** (sistema, drivers, configuración).
* Muy útil si un programa o driver da problemas.

### Cómo usarlo:

1. Busca **Crear un punto de restauración** en el menú de inicio.
2. Selecciona **Configurar → Activar protección del sistema**.
3. Puedes crear un punto manualmente o Windows lo hará automáticamente antes de actualizaciones importantes o instalación de programas.
4. Para restaurar:

   * Ve a **Restaurar sistema → Elegir punto de restauración → Confirmar**.

**Pros:**

* Restaura sistema y configuración sin afectar archivos personales.
* Útil ante actualizaciones problemáticas o errores de drivers.

**Limitaciones:**

* No protege archivos personales.
* Puntos de restauración ocupan espacio limitado, se borran automáticamente con el tiempo.

---

## 4 **Copia de seguridad en OneDrive**

Aunque no es exactamente “local”, Windows 11 integra **OneDrive** para guardar tus archivos en la nube:

* Sincroniza automáticamente **Escritorio, Documentos e Imágenes**.
* Permite acceder desde otros dispositivos.
* Restauración desde la nube en caso de fallo del disco.

---

## 5 **Resumen de posibilidades**

| Herramienta                       | Qué copia                     | Frecuencia     | Ubicación           | Restauración                         |
| --------------------------------- | ----------------------------- | -------------- | ------------------- | ------------------------------------ |
| Historial de archivos             | Archivos personales           | Cada X minutos | Disco externo / red | Versiones anteriores                 |
| Copia de seguridad de Windows (7) | Archivos + imagen del sistema | Diario/Semanal | Disco externo / red | Archivos + sistema completo          |
| Restaurar sistema                 | Sistema y configuración       | Automática     | Disco local         | Estado del sistema                   |
| OneDrive                          | Archivos personales           | Automática     | Nube                | Archivos desde cualquier dispositivo |

---

 **Recomendación práctica para un usuario doméstico**:

* **Archivos críticos → OneDrive o Historial de archivos**.
* **Sistema completo → Imagen del sistema de Windows 7** cada mes.
* **Cambios importantes → Crear punto de restauración** antes de instalar programas o drivers.

