# 🐧🔐 **503. Elevación de privilegios.

**PARTE 1 Gestión de privilegios y `sudoers` en Linux****

## 📘 **Explicación teórica**

### 🔹 1. El modelo de privilegios en Linux

Linux es un sistema **multiusuario** basado en el principio de **mínimos privilegios**:

* **root**: usuario administrador absoluto (UID 0).
* **Usuarios normales**: sin privilegios administrativos.
* Los usuarios solo pueden modificar:

  * Sus propios archivos
  * Recursos permitidos explícitamente

Esto reduce el impacto de errores y ataques.

---

### 🔹 2. ¿Qué es `sudo`?

`sudo` significa **“superuser do”**.

Permite a un usuario:

* Ejecutar **comandos concretos como root**
* Sin conocer la contraseña de root
* Dejando **registro (logs)** de lo ejecutado

Ejemplo:

```bash
sudo apt update
```

---

### 🔹 3. El archivo `sudoers`

El comportamiento de `sudo` se define en:

```
/etc/sudoers
```

⚠️ **Nunca debe editarse directamente**
✔ Debe usarse siempre:

```bash
sudo visudo
```

`visudo`:

* Evita errores de sintaxis
* Bloquea el archivo durante la edición
* Comprueba la validez antes de guardar

---

### 🔹 4. Grupos administrativos

En Ubuntu:

* El grupo **`sudo`** define quién puede usar `sudo`.
* Durante la instalación, el primer usuario se añade automáticamente.

Ver miembros:

```bash
getent group sudo
```

Añadir usuario:

```bash
sudo usermod -aG sudo usuario
```

---

### 🔹 5. Principio de mínimos privilegios

Buenas prácticas:

* ❌ No usar `root` para tareas diarias
* ✔ Usar `sudo` solo cuando sea necesario
* ✔ Dar permisos **por comando**, no acceso total

Ejemplo seguro:

```bash
usuario ALL=(ALL) /usr/bin/apt
```

---

### 🔹 6. Registros y auditoría

Los comandos ejecutados con `sudo` quedan registrados en:

```bash
/var/log/auth.log
```

Esto permite:

* Auditorías
* Detección de abusos
* Seguimiento de incidentes

---

## 🧪 **FICHA DE PRÁCTICA: Gestión de privilegios y sudoers**

**Duración:** 60 minutos
**Entorno:** Ubuntu Desktop o Server
**Requisitos:** Usuario con permisos `sudo`

---

## 📌 **1. Comprobar usuario y privilegios**

```bash
whoami
groups
```

✔ Verificar si el usuario pertenece al grupo `sudo`.

---

## 📌 **2. Crear un usuario sin privilegios**

```bash
sudo adduser alumno1
```

Cambiar a ese usuario:

```bash
su - alumno1
```

Intentar comando administrativo:

```bash
apt update
```

✔ Debe fallar.

---

## 📌 **3. Añadir el usuario al grupo sudo**

Salir del usuario:

```bash
exit
```

Añadir privilegios:

```bash
sudo usermod -aG sudo alumno1
```

Cerrar sesión y volver a entrar como `alumno1`.

Comprobar:

```bash
sudo apt update
```

✔ Ahora debe funcionar.

---

## 📌 **4. Editar sudoers con visudo**

```bash
sudo visudo
```

Localizar:

```
%sudo   ALL=(ALL:ALL) ALL
```

Explicación:

* `%sudo`: grupo
* `ALL`: desde cualquier host
* `(ALL:ALL)`: como cualquier usuario/grupo
* `ALL`: cualquier comando

---

## 📌 **5. Permisos específicos por comando**

Crear usuario sin sudo:

```bash
sudo adduser alumno2
```

Editar sudoers:

```bash
sudo visudo
```

Añadir al final:

```
alumno2 ALL=(ALL) /usr/bin/apt
```

Probar:

```bash
su - alumno2
sudo apt update   # ✔ permitido
sudo nano /etc/passwd   # ❌ denegado
```

---

## 📌 **6. Evitar contraseña en comandos concretos (NOPASSWD)**

⚠️ Uso controlado

```bash
alumno2 ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart apache2
```

✔ Útil para scripts
❌ Peligroso si se abusa

---

## 📌 **7. Revisar logs de sudo**

```bash
sudo grep sudo /var/log/auth.log
```

Observar:

* Usuario
* Comando ejecutado
* Fecha y hora

---

## 📌 **8. Buenas prácticas finales**

✔ Usar `sudo`, no `root`
✔ Permisos mínimos
✔ Evitar `NOPASSWD`
✔ Auditar regularmente
✔ Documentar cambios en sudoers

---

## 📌 **9. Evidencias para entregar**

1. Salida de `groups` antes y después
2. Fragmento de `sudoers` creado
3. Prueba de comando permitido y denegado
4. Registro en `auth.log`

---

## 📌 **10. Preguntas de reflexión**

1. ¿Por qué no es recomendable trabajar como root?
2. ¿Qué ventaja aporta `sudo` frente a `su`?
3. ¿Qué riesgos tiene `NOPASSWD`?
4. ¿Cómo aplicarías mínimos privilegios en una empresa?



