# 🧪 Práctica: Descubrimiento de equipos y servicios con Nmap

## 🎯 Objetivos de la práctica

Al finalizar la práctica, el alumno será capaz de:

* Usar **nmap** para descubrir equipos activos en una red local
* Identificar **servicios abiertos** (HTTP, SSH, etc.)
* Interpretar los resultados básicos de un escaneo
* Comprender por qué esta información es sensible desde el punto de vista de la seguridad

---

## 🔧 Requisitos

* Máquina **Ubuntu** por alumno
* Todos conectados a la **misma red local**
* Permisos de usuario normal (usar `sudo` solo cuando se indique)
* Nmap instalado

Instalación:

```bash
sudo apt update
sudo apt install nmap -y
```

---

## 📌 Comandos básicos de Nmap (No lo hagas, es una chuleta de comandos)

### 1️⃣ Escaneo tipo *ping* (descubrir equipos activos)

```bash
nmap -sn 192.168.1.0/24
```

📌 Muestra qué equipos **están encendidos** en la red, sin escanear puertos.

---

### 2️⃣ Escaneo de puertos de un equipo concreto

```bash
nmap 192.168.1.50
```

📌 Muestra los **puertos abiertos más comunes**.

---

### 3️⃣ Escaneo de puertos + detección de servicio

```bash
nmap -sV 192.168.1.50
```

📌 Indica **qué servicio** hay detrás de cada puerto (Apache, SSH, etc.).

---

### 4️⃣ Escaneo rápido de una red completa

```bash
nmap 192.168.1.0/24
```

📌 Escanea todos los equipos y sus puertos básicos.

---

### 5️⃣ Escaneo de un puerto concreto

```bash
nmap -p 80 192.168.1.50
```

📌 Comprueba si un servicio específico está activo.

---

## 🧪 Desarrollo de la práctica

### 🔹 Parte 1: Preparar un servidor visible en la red

1. Cada alumno **instala Apache**:

```bash
sudo apt install apache2
sudo apt install openssh-server
```

2. Comprueba que funciona:

```bash
systemctl status apache2
```

O tmabién:

```bash
ss -ltn
```

3. Averigua tu IP:

```bash
ip a
```

4. Desde el navegador:

```
http://TU_IP
```

Debería aparecer la página por defecto de Apache.

---

### 🔹 Parte 2: Descubrir equipos activos en la red

1. Ejecuta:

```bash
nmap -sn 192.168.1.0/24
```

2. Anota:

* Cuántos equipos aparecen
* Qué IP podría corresponder a compañeros

💡 *Aquí ya se introduce la idea de que “ver equipos” no requiere autenticación.*

---

### 🔹 Parte 3: Descubrir servidores web en la red

1. Elige una IP de la lista:

```bash
nmap -p 80 192.168.1.23
```

2. Si el puerto está abierto:

```bash
nmap -sV 192.168.1.23
```

Ejemplo de resultado:

```
80/tcp open  http  Apache httpd 2.4.52
```

📌 **Conclusión clave**:

> Sin entrar al equipo, ya sabemos qué servidor web usa.

---

### 🔹 Parte 4: Escaneo completo de un compañero (controlado)

```bash
nmap 192.168.1.23
```

Servicios típicos que pueden aparecer:

* `22` → SSH
* `80` → HTTP
* `631` → CUPS (impresión)
* `3306` → MySQL (si alguien lo tiene)

---

## 🧠 Preguntas para el alumno (entregables)

1. ¿Cuántos equipos activos había en la red?
2. ¿Qué servicios has detectado en otros equipos?
3. ¿Qué información puede obtener un atacante solo con Nmap?
4. ¿Por qué es importante **cerrar servicios innecesarios**?
5. ¿Qué diferencia hay entre `-sn` y un escaneo completo?

---

## ⚠️ Enfoque de seguridad (muy importante)

Remarca en clase:

> Nmap **no ataca**, solo observa.
> Pero observar bien es el primer paso de cualquier ataque.

Conecta esta práctica con:

* Firewalls
* Servicios expuestos
* Escaneo previo a ataques
* Importancia de protocolos seguros (HTTPS, SSH)

---

## 💡 Ampliación si te da tiempo

* Parar Apache y volver a escanear
* Cambiar el puerto de Apache
* Añadir ssh server y volver a escanear

```bash
sudo apt install openssh-server
```

* Comparar escaneo con y sin `sudo`

