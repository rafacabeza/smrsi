# 📝 **Práctica: Configuración de la política de contraseñas en Windows 11**

**Módulo:** Seguridad Informática (RA3 – Seguridad Activa)
**Duración estimada:** 45–60 minutos
**Requisitos:**

* Máquina virtual con Windows 11 Pro o Education
* Usuario con privilegios de Administrador

---

# 🎯 **Objetivo de la práctica**

Configurar en Windows 11 una **política de contraseñas segura**, aplicando las recomendaciones actuales de Microsoft:

* Longitud mínima 12 caracteres
* Complejidad activada
* No caducidad obligatoria
* Historial de contraseñas
* Política de bloqueo por intentos fallidos

Al finalizar, el estudiante deberá ser capaz de aplicar una política de contraseñas mediante **Política de Seguridad Local**.

---

# 📌 **1. Verificar el tipo de edición y acceso a Políticas Locales**

1. Abrir **Inicio** → escribir *winver*.
   Verifica que la edición es **Pro o Education**.

2. Abrir:

   ```
   Inicio → Escribir: secpol.msc → Enter
   ```

   Esto abre **Política de seguridad local**.

📌 Si no se abre, usar *gpedit.msc* o confirmar que la edición de Windows soporta políticas.

---

# 📌 **2. Configurar la política de contraseñas**

Ir a:

**Política de seguridad local** →
**Configuración de seguridad** →
**Directivas de cuenta** →
**Directiva de contraseñas**

Configura los siguientes parámetros:

---

### 🔧 **2.1. Longitud mínima de contraseña**

* Abrir **Longitud mínima de la contraseña**
* Establecer: **12 caracteres**
* Aplicar

---

### 🔧 **2.2. La contraseña debe cumplir requisitos de complejidad**

* Abrir **La contraseña debe cumplir los requisitos de complejidad**
* Establecer: **Habilitada**

---

### 🔧 **2.3. Vigencia de la contraseña**

* **Duración máxima de la contraseña:** poner **0** (significa *nunca caduca*)
* **Duración mínima de la contraseña:** **1 día**

No se recomienda forzar caducidad periódica. Algo que durante años ha sido costumbre habitual.

---

### 🔧 **2.4. Historial de contraseñas**

* Abrir **Hacer cumplir el historial de contraseñas**
* Valor: **10 contraseñas recordadas**

---

# 📌 **3. Configurar política de bloqueo de cuenta**

Ir a:

**Política de seguridad local** →
**Configuración de seguridad** →
**Directivas de cuenta** →
**Directiva de bloqueo de cuenta**

Configura:

---

### 🔧 **3.1. Umbral de bloqueo de cuenta**

* Abrir **Umbral de bloqueo de cuenta**
* Valor: **5 intentos fallidos**

Al aplicar, Windows sugerirá valores automáticos para:

* **Duración del bloqueo:** 10 minutos
* **Restablecer contador de bloqueo:** 10 minutos

Aceptar.

---

# 📌 **4. Probar que la política funciona**

### ✔ 4.1. Crear un usuario de pruebas

1. **Inicio → Configuración → Cuentas → Familia y otros usuarios**
2. **Agregar cuenta → No tengo los datos de inicio → Agregar sin cuenta Microsoft**
3. Crear un usuario local.

### ✔ 4.2. Intentar configurar una contraseña débil

Prueba con:

```
1234
password
hola
```

Debe aparecer un aviso indicando que **no cumple los requisitos**.

### ✔ 4.3. Probar bloqueo de cuenta

1. Introducir la contraseña mal **5 veces**.
2. Confirmar que el usuario queda **bloqueado 10 minutos**.

---

# 📌 **5. Capturas obligatorias para entregar**

El alumno debe aportar las siguientes capturas:

1. Pantalla de *Directiva de contraseñas*:

   * Longitud mínima
   * Complejidad
   * Historial
2. Pantalla de *Directiva de bloqueo de cuenta*:

   * Intentos máximos
   * Duración del bloqueo
3. Error al intentar asignar una contraseña débil
4. Mensaje de cuenta bloqueada (opcional)

---

# 📌 **6. Preguntas de evaluación (opcionales)**

1. ¿Por qué ya no se recomienda caducar las contraseñas cada 30 días?
2. ¿Qué aporta más seguridad: complejidad o longitud? ¿Por qué?
3. ¿Qué impacto tiene un bloqueo de cuenta demasiado sensible?
4. ¿Cuál sería una política adecuada en un entorno escolar? ¿Y en una empresa?

