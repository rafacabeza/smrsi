# Seguridad y privacidad de la información en redes

Apuntes para el módulo **IFC201**

---

## 1. Introducción

En una red informática, la información viaja entre dispositivos a través de distintos medios (cable, WiFi, Internet). Si no se toman medidas de seguridad adecuadas, esa información puede ser **interceptada, modificada o robada**.

En esta unidad veremos **vulnerabilidades habituales**, **herramientas de análisis** y **mecanismos de protección** para asegurar la **confidencialidad, integridad y privacidad** de los datos transmitidos.

---

## 2. Escucha de red (Sniffing)

### 2.1 ¿Qué es el sniffing? (husmear)

El **sniffing** o escucha de red consiste en **capturar y analizar paquetes de datos** que circulan por una red.

Puede utilizarse para:

* Diagnóstico y administración de redes (uso legítimo).
* Ataques para obtener información sensible (uso malicioso).

Ejemplos de información que puede capturarse si no está cifrada:

* Usuarios y contraseñas
* Correos electrónicos
* Páginas web visitadas
* Contenido de formularios

---

### 2.2 Wireshark

**Wireshark** es una de las herramientas más populares para el análisis de tráfico de red.

#### Características principales:

* Captura paquetes en tiempo real.
* Permite filtrar tráfico por protocolo, IP, puerto, etc.
* Muestra el contenido de los paquetes (si no está cifrado).

#### Protocolos que se pueden analizar fácilmente:

* HTTP
* FTP
* DNS
* SMTP
* TCP / UDP

#### Ejemplo práctico:

* Capturar tráfico HTTP y observar que el contenido se ve en claro.
* Compararlo con tráfico HTTPS, donde el contenido está cifrado.

> ⚠️ Importante: solo debe usarse en redes propias o con autorización.

---

## 3. Protocolos seguros

### 3.1 ¿Por qué son necesarios?

Los **protocolos inseguros** transmiten la información **en texto plano**, lo que permite que sea interceptada mediante sniffing.

Los **protocolos seguros** incorporan **cifrado y autenticación**, evitando que terceros entiendan la información capturada.

---

### 3.2 Ejemplos de protocolos inseguros y seguros

| Protocolo inseguro | Protocolo seguro |
| ------------------ | ---------------- |
| HTTP               | HTTPS            |
| FTP                | SFTP / FTPS      |
| Telnet             | SSH              |
| SMTP               | SMTPS            |
| POP3               | POP3S            |

---

### 3.3 HTTPS y TLS

* **HTTPS** utiliza **TLS (Transport Layer Security)**.
* Proporciona:

  * Cifrado de los datos.
  * Autenticación del servidor mediante certificados.
  * Integridad de la información.

Al usar HTTPS:

* El contenido no es visible en Wireshark.
* Se protege frente a ataques de tipo *man-in-the-middle*.

---

## 4. Cifrados digitales (repaso)

> Este apartado ya ha sido explicado con profundidad previamente.

Recordatorio de conceptos clave:

* **Cifrado simétrico**: misma clave para cifrar y descifrar.

  * Ejemplo: AES

* **Cifrado asimétrico**: par de claves pública y privada.

  * Ejemplo: RSA

* **Uso combinado**:

  * TLS combina cifrado asimétrico (intercambio de claves) y simétrico (transmisión de datos).

Objetivo principal:

* Garantizar **confidencialidad**, **integridad** y **autenticación**.

---

## 5. Uso de Nmap

### 5.1 ¿Qué es Nmap?

**Nmap (Network Mapper)** es una herramienta de **escaneo de redes** utilizada para:

* Detectar dispositivos conectados.
* Identificar puertos abiertos.
* Reconocer servicios y versiones.

Se utiliza tanto en **auditorías de seguridad** como por atacantes.

---

### 5.2 Funcionalidades principales

* Descubrimiento de hosts activos.
* Escaneo de puertos TCP y UDP.
* Detección del sistema operativo.
* Identificación de servicios vulnerables.

---

### 5.3 Ejemplos básicos de uso

* Escanear un equipo:

  ```bash
  nmap 192.168.1.10
  ```

* Escanear una red completa:

  ```bash
  nmap 192.168.1.0/24
  ```

* Escanear puertos concretos:

  ```bash
  nmap -p 22,80,443 192.168.1.10
  ```

---

### 5.4 Relación con la seguridad

* Permite descubrir servicios expuestos innecesariamente.
* Ayuda a detectar configuraciones inseguras.
* Es una herramienta clave en **pentesting básico**.

> ⚠️ Solo debe usarse en sistemas propios o con autorización.

---

## 6. VPN (Virtual Private Network)

### 6.1 ¿Qué es una VPN?

Una **VPN** crea un **túnel cifrado** entre dos puntos de una red a través de Internet.

Permite:

* Proteger la información transmitida.
* Acceder de forma segura a redes privadas.
* Evitar escuchas en redes públicas (WiFi abierto).

---

### 6.2 Funcionamiento básico

1. El cliente se conecta al servidor VPN.
2. Se establece un túnel cifrado.
3. Todo el tráfico viaja protegido dentro del túnel.

Aunque alguien capture los paquetes, **no podrá leer su contenido**.

---

### 6.3 Tipos de VPN

* **VPN de acceso remoto**: usuarios se conectan a una red corporativa.
* **VPN sitio a sitio**: conecta redes completas entre sí.

Protocolos habituales:

* IPsec (1995). Surge como parte de IPv6 pero se adoptó también para IPv4. Sobre todo se usa para la conexión de dos redes entre sí como si fueran una única red.
* OpenVPN. Creada en 2001. Es de código a bierto y muy utilizada. Solución más flexible que la anterior y multiplataforma. Suele usarse para conectar un equipo a una red remota.
* WireGuard. Creada en 2015. Solución mínima, más rápida y moderna. Menos configurable pero de más alto rendimiento. Suele usarse para conectar un equipo a una red remota.

---

### 6.4 Ventajas y limitaciones

**Ventajas:**

* Protección de la privacidad.
* Seguridad en redes públicas.
* Acceso remoto seguro.

**Limitaciones:**

* Puede reducir la velocidad.
* No protege frente a malware en el equipo.

---

## 7. Conclusión

Para asegurar la privacidad de la información en redes es fundamental:

* Evitar protocolos inseguros.
* Usar cifrado y protocolos seguros.
* Analizar la red con herramientas como Wireshark y Nmap.
* Implementar VPN cuando se accede a redes a través de Internet.

La seguridad en redes no depende de una sola medida, sino de la **combinación de varias capas de protección**.

<!-- ---

## 8. Actividades propuestas

1. Capturar tráfico HTTP y HTTPS con Wireshark y comparar resultados.
2. Realizar un escaneo básico con Nmap en una red local.
3. Investigar diferencias entre OpenVPN y WireGuard.
4. Identificar protocolos seguros e inseguros en distintos servicios.
 -->
