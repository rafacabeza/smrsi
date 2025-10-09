# 🧩 Práctica: Funciones Hash y Verificación de Datos en Ubuntu

## Objetivos
- Comprender qué es un **hash** y para qué sirve.  
- Verificar la integridad de ficheros descargados.  
- Comparar ficheros mediante sus hashes.  
- Entender por qué no deben usarse hashes rápidos (SHA) para contraseñas.  
- Aprender a crear y verificar contraseñas seguras con **bcrypt** y **openssl**.

---

## 1️⃣ ¿Qué es un hash?
Un **hash** es el resultado de aplicar una función matemática que convierte datos de cualquier tamaño en una cadena de longitud fija.

Propiedades importantes:
- El mismo texto siempre produce el mismo hash.
- Un pequeño cambio en el texto genera un hash completamente distinto.
- No se puede “deshacer” fácilmente (de hash a texto original).

### Ejemplo simple
```bash
echo -n "hola" | sha256sum
````

Cambia una letra y observa cómo el hash cambia por completo:

```bash
echo -n "Hola" | sha256sum
```

---

## 2️⃣ Verificar una ISO descargada

Cuando descargas una ISO (por ejemplo de Ubuntu), suele venir un fichero `.sha256` con su hash oficial.

### Paso 1. Descargar ambos ficheros

Guarda en la misma carpeta:

* `ubuntu-24.04.iso`
* `ubuntu-24.04.iso.sha256`

### Paso 2. Verificar

```bash
sha256sum -c ubuntu-24.04.iso.sha256
```

**Resultado esperado:**

```
ubuntu-24.04.iso: OK
```

Si sale distinto, la ISO se ha modificado o dañado.

---

## 3️⃣ Comparar ficheros para saber si son idénticos

### Opción 1: Usando `cmp`

```bash
cmp --silent fichero1.txt fichero2.txt && echo "Son idénticos" || echo "Son diferentes"
```

### Opción 2: Usando hashes

```bash
sha256sum fichero1.txt fichero2.txt
```

Si ambos hashes son iguales → los ficheros son idénticos.

---

## 4️⃣ Hash de contraseñas (SHA) y su debilidad

### Crear hash con SHA-1 o SHA-256

```bash
echo -n "micontraseña" | sha1sum
echo -n "micontraseña" | sha256sum
```

Observa el resultado: un texto largo e irreversible.

### ¿Por qué es débil?

Porque SHA es **rápido** y **sin sal (salt)**.
Un atacante puede probar millones de contraseñas por segundo y encontrar coincidencias.

🔍 Busca el hash en una web pública (por ejemplo CrackStation) y verás que contraseñas sencillas se pueden descubrir fácilmente.

> Sitio: [https://crackstation.net](https://crackstation.net)

---

## 5️⃣ Crear contraseñas seguras con bcrypt

### Instalar herramienta

```bash
sudo apt install apache2-utils
```

### Generar hash con bcrypt

```bash
htpasswd -nbB alumno "micontraseña"
```

Ejemplo de salida:

```
alumno:$2y$10$N2QpETNhaX4jQ3O4zBde4OBnKpe0URKMI/bWUk6q99X/dwzqZXeiK
```

### Estructura del hash bcrypt

| Parte                             | Significado                     |
| --------------------------------- | ------------------------------- |
| `$2y$`                            | versión del algoritmo           |
| `10$`                             | número de rondas (coste = 2^10) |
| `N2QpETNhaX4jQ3O4zBde4O`          | sal (salt)                      |
| `BnKpe0URKMI/bWUk6q99X/dwzqZXeiK` | hash resultante                 |

### Verificar contraseña

Crea un fichero:

```bash
echo 'alumno:$2y$10$N2QpETNhaX4jQ3O4zBde4OBnKpe0URKMI/bWUk6q99X/dwzqZXeiK' > /tmp/pwfile
```

Verifica:

```bash
htpasswd -vb /tmp/pwfile alumno "micontraseña"
```

Resultado:

```
Password verification successful
```

---

## 6️⃣ Hashear contraseñas con `openssl passwd`

### Generar hash con SHA-512 crypt

```bash
openssl passwd -6 "micontraseña"
```

Ejemplo:

```
$6$salt1234$9ZfN6bF1cdx3k3GdGzVZP8.4nQ9v7VyiNi...
```

Estructura:

| Parte                 | Significado |
| --------------------- | ----------- |
| `$6$`                 | usa SHA-512 |
| `salt1234`            | sal         |
| `9ZfN6bF1cdx3k3Gd...` | hash final  |

### Verificar manualmente

```bash
openssl passwd -6 -salt salt1234 "micontraseña"
```

Si el resultado coincide, la contraseña es correcta.

---

## 7️⃣ Ejercicios propuestos

1. Calcula el hash SHA256 de tres frases diferentes y compara los resultados.
2. Descarga una ISO de Ubuntu y verifica su integridad.
3. Crea dos ficheros idénticos y comprueba sus hashes. Luego modifica uno y vuelve a comparar.
4. Genera el hash SHA1 de "contraseña" y búscalo en CrackStation.
5. Crea un hash bcrypt de tu contraseña con `htpasswd` y verifica que es correcta.
6. Genera un hash SHA-512 con `openssl passwd` y comprueba que se mantiene al repetir el mismo comando con la misma sal.

---

## 8️⃣ Conclusión

* Los **hashes** garantizan integridad y ayudan a proteger contraseñas.
* **SHA256** se usa para verificar ficheros, **bcrypt** (o Argon2) para contraseñas.
* Nunca guardes contraseñas en texto plano ni con hashes sin sal.
* Los hashes no se desencriptan: se comprueban comparando resultados.

---

📘 **Ampliación**

* [Wikipedia: Función hash](https://es.wikipedia.org/wiki/Funci%C3%B3n_hash)
* [CrackStation – Password Hash Cracker](https://crackstation.net)
* [Ubuntu – Comprobar suma SHA256](https://ubuntu.com/tutorials/how-to-verify-ubuntu)

```

---

¿Quieres que te genere también una **versión PDF lista para entregar a los alumnos** (con el formato ya maquetado y los bloques de comandos destacados)?
```

