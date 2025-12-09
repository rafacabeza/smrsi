# Seguridad activa: Sistema operativo y aplicaciones

<!-- - Protección del equipo
  - Candadados
  - Bios
  - Boot Manager
  - Cifrado de particiones
- Autenticación en el S.O.
  - Usuario/Password
  - Tarjetas
  - Biometría
  - Elevación de privilegios
- Cuotas
- Actualizaciones y parches
- Antivirus
- Monitorización
- Aplicaciones web
- Cloud Computing -->

Hasta ahora hemos visto cuestiones de seguridad pasiva: qué hacemos para minimizar los daños si el ataque o incidente de seguridad se produce.

Ahora vamos a analizar la seguridad activa: qué hacemos para evitar que los ataques se produzcan o que tengan éxito.

## **1. Protección del equipo**

### **1.1. Seguridad física**

La **seguridad física** constituye la primera barrera de defensa en cualquier sistema informático. De poco sirve disponer de antivirus, cortafuegos o cifrado si un atacante puede acceder físicamente al equipo, retirar su disco, arrancarlo desde un USB o manipular el hardware. Es un aspecto frecuentemente olvidado, pero **fundamental para la integridad, disponibilidad y confidencialidad** de los sistemas.

* Importancia de impedir accesos no autorizados al hardware.
  * Protección de datos almacenados
  * Prevención de manipulación del sistema
  * Minimizar el riesgo de robo
  * Garantizar la continuidad del servicio

* Tipos de candados físicos:
  * Candados Kensington.
  * Cables de seguridad.
  * Cajas y racks con llave.

* Riesgos si se vulnera la seguridad física: acceso al disco, modificación del arranque, reseteo de contraseñas, falta de continuidad en el servicio.

### **1.2. BIOS/UEFI**

* Definición: Funciones principales y diferencias entre BIOS y UEFI.
  * Es el firmware que ayuda a manejar la placa base y sus componentes
  * BIOS es un sistema antiguo aunque se sigue usando el término
  * Actualmente se usa UEFI. Permite sistemás más modernos y seguros.
* Configuraciones críticas (de UEFI):
  * *Secure Boot.* Evita que el equipo arranque software no firmado o no confiable. Solo permite bootloaders autorizados (Windows Boot Manager, shim en Linux, etc.). Ayuda a prevenir bootkits y malware que se carga antes del sistema operativo.
  * *TPM (Trusted Platform Module).* Es un chip que permite procesar funciones de cifrado y guardar de forma segura ciertas claves de cifrado: de disco y/o carpetas, contraseña de administrador del S.O., datos biométricos de acdeso ... Es requisito obligatorio en W11.
  * Orden de arranque.
  * Deshabilitar arranque desde USB o desde red (PXE). Esto permitiría acceder al contenido del disco sin conocer las contraseñas del sistema.
* Contraseña BIOS/UEFI
  * Contraseña de acceso al firmware, para cambiar la configuración.
  * Contraseña de arranque (Boot password), para iniciar la máquina.

### **1.3. Boot Manager / Gestión del arranque**

* El gestor de arranque es el primer software que se ejecuta. 
  * Determina dónde está el sistema operativo que se inicia.
  * Permite elegir S.O. en entornos dualizados
* GRUB en Linux: funcionamiento y archivos clave.
  * Permite seleccionar:
    * Distintos kernels de Linux.
    * Otros sistemas operativos (Windows, BSD).
  * Archivos clave:
    * /boot/grub/grub.cfg: configuración principal.
    * /etc/default/grub: ajustes por defecto.
  * Opciones de seguridad:
    * Contraseña para modificar el menú.
    * Protección de edición de arranque temporal.
    * Arranque en modo seguro solo con kernels firmados.
* Windows Boot Manager: BCD (Boot Configuration Data).
  * Gestor de arranque de Windows moderno.
  * Se almacena en **BCD (Boot Configuration Data)**.
  * Funciones:
    * Selección de versión de Windows.
    * Configuración de inicio seguro.
    * Recuperación del sistema.
  * Se puede gestionar con `bcdedit` desde el símbolo del sistema.
  * Riesgos:
    * Si se modifica el BCD sin protección, un atacante puede iniciar con privilegios elevados o cargar otro sistema.


* Ataques comunes:
  * Ataques Evil Maid (*la limpiadora mala*). Para robar claves o contraseñas y acabar accediendo al sistema.
  * Manipulación del cargador de arranque.
* Opciones de protección:
  * Contraseñas de GRUB.
  * Secure Boot.
  * Protección del BCD.
  
> NOTA.
> Estamos hablando de niveles de seguridad altos. Como veis, no es habitual encontrar todas estas contraseñas en el arranque de ordenadores.

### **1.4. Cifrado de particiones**

* Cifrado completo de disco (FDE) vs. cifrado de archivos.

  El cifrado de particiones es una técnica de seguridad que protege la información almacenada en un disco o unidad de almacenamiento, convirtiéndola en datos ilegibles para usuarios no autorizados. Incluso si alguien obtiene acceso físico al disco, no podrá leer los datos sin la clave de descifrado.

* Tecnologías disponibles:

  * Windows: BitLocker.
  * Linux: LUKS/dm-crypt.
  * macOS: FileVault.
