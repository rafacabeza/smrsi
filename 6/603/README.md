# Práctica: VPN con OpenVPN en VirtualBox

## Objetivo de la práctica

Configurar una VPN con OpenVPN para que un equipo externo pueda conectarse a una red local y acceder a sus recursos como si estuviera en la misma LAN. Comprobar que el tráfico viaja cifrado y no es legible mediante sniffing.

---

## Escenario

Se usarán tres máquinas virtuales en VirtualBox:

1. Servidor VPN (Ubuntu Server)

   * Adaptador 1: NAT
   * Adaptador 2: Red interna (`red_vpn`)
2. Cliente VPN (Ubuntu Desktop o Server)

   * Adaptador 1: NAT
3. Servidor interno (Ubuntu Server)

   * Adaptador 1: Red interna (`red_vpn`)

El servidor VPN tendrá acceso a Internet y a la red interna.
El servidor interno solo será accesible a través de la VPN.

---

## 1. Instalación de OpenVPN en el servidor VPN

En la máquina **Servidor VPN**:

```bash
sudo apt update
sudo apt install openvpn easy-rsa -y
```

---

## 2. Creación de la infraestructura de certificados

### 2.1 Crear el directorio de trabajo de Easy-RSA

```bash
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
```

### 2.2 Inicializar la infraestructura PKI

```bash
./easyrsa init-pki
```

---

## 3. Generar la Autoridad Certificadora (CA)

```bash
./easyrsa build-ca
```

Cuando se solicite el **Common Name**, introducir:

```
CA-OPENVPN
```

Este certificado será la Autoridad Certificadora que firmará el resto de certificados.

---

## 4. Generar el certificado del servidor VPN

### 4.1 Crear la solicitud de certificado

```bash
./easyrsa gen-req servidor nopass
```

Common Name:

```
servidor
```

### 4.2 Firmar el certificado del servidor

```bash
./easyrsa sign-req server servidor
```

Confirmar escribiendo:

```
yes
```

---

## 5. Generar el certificado del cliente VPN

### 5.1 Crear la solicitud de certificado

```bash
./easyrsa gen-req cliente1 nopass
```

Common Name:

```
cliente1
```

### 5.2 Firmar el certificado del cliente

```bash
./easyrsa sign-req client cliente1
```

Confirmar con:

```
yes
```

---

## 6. Generar parámetros criptográficos adicionales

### 6.1 Generar Diffie-Hellman

```bash
./easyrsa gen-dh
```

### 6.2 Generar clave TLS adicional

```bash
openvpn --genkey --secret ta.key
```

---

## 7. Copiar certificados al directorio de OpenVPN

```bash
sudo cp pki/ca.crt /etc/openvpn/
sudo cp pki/issued/servidor.crt /etc/openvpn/
sudo cp pki/private/servidor.key /etc/openvpn/
sudo cp pki/dh.pem /etc/openvpn/
sudo cp ta.key /etc/openvpn/
```

---

## 8. Configuración del servidor OpenVPN

Crear el fichero de configuración:

```bash
sudo nano /etc/openvpn/server.conf
```

Contenido completo del fichero:

```conf
# Puerto en el que escucha el servidor OpenVPN (por defecto 1194)
port 1194

# Protocolo de transporte utilizado (UDP es el más habitual)
proto udp

# Tipo de interfaz virtual:
# tun = nivel 3 (IP)
dev tun

# Certificado de la Autoridad Certificadora (CA)
# Sirve para validar clientes y servidor
ca ca.crt

# Certificado público del servidor VPN
cert servidor.crt

# Clave privada del servidor (debe mantenerse secreta)
key servidor.key

# Parámetros Diffie-Hellman para el intercambio seguro de claves
dh dh.pem

# Clave adicional para proteger el canal TLS
# El 0 indica que este fichero se usa en el servidor
tls-auth ta.key 0

# Red virtual que asigna el servidor a los clientes VPN
# El servidor suele usar la IP 10.8.0.1
server 10.8.0.0 255.255.255.0

# Ruta que el servidor envía ("push") a los clientes
# Permite acceder a la red interna 192.168.100.0/24 a través de la VPN
push "route 192.168.100.0 255.255.255.0"

# Mantiene la conexión activa:
# ping cada 10 segundos, reinicia tras 120 sin respuesta
keepalive 10 120

# Algoritmo de cifrado simétrico para los datos
cipher AES-256-CBC

# Algoritmo de autenticación e integridad
auth SHA256

# Mantiene la clave cargada aunque se reinicie la conexión
persist-key

# Mantiene la interfaz tun activa entre reconexiones
persist-tun

# Fichero donde se guarda el estado del servidor VPN
status openvpn-status.log

# Nivel de detalle de los logs (3 = normal, adecuado para prácticas)
verb 3
```

