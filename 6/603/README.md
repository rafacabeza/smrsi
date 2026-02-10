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
port 1194
proto udp
dev tun

ca ca.crt
cert servidor.crt
key servidor.key
dh dh.pem
tls-auth ta.key 0

server 10.8.0.0 255.255.255.0
push "route 192.168.100.0 255.255.255.0"

keepalive 10 120
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun

status openvpn-status.log
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
client
dev tun
proto udp
remote IP_SERVIDOR_VPN 1194

resolv-retry infinite
nobind
persist-key
persist-tun

ca ca.crt
cert cliente1.crt
key cliente1.key
tls-auth ta.key 1

cipher AES-256-CBC
auth SHA256
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