**PARTE 2 Elevación de privilegios en Windows 11**


## Módulo

Seguridad Informática – RA03
Seguridad activa: Sistema operativo y aplicaciones

## Duración

60–90 minutos

## Entorno

* Máquina virtual **Windows 11**
* Una cuenta **Administrador**
* Una cuenta **Usuario estándar**

---

## 🎯 Objetivos de aprendizaje

El alumnado será capaz de:

* Comprender el modelo de privilegios de Windows
* Diferenciar usuario estándar y administrador
* Usar correctamente **UAC**
* Ejecutar aplicaciones con privilegios elevados
* Entender los riesgos de una mala gestión de privilegios

---

## 📘 Conceptos previos (breve)

* **Usuario estándar**: permisos limitados
* **Administrador**: puede modificar el sistema
* **UAC (User Account Control)**: mecanismo que solicita confirmación para elevar privilegios
* **Elevación** ≠ iniciar sesión como administrador permanentemente

---

## 🧪 GUION DE PRÁCTICA

---

## 📌 1. Identificar el tipo de usuario

1️⃣ Iniciar sesión con un usuario estándar
2️⃣ Abrir **Configuración → Cuentas → Tu información**

Comprobar:

* Tipo de cuenta: **Usuario estándar**

Abrir **Símbolo del sistema**:

```cmd
whoami
```

---

## 📌 2. Intentar una acción administrativa (sin elevación)

Como usuario estándar:

1️⃣ Intentar instalar un programa
2️⃣ O abrir:

```
C:\Windows\System32
```

3️⃣ Intentar crear un archivo

Resultado esperado:

* ❌ Acceso denegado
* ❌ Solicitud de credenciales de administrador

---

## 📌 3. Introducción al UAC

### ¿Qué es UAC?

* Un sistema de **control de elevación**
* Reduce el riesgo de malware
* Obliga a confirmar acciones críticas

📌 Ventana típica:

* Fondo oscurecido
* Mensaje: *¿Desea permitir que esta aplicación realice cambios?*

---

## 📌 4. Ejecutar una aplicación como administrador

1️⃣ Buscar **Bloc de notas**
2️⃣ Clic derecho → **Ejecutar como administrador**
3️⃣ Confirmar UAC (usuario admin o credenciales)

4️⃣ Desde el Bloc de notas:

* Abrir archivo:

  ```
  C:\Windows\System32\drivers\etc\hosts
  ```

✔ Ahora sí permite guardar cambios

---

## 📌 5. Comparar ejecución normal vs elevada

Abrir dos **Símbolos del sistema**:

* Uno normal
* Otro con **Ejecutar como administrador**

En ambos:

```cmd
net session
```

Resultados:

* Normal → ❌ Acceso denegado
* Elevado → ✔ Información mostrada

---

## 📌 6. Comprobar pertenencia a grupos

En consola elevada:

```cmd
whoami /groups
```

Observar:

* `BUILTIN\Administrators`
* `Mandatory Label\High Mandatory Level`

Comparar con consola no elevada:

* `Medium Mandatory Level`

---

## 📌 7. Crear usuario estándar y administrador

Desde cuenta admin:

1️⃣ **Configuración → Cuentas → Otros usuarios**
2️⃣ Crear:

* Usuario estándar: `alumno_std`
* Usuario administrador: `alumno_admin`

3️⃣ Cerrar sesión y probar:

* Qué puede y no puede hacer cada uno

---

## 📌 8. Desactivar y activar UAC (solo demostración)

⚠️ **Solo con fines educativos**

1️⃣ Panel de control
2️⃣ Cuentas de usuario
3️⃣ Cambiar configuración de Control de cuentas de usuario

Mover el control a:

* Nivel más bajo (menos seguro)
* Volver a nivel recomendado

Reflexión:

* ¿Qué riesgos aparecen al desactivar UAC?

---

## 📌 9. Buenas prácticas de elevación de privilegios

✔ Usar usuario estándar para tareas diarias
✔ Elevar privilegios solo cuando sea necesario
✔ No desactivar UAC
✔ Verificar el origen del software
✔ Cerrar aplicaciones elevadas tras su uso

---

## 📌 10. Evidencias a entregar

📄 Capturas o respuestas:

1. Diferencia entre consola normal y elevada
2. Captura del aviso de UAC
3. Resultado de `whoami /groups`
4. Acceso denegado vs permitido
5. Reflexión sobre UAC

---

## ❓ Preguntas de reflexión

1. ¿Por qué Windows no ejecuta todo como administrador?
2. ¿Qué ventaja aporta UAC frente a iniciar sesión como admin?
3. ¿Qué pasaría si el malware se ejecuta con privilegios elevados?
4. ¿Qué similitudes hay con `sudo` en Linux?

---

## 🔄 Comparativa rápida Linux vs Windows

| Linux                 | Windows                  |
| --------------------- | ------------------------ |
| sudo                  | UAC                      |
| root                  | Administrador            |
| Elevación por comando | Elevación por aplicación |
| Logs en auth.log      | Eventos de seguridad     |