La red `192.168.100.0/24` corresponde a la red interna de VirtualBox.

---

## 9. Activar el reenvío de paquetes IP

Editar el fichero:

```bash
sudo nano /etc/sysctl.conf
```

Descomentar o añadir la línea:

```conf
net.ipv4.ip_forward=1
```

Aplicar los cambios:

```bash
sudo sysctl -p
```

---

## 10. Arrancar el servicio OpenVPN

```bash
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server
```

Comprobar que existe la interfaz VPN:

```bash
ip a
```

Debe aparecer la interfaz `tun0`.

---

## 11. Configurar el servidor interno

En la máquina **Servidor interno**:

```bash
sudo apt update
sudo apt install apache2 -y
ip a
```

Anotar la dirección IP asignada (por ejemplo `192.168.100.20`).

---

## 12. Preparar los archivos del cliente VPN

En el **Servidor VPN**:

```bash
mkdir ~/cliente1
cd ~/cliente1
```

Copiar los archivos necesarios:

```bash
cp ~/openvpn-ca/pki/ca.crt .
cp ~/openvpn-ca/pki/issued/cliente1.crt .
cp ~/openvpn-ca/pki/private/cliente1.key .
cp ~/openvpn-ca/ta.key .
```

Crear el fichero de configuración del cliente:

```bash
nano cliente1.ovpn
```

Contenido del fichero:

```conf
# Indica que esta configuración es para un cliente
client

# Tipo de interfaz virtual (debe coincidir con el servidor)
dev tun

# Protocolo de transporte (debe coincidir con el servidor)
proto udp

# Dirección IP o nombre del servidor VPN y su puerto
remote IP_SERVIDOR_VPN 1194

# Reintenta la conexión indefinidamente si falla
resolv-retry infinite

# No fija un puerto local (útil en clientes detrás de NAT)
nobind

# Mantiene la clave cargada entre reconexiones
persist-key

# Mantiene la interfaz tun activa entre reconexiones
persist-tun

# Certificado de la Autoridad Certificadora
# Permite verificar que el servidor es legítimo
ca ca.crt

# Certificado público del cliente
cert cliente1.crt

# Clave privada del cliente (no debe compartirse)
key cliente1.key

# Clave TLS adicional para proteger el canal de control
# El 1 indica que este fichero se usa en el cliente
tls-auth ta.key 1

# Algoritmo de cifrado (debe coincidir con el servidor)
cipher AES-256-CBC

# Algoritmo de autenticación (debe coincidir con el servidor)
auth SHA256

# Nivel de detalle de los logs
verb 3
```

Sustituir `IP_SERVIDOR_VPN` por la IP real del servidor VPN.

---

## 13. Conexión del cliente a la VPN

En la máquina **Cliente VPN**:

```bash
sudo apt update
sudo apt install openvpn -y
sudo openvpn --config cliente1.ovpn
```

La conexión será correcta si aparece el mensaje:

```
Initialization Sequence Completed
```

---

## 14. Comprobaciones finales

En el cliente VPN:

```bash
ip a
ping 192.168.100.20
curl http://192.168.100.20
```

El acceso al servidor web interno solo debe funcionar cuando la VPN esté activa.

---

## 15. Análisis con Wireshark

1. Capturar tráfico sin VPN y observar tráfico HTTP en claro.
2. Capturar tráfico con VPN activa.
3. Comprobar que solo se observa tráfico UDP cifrado hacia el puerto 1194.

---

## Resultado esperado

El cliente accede a recursos de la red interna como si estuviera en la LAN y el tráfico viaja cifrado, impidiendo la inspección del contenido.

