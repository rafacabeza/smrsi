# Ejemplos de uso de wireshark

## 🧪 Ejemplo 1: Ver tráfico HTTP en claro (sniffing básico)

🎯 **Objetivo**: Comprobar que HTTP no cifra la información.

**Pasos**

1. Iniciar Wireshark en la interfaz correcta (Ethernet / WiFi / loopback).
2. Abrir un navegador.
3. Acceder a una web **HTTP** (no HTTPS), por ejemplo:

   ```
   http://neverssl.com
   ```
4. Aplicar filtro:

   ```
   http
   ```

**Qué deben observar**

* Peticiones `GET`
* Cabeceras HTTP
* URLs completas
* Posibles cookies

💡 **Conclusión didáctica**: cualquiera que escuche la red puede ver el contenido.

---

## 🧪 Ejemplo 2: Comparar HTTP vs HTTPS

🎯 **Objetivo**: Ver la diferencia entre tráfico cifrado y no cifrado.

**Pasos**

1. Acceder primero a:

   ```
   http://example.com
   ```
2. Luego a:

   ```
   https://example.com
   ```
3. Filtros:

   ```
   http
   ```

   y después:

   ```
   tls
   ```

**Qué deben observar**

* HTTP: contenido legible
* HTTPS: solo handshake TLS y datos cifrados

💡 **Conclusión**: HTTPS protege la privacidad.

---

## 🧪 Ejemplo 4: Capturar tráfico de localhost (127.0.0.1)

🎯 **Objetivo**: Ver comunicaciones internas del sistema.

**Preparación**

* Levantar un servidor local (Apache, Node, PHP…) en puerto 81.

**Pasos**

1. Capturar en interfaz loopback.
2. Acceder a:

   ```
   http://127.0.0.1:81
   ```
3. Filtro:

   ```
   ip.addr == 127.0.0.1 && tcp.port == 81
   ```

**Qué deben observar**

* Comunicación cliente-servidor local
* Peticiones HTTP completas

💡 **Mensaje clave**: incluso el tráfico local puede ser interceptado.

---

## 🧪 Ejemplo 4: Ver una contraseña en texto plano (FTP o HTTP)

🎯 **Objetivo**: Demostrar un riesgo real.

**Opción A – FTP**

1. Conectarse a un servidor FTP:

   ```
   ftp <servidor>
   ```
2. Introducir usuario y contraseña.
3. Filtro:

   ```
   ftp
   ```

👉 Buscar comandos `USER` y `PASS`

> Para hacer este apartado: instala servidor FTP
> sudo apt install vsftpd
> En la consola escribe:
> ftp <Tu nombre de usuario>
> Te pedirá la contraseña. Pon una cualquiera, no se trata de hacer un login real sino de ver que se pueden capturar tus claves

4. Guarda captura con las claves capturadas.

**Opción B – Login HTTP**

1. Instala php en tu máquina virtual
2. Coloca los ficheros login.html y login.php en la carpteta raiz del servidor. Probablemente `/var/www/html`

3. Inicia la captura
4. Accede a localhost:login.html y prueba el formulario de usuario y contraseña
5. Para la captura y filtra el tráfico para localizar las claves. Captura la pantalla con las claves capturadas.

* Filtro:

  ```
  http.request.method == "POST"
  ```

---

## 🧪 Ejemplo 5: Resolución DNS

🎯 **Objetivo**: Entender cómo funciona DNS.

**Pasos**

1. Abrir una web nueva.
2. Filtro:

   ```
   dns
   ```

**Qué deben observar**

* Consultas DNS
* Nombres de dominio solicitados
* IPs devueltas

💡 **Conclusión**: aunque uses HTTPS, el DNS puede revelar a qué webs accedes.

---

## 🧪 Ejemplo 6: Analizar un ping (ICMP)

🎯 **Objetivo**: Ver tráfico de red básico.

**Pasos**

1. Ejecutar:

   ```
   ping 8.8.8.8
   ```
2. Filtro:

   ```
   icmp
   ```

**Qué deben observar**

* Echo request
* Echo reply
* Tiempos de respuesta

💡 Ideal para empezar antes de protocolos más complejos.

---

## 🧪 Ejemplo 7: Escaneo con nmap + Wireshark (muy bueno 🔥)

🎯 **Objetivo**: Ver cómo se comporta un escaneo de puertos.

**Pasos**

1. Iniciar captura en Wireshark.
2. Ejecutar:

   ```
   nmap -p 1-100 <IP>
   ```
3. Filtro:

   ```
   tcp.flags.syn == 1
   ```

**Qué deben observar**

* Paquetes SYN
* Respuestas SYN-ACK / RST

💡 **Conclusión**: los escaneos son detectables.

---

## 🧪 Ejemplo 8: Tráfico cifrado de una VPN

🎯 **Objetivo**: Ver cómo la VPN protege el tráfico.

**Pasos**

1. Captura sin VPN → navegar.
2. Activar VPN.
3. Captura con VPN → navegar igual.
4. Filtro:

   ```
   ip
   ```

**Qué deben observar**

* Sin VPN: múltiples IPs destino
* Con VPN: casi todo va a una sola IP

💡 **Mensaje clave**: la VPN oculta el destino real del tráfico.

---

## 📌 Consejo para evaluación

Puedes pedirles:

* Captura + **captura de pantalla**
* Explicación de **qué datos se ven**
* Conclusión sobre **privacidad y seguridad**

Si quieres, en el próximo mensaje te preparo:

* ✅ **Una tabla resumen para apuntes**
* ✅ **Un guion de práctica evaluable**
* ✅ **Ejercicios con solución para IFC201**