* Conceptos clave:
  * Claves de recuperación: sin las claves de recuperación no hay posibilidad de leer el disco/partición.
  * Relación con TPM. TPM permite arrancar sin poner la contraseña cada vez.
* Limitaciones y buenas prácticas.

---

## **2. Autenticación en el sistema operativo**

### **2.1. Usuario/Contraseña**

* Políticas de contraseñas:

  * Complejidad.
  * Caducidad.
  * Reintentos fallidos.
* Herramientas de hash:

  * Linux: `/etc/shadow`, hashes SHA512.
  * Windows: SAM, NTLM.

### **2.2. Autenticación multifactor**

* Tarjetas inteligentes (SmartCards).
* Tokens FIDO2 y U2F.
* Aplicaciones OTP (Google Authenticator, etc.).

### **2.3. Biometría**

* Huellas, reconocimiento facial, iris.
* Ventajas e inconvenientes.
* Riesgos y falsificación.

### **2.4. Elevación de privilegios**

* Linux:

  * `sudo`, sudoers y políticas.
  * Separación de roles.
* Windows:

  * UAC (User Account Control).
  * Run as administrator.
* Control de privilegios mínimos.

---

## **3. Cuotas de disco**

* Objetivo: prevenir abusos de almacenamiento.
* Tipos:

  * Cuotas por usuario.
  * Cuotas por grupo.
  * Cuotas blandas y duras.
* Implementación:

  * Windows: Administrador de almacenamiento.
  * Linux: sistema de cuotas (`edquota`, `quotas`, `repquota`).

---

## **4. Actualizaciones y parches**

* Tipos de actualizaciones:

  * De seguridad.
  * Correctivas.
  * Evolutivas.
* Windows Update: características y WSUS.
* Linux: apt/yum/dnf — repositorios seguros.
* Riesgos de no actualizar.
* Estrategias:

  * Patching escalonado.
  * Ventanas de mantenimiento.

---

## **5. Antivirus y antimalware**

* Funcionamiento:

  * Firmas.
  * Heurística.
  * Detección basada en comportamiento.
* Tipos de malware.
* Limitaciones de los antivirus.
* Analizadores online (VirusTotal).
* Antimalware en Linux.

---

## **6. Monitorización y auditoría**

* Registros del sistema:

  * Windows Event Viewer.
  * Linux: systemd-journald, /var/log.
* IDS/IPS básicos.
* Control de integridad:

  * AIDE (Linux).
  * Windows Defender Application Control.
* Tareas programadas y servicios sospechosos.

---

## **7. Seguridad en aplicaciones web**

* Riesgos comunes:

  * Inyección SQL.
  * XSS.
  * CSRF.
  * Subida de archivos maliciosos.
* Buenas prácticas del servidor:

  * Configuración segura de Apache/Nginx.
  * Permisos mínimos.
* HTTPS y certificados.
* Seguridad en sesiones y cookies.
* Concepto de hardening de aplicaciones web.

---

## **8. Cloud Computing y seguridad**

* Tipos de despliegues:

  * IaaS, PaaS, SaaS.
* Responsabilidad compartida.
* Seguridad en el acceso:

  * MFA.
  * Gestión de claves.
* Backups y snapshots.
* Control de costes y cierres de sesión automáticos.
* Riesgos frecuentes:

  * Exposición de buckets públicos.
  * Claves en repositorios Git.

---

# 🧪 **TÍTULOS DE PRÁCTICAS (para VMs)**

## **Bloque 1 — Seguridad del equipo y del arranque**

1. **Configuración segura de BIOS/UEFI y arranque protegido.**
2. **Habilitación del Secure Boot y TPM en máquinas virtuales.**
3. **Cifrado completo de disco con LUKS en Linux.**
4. **Cifrado del disco del sistema con BitLocker en Windows.**
5. **Protección de GRUB con contraseña y verificación de la cadena de arranque.**

## **Bloque 2 — Autenticación y control de acceso**

6. **Configuración de políticas de contraseñas en Linux y Windows.**
7. **Implementación de doble factor en Windows/Linux (autenticación OTP).**
8. **Gestión de privilegios y sudoers en Linux.**
9. **Gestión de permisos NTFS y UAC avanzado en Windows.**

## **Bloque 3 — Administración de recursos**

10. **Implementación de cuotas de disco en Linux.**
11. **Configuración de cuotas de almacenamiento en Windows.**

## **Bloque 4 — Actualización y endurecimiento del SO**

12. **Actualización, rollback y auditoría de parches (Windows + Linux).**
13. **Hardening básico del sistema operativo (Windows y Linux).**

## **Bloque 5 — Protección contra malware**

14. **Análisis de malware simulado con un antivirus y herramientas online.**
15. **Monitorización de eventos sospechosos con el visor de eventos y journald.**

## **Bloque 6 — Seguridad en aplicaciones web**

16. **Instalación de un servidor web vulnerable y explotación controlada (DVWA / Mutillidae).**
17. **Aplicación de medidas de hardening en Apache/Nginx.**

## **Bloque 7 — Seguridad en la nube**

18. **Creación de una instancia en la nube con políticas de seguridad básicas.**
19. **Simulación de errores comunes en la nube (bucket público, claves expuestas).**