# Guion para la sesión: Uso del DNIe en Windows

**Duración estimada total:** 1 hora y 30 minutos – 2 horas  
**Nivel:** Alumnado de IFC201 (algunos menores de edad)  
**Objetivo:** Demostrar y practicar el uso del DNI electrónico (DNIe) para autenticación y firma digital en un entorno seguro.

---

## 1. Introducción (10 min)

**Objetivos:** Contextualizar qué es el DNIe, para qué sirve y qué haremos en la sesión.

**Contenido a explicar:**

- ¿Qué es el DNIe? → Documento de identidad + chip criptográfico.
- ¿Qué permite hacer? → Autenticarse online (ej: identificarse en S.S.), firmar documentos, acceder a servicios electrónicos (ej: descargar vida laboral).
- Diferencia entre “DNI físico”, “certificado digital” y “firma electrónica”.
- Importancia del PIN del DNIe y la seguridad.
- Aclaración: **no haremos trámites reales**, solo ejemplos educativos.

**Apoyo visual:** Diapositiva o pizarra con esquema: *Usuario ↔ DNIe ↔ Certificados ↔ Administración electrónica*.

---

## 2. Preparación técnica (10 min)

**Acciones del profesor:**

- Mostrar el lector de DNIe y cómo se inserta el documento.
- Comprobar que Windows lo reconoce (Administrador de dispositivos).
- Explicar brevemente qué software se necesita:  
  - Middleware/controladores DNIe.
  - AutoFirma.
  - Certificados raíz.

**Transición:** “Vamos a ver cómo se instala y se configura”.

---

## 3. Instalación y configuración (20–25 min)

**Demostración en el ordenador del profesor (proyector):**

1. **Instalar el software DNIe** (middleware).
2. **Instalar AutoFirma**.
3. **Instalar certificados raíz** usando `certmgr.msc`.
4. **Configurar navegador Firefox:**  
   - Opciones → Privacidad & Seguridad → Certificados.
   - Cargar módulo PKCS#11.
5. **Configurar Edge/Chrome:** Comentar que usan el almacén de certificados de Windows.

**Pregunta a la clase:** "¿Hasta aquí alguna duda antes de probarlo en una web real?"

---

## 4. Comprobación en web oficial (10–15 min)

**Acción en directo:**

1. Abrir navegador con DNIe insertado.
2. Ir a la web oficial de prueba (ej: `dnielectronico.es` → Comprobación).
3. Seleccionar certificado, introducir PIN.
4. Mostrar la información del titular (nombre, NIF, caducidad).

**Explicar:** claves pública/privada, autenticación vs firma.

---

## 5. Actividad práctica con AutoFirma (20–25 min)

**Explicación breve:** ¿Qué es firmar un documento? ¿Qué valor tiene?  

**Pasos prácticos que realizará el alumnado:**

1. Abrir AutoFirma.
2. Elegir PDF de práctica (profesor lo proporciona).
3. “Firmar documento” → Seleccionar certificado.
4. Escribir PIN → Guardar PDF firmado.

**Entrega opcional:** Enviar el PDF firmado al profesor (correo/Moodle).

**Demostración adicional (profesor):** Verificar la firma en Adobe Reader / AutoFirma.

---

## 6. Cierre y preguntas (10–15 min)

**Temas para comentar:**

- ¿Dónde se usa el DNIe realmente? (Hacienda, Seguridad Social, Educación...).
- ¿Qué pasa si se pierde el PIN o se bloquea?
- Diferencias con certificado digital de la FNMT.
- Buenas prácticas: no compartir PIN, no dejar DNI insertado.

---

## 7. Material necesario para la sesión

- Ordenador con Windows + proyector.
- Lector DNIe funcional.
- DNIe válido (del profesor o varios).
- Software instalado previamente o descargado:

  - Middleware DNIe.
  - AutoFirma.

- PDF de práctica preparado.
- Manual impreso o digital para los alumnos (opcional).