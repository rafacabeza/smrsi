# 🐧🔐 **503. Gestión de privilegios y `sudoers` en Linux**


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