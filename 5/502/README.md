# 🎓 502. Uso básico de Bitwarden

*(Compatible con Windows 11 y Ubuntu Desktop)*

## 🎯 Objetivos de la práctica

* Entender qué es Bitwarden y por qué usarlo.
* Instalar Bitwarden en Windows 11 y Ubuntu.
* Crear una bóveda segura.
* Añadir contraseñas, organizarlas y gestionarlas.
* Usar el generador de contraseñas.
* Activar 2FA básica.
* Probar el autocompletado en el navegador.

---

# 🧩 Parte 1 – Preparación del entorno

## ✔️ 1. Crear cuentas Bitwarden

1. En cualquier VM, abre el navegador.
2. Visita: **bitwarden.com → Create Account**
3. Introduce:

   * Email (puede ser uno de pruebas)
   * Contraseña maestra **fuerte**
4. **Importante**: Apuntar la contraseña maestra en una hoja de práctica o usar una frase (passphrase).

---

# 🪟 Parte 2 – Instalación en Windows 11

## ✔️ 2. Instalar la aplicación de escritorio (opcional pero recomendable)

1. Abrir **Microsoft Store**.
2. Buscar **Bitwarden**.
3. Instalar y abrir.
4. Iniciar sesión en tu cuenta.

## ✔️ 3. Instalar la extensión en el navegador (obligatorio para la práctica)

1. Abrir Edge o Chrome.
2. Ir a Web Store / Add-ons.
3. Buscar **Bitwarden** → Instalar.
4. Iniciar sesión en la extensión.

---

# 🐧 Parte 3 – Instalación en Ubuntu Desktop

## ✔️ 4. Instalar la aplicación de escritorio

1. Abrir **Ubuntu Software**.
2. Buscar **Bitwarden**.
3. Instalar y abrir.
4. Iniciar sesión.

## ✔️ 5. Instalar la extensión del navegador

1. Abrir Firefox/Chrome.
2. Instalar la extensión Bitwarden igual que en Windows.

---

# 🔐 Parte 4 – Primeros pasos dentro de Bitwarden

## ✔️ 6. Añadir tu primera contraseña

1. Abrir Bitwarden (app o extensión).
2. Crear un ítem nuevo:

   * Tipo: **Login**
   * Nombre: *Google prueba*
   * Usuario: *[usuario_test@gmail.com](mailto:usuario_test@gmail.com)*
   * Contraseña: poner algo temporal
3. Guardar.

## ✔️ 7. Probar el autocompletado

1. Abrir **accounts.google.com**
2. En el campo de correo → aparece el icono de Bitwarden.
3. Autocompletar para verificar que funciona.

---

# 🔑 Parte 5 – Generador de contraseñas

## ✔️ 8. Crear una contraseña segura desde Bitwarden

1. Dentro del ítem → clic en **Generar contraseña**
2. Seleccionar:

   * 16–20 caracteres
   * Letras + números + símbolos
3. Guardar la nueva contraseña.

Explica a los alumnos:

* Por qué generar contraseñas únicas para cada web.
* Por qué no deben recordar todas, solo la **contraseña maestra**.

---

# 🗂️ Parte 6 – Organización de la bóveda

## ✔️ 9. Crear carpetas

1. En la app → **Carpetas** → Crear carpeta “Personal” o “Trabajo”.
2. Mover ítems a carpetas.

## ✔️ 10. Crear notas seguras

Útil para guardar:

* claves del WiFi
* licencias de software
* información de SSH
  *(sin abusar, siempre cifrado y privado)*

---

# 🛡️ Parte 7 – Seguridad básica

## ✔️ 11. Activar 2FA gratuita para la cuenta

1. En el **Web Vault** → Configuración.
2. Apartado **Two-step Login**.
3. Activar **Email** como segundo factor (gratuito).
4. Demostrar cómo funciona el inicio de sesión con un código.

> En la versión gratuita **NO** se puede usar YubiKey.

---

# 🌐 Parte 8 – Sincronización entre dispositivos

## ✔️ 12. Mostrar sincronización entre Windows y Ubuntu

1. Crear un ítem en Windows.
2. En Ubuntu → Bitwarden → Sincronizar → comprobar que aparece.
3. Repetir al revés.

Esto demuestra a los alumnos:

* Qué es la sincronización segura.
* Cómo funciona el cifrado extremo a extremo.

---

# 🎉 Parte 9 – Ejercicio final para los alumnos

### ✔️ Cada alumno debe:

1. Crear 3 logins reales o ficticios:

   * Gmail
   * GitHub
   * Algún servicio de práctica (p. ej. Moodle)
2. Guardarlos en carpetas.
3. Regenerar contraseñas fuertes.
4. Comprobar autocompletado.
5. Crear una nota segura.
6. Activar 2FA por email.
7. Sincronizar en otra VM (Windows ↔ Ubuntu).