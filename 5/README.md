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

## 1. Protección del equipo

### 1.1. Seguridad física

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

### 1.2. BIOS/UEFI

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

### 1.3. Boot Manager / Gestión del arranque

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

### 1.4. Cifrado de particiones

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

## 2. Autenticación en el sistema operativo

### 2.1. Usuario/Contraseña

#### Usuarios

En Windows pueden existir **tres tipos principales de cuentas de usuario**, cada una con características, ventajas y limitaciones diferentes. 
Desde el punto de vista de quién gestiona la existencia de un usuario y su autenticación:

**1)  Cuenta Local

Es la cuenta tradicional que existe **solo en ese equipo**. Es usada en Windows. Es el tipo de cuenta linux más generalizada.

Características

* Las credenciales se almacenan **localmente**.
* No requiere conexión a Internet.
* No sincroniza datos con otros dispositivos.
* Control total sobre la privacidad, ya que los datos no salen del equipo.

✔ Ventajas

* Funciona siempre, incluso sin Internet.
* Mayor control sobre los datos personales.
* Útil para entornos cerrados o máquinas virtuales.

✖ Limitaciones

* No permite sincronizar configuraciones, contraseñas u OneDrive.
* Dificulta la recuperación de la contraseña si la olvidas.

2) Cuenta Microsoft (M365 Personal / Hotmail / Outlook)**

Es una cuenta vinculada al **ecosistema Microsoft** que permite sincronización entre dispositivos.

Características

* Usa un correo @hotmail, @outlook o similar.
* Permite sincronizar configuraciones del sistema, Edge, contraseñas, apps y OneDrive.
* Habilita funciones como:

  * Windows Hello (PIN, huella, webcam)
  * BitLocker recovery automatico
  * Respaldo de configuraciones en la nube

✔ Ventajas

* Recuperación de cuenta mediante correo, SMS o 2FA.
* Sincronización entre varios equipos.
* Mejora la seguridad gracias a MFA.

✖ Limitaciones

* Requiere conexión ocasional a Internet.
* Algunos usuarios prefieren no enlazar la cuenta del sistema con la nube.

3) Cuenta de Active Directory (AD) / Azure AD / Entra ID**

Usada en **empresas, centros educativos y redes corporativas**. En linux existen sistemas similares basados en LDAP pero no los vamos a ver con detalle.

Características

* Gestionadas desde un **servidor** (AD clásico) o la nube (Azure AD / Entra ID).
* Permite políticas centralizadas:

  * Contraseñas
  * Software permitido
  * Restricciones de seguridad
  * Accesos a recursos compartidos

✔ Ventajas

* Control centralizado para administradores.
* Gestión masiva de usuarios.
* Seguridad avanzada con políticas de empresa.
* Autenticación con SSO en apps corporativas.

✖ Limitaciones

* Requiere infraestructura (servidor AD o suscripción a Entra ID).
* Solo útil en entornos profesionales.

# 📝 Resumen rápido

| Tipo de cuenta               | Dónde se usa                    | Ventajas                      | Limitaciones                             |
| ---------------------------- | ------------------------------- | ----------------------------- | ---------------------------------------- |
| **Local**                    | Uso personal, VMs, laboratorios | Privacidad, sin Internet      | Sin sincronización ni recuperación fácil |
| **Microsoft**                | Usuarios domésticos             | Sincroniza, 2FA, recuperación | Vinculada a la nube                      |
| **Active Directory / Entra** | Empresas y escuelas             | Políticas centralizadas, SSO  | Requiere infraestructura                 |


#### Contraseñas

En los sistemas que usan usuario/contraseña se deben definir unas políticas de contraseña.

**1) Longitud mínima**

  * **12 caracteres** como mínimo.
  * Preferible **16 o más** para cuentas críticas.

**2) Complejidad razonable**

  * Mezclar **mayúsculas, minúsculas, números y símbolos**, **pero sin reglas obligatorias absurdas** (evitar “tiene que llevar al menos 1 símbolo”).
  * Mejor fomentar **contraseñas largas** que complicadas.

**3) No reutilización**

  * **Prohibido usar la misma contraseña** en varios servicios.
  * Cambios obligatorios únicamente si hay sospecha o brecha.

**4) Bloqueo ante intentos fallidos**

  * Bloquear la cuenta temporalmente tras **5–10 intentos** fallidos.
  * Evita ataques de fuerza bruta.

**5) Almacenamiento seguro**

  * Nunca guardar contraseñas en texto plano.
  * Usar gestor de contraseñas

**6) Autenticación multifactor (MFA)**

* Requerir MFA en:

  * Cuentas administrativas
  * Accesos remotos
  * Servicios críticos

**7) Prohibir contraseñas débiles**

* Bloquear automáticamente contraseñas:

  * Muy comunes ("123456", "admin", "password")
  * Basadas en el nombre del usuario
  * Detectadas en listas de filtraciones (**HIBP**, etc.)

**8) Frases de paso (passphrases)**

* Promover **frases fáciles de recordar pero largas**, ejemplo:
  👉 `PatoNaranjaBaila2024!`

**9) Evitar cambios periódicos forzados**

* Ya no se recomienda cambiar contraseñas cada 30–90 días.
* Solo cambiar si:

  * se sospecha compromiso
  * se detecta filtración
  * el usuario la ha compartido

**10) Formación y concienciación**

* Explicar a los usuarios:

  * cómo crear contraseñas seguras
  * cómo usar gestores
  * cómo detectar phishing


Las contraseñas se basan en el principio **algo que sabes**. En este grupo podemos poner también los PIN, frases secretas y las (poco recomendadas) preguntas de seguridad.

Las contraseñas tienen algunos inconvenientes:

- Son fáciles de robar (fishing, keyloggers, malware)
- Funcionan en cualqueir sitio. Si alguien la obtiene tiene acceso total.
- Se reutilizan, algo que es un problema de seguridad.
- Son problemáticas y costosas de mantener: se olvidan, las cuentas se bloquean, requieren mantenimiento, ...

### 2.2. Autenticación de doble factor (A2F/2FA) y multifactor (MFA)

Para superar estos problemas se añaden otros mecanismos basados en otros principios:

- Algo que tienes
  - Teléfono móvil (usar la proximidad vía NFC o Bluetooth)
  - Llave física tipo FIDO2 o Yubikey
  - Tarjeta inteligente
  - Certificado digital
  - Aplicación para contraseñas de un solo uso (OTP): Google Authenticator, Microsoft Authenticator, Authy, ...
  - SMS/Email
- Algo que eres, las principales:
  - Huella dactilar
  - Reconocimiento facial
  - Reconocimiento de iris
- Existen otros como: elgún lugar donde estás, algo que haces, ...

Para superar estos problemas aparecen un conjunto de mecanismos o sistemas más seguros:

* Tarjetas inteligentes (SmartCards), por ejemplo DNI electrónico.
* Tokens FIDO2.
* Aplicaciones OTP (Google Authenticator, etc.).

Estos mecanismos se pueden usar de forma aislada o en combinación de dos o más de ellos:

* A2F (o 2FA), autenticación de 2 factores a la combinación de dos de estos sistemas, muy habitualmente contraseña + uno de los citados recientemente. Por ejemplo contraseña + SMS.
* MFA es una ampliación de A2F, permite que sean más de 2 los factores utilizados. O diversas combinaciónes de 2 o más. Estos sistemas se usan en aplicaciones críticas, banca, y sistemas empresariales.

> [OJO! FIDO2 y smartcards también porían usarse para login directo](https://www.youtube.com/watch?v=L32w9WAEqRs)
> 
> [Login con Yubikey](https://www.youtube.com/watch?v=3IBS4v8U7_M)
> 
> [Login con smartcard](https://www.youtube.com/watch?v=x9brdyDGmNo) 

Algunos de estos sistemas permiten una autenticación sin contraseña (*passwordless*), algo que a medio o largo plazo puede convertirse en el objetivo de muchos sistemas informáticos.

### 2.3. Gestores de contraseñas

#### 🔐 ¿Qué es un gestor de contraseñas?

Un **gestor de contraseñas** es una herramienta que:

* Guarda todas tus contraseñas en una **bóveda cifrada**.
* Te permite usar **contraseñas largas y únicas** sin tener que recordarlas.
* Autocompleta credenciales en páginas web y aplicaciones.
* Sincroniza tus claves entre dispositivos de forma segura.

#### 🛡️ ¿Por qué es recomendable su uso en 2025?

Hoy es más necesario que nunca porque:

* Cada servicio exige **contraseñas fuertes y únicas** para evitar robos.
* La mayoría de ataques ocurren por **contraseñas débiles o reutilizadas**.
* Hay un aumento constante de **filtraciones masivas** de datos.
* Usamos más dispositivos (PC, móvil, tablet), y un gestor evita errores.
* Permite activar fácilmente la **autenticación en dos pasos (2FA)**.

En resumen: **seguridad, comodidad y prevención de ataques**.

#### 📋 Ejemplos de gestores de contraseñas (los más usados en 2025)

* **Bitwarden** (open-source, gratuito y muy completo)
* **KeePass / KeePassXC** (archivos locales, open-source). No hay un servidor que almacene las claves y que sirva para sincronizarlas. Es ideal pero más laborioso de aprender y poner en marcha. 
* **1Password** (de pago, muy popular en empresas)
* **LastPass** (comercial, versión gratuita limitada)
* **Dashlane** (comercial)
* **NordPass** (comercial)

#### ⭐ Reseña breve de Bitwarden (el que usarás con tus alumnos)

**Bitwarden** es un gestor de contraseñas **open-source**, seguro y multiplataforma.
Su **versión gratuita** ofrece:

* Almacenamiento ilimitado de contraseñas.
* Sincronización entre todos tus dispositivos.
* Extensiones para todos los navegadores.
* Aplicaciones para Windows, Linux, macOS, Android e iOS.
* Autocompletado de credenciales.
* Generador de contraseñas seguras.
* Cifrado extremo a extremo (solo el usuario puede ver sus datos).
* Posibilidad de compartir contraseñas con una persona.

Es ideal para alumnos porque es:

* **Sencillo de usar**
* **Seguro por diseño**
* **Gratis sin limitaciones importantes**
* **Transparente** (código abierto)
* Perfecto para introducir conceptos de **seguridad digital** y **buenas prácticas**.

> En este momento realiza la práctica 502: Uso de bitwarden

### 2.4. Windows Hello

#### ¿Qué es Windows Hello?

**Windows Hello** es el sistema de **autenticación segura de Windows 10 y 11** que permite iniciar sesión **sin usar directamente la contraseña**, utilizando métodos más seguros y cómodos.

Forma parte de la estrategia **passwordless** de Microsoft.

#### Métodos de autenticación que incluye

##### 🔢 **PIN**

* Código numérico (o alfanumérico).
* **Vinculado solo a ese dispositivo**.
* No funciona en otros equipos, aunque lo roben.

✔ Más seguro que una contraseña reutilizada.

##### 🧬 **Biometría**

* **Huella dactilar**
* **Reconocimiento facial**

✔ La biometría **no se envía a Microsoft**.
✔ Se almacena de forma segura en el dispositivo (TPM).

##### 🔑 **Llaves de seguridad (FIDO2)**

* USB, NFC o Bluetooth.
* Autenticación fuerte y resistente al phishing.

#### ¿Cómo funciona internamente? (simplificado)

* Windows Hello usa **criptografía asimétrica**.
* La **clave privada** se guarda en el **TPM** del equipo.
* La clave **nunca sale del dispositivo**.
* El servidor solo valida la **clave pública**.

👉 No se transmite contraseña.

#### ¿Es realmente más seguro?

Sí, porque:

* El PIN no sirve fuera del dispositivo.
* La biometría no se puede “copiar” fácilmente.
* Es resistente a:

  * Phishing
  * Keyloggers
  * Ataques de fuerza bruta remotos

#### Requisitos

* Windows 10/11
* TPM 2.0 (chip habitual en equipos modernos)
* Para biometría: hardware compatible (sensor o cámara IR)

#### ¿Qué pasa si falla?

* Siempre existe **método de respaldo**:

  * Contraseña tradicional
  * Cuenta Microsoft
  * Recuperación del sistema

#### Ventajas

✔ Más seguro que contraseñas
✔ Más cómodo para el usuario
✔ Integrado en Windows
✔ Compatible con MFA
✔ Base para passwordless

#### Limitaciones

⚠️ Requiere hardware compatible
⚠️ No sustituye MFA en servicios externos
⚠️ Está pensado para cuentas Microsoft, en cuentas locales avanzadas tiene menos opciones.

#### Ejemplo práctico típico

> **Windows Hello = PIN + biometría + TPM**

### 2.5. Elevación de privilegios

* Linux:

  * `sudo`, sudoers y políticas.
  * Separación de roles.
* Windows:

  * UAC (User Account Control).
  * Run as administrator.
* Control de privilegios mínimos.

## 3. Cuotas de disco

Las **cuotas de disco** son un mecanismo del sistema operativo que permite:

* **Limitar el espacio de almacenamiento** que puede usar:

  * un usuario
  * o un grupo
* **Controlar el uso de recursos**
* **Evitar abusos** (llenar el disco, DoS local)
* **Planificar capacidad**

👉 Son una medida de **seguridad activa** y **administración preventiva**.

---

### ¿Qué problemas evitan?

Sin cuotas:

* Un usuario puede llenar el disco
* El sistema deja de funcionar correctamente
* Servicios críticos fallan (logs, bases de datos)

Con cuotas:

* Se limita el impacto
* Se detectan usos anómalos
* Se protege la estabilidad del sistema

### Tipos de cuotas

* Cuotas por usuario. Limita el espacio que puede usar cada usuario

* Cuotas por grupo. Controla el uso compartido por un grupo

* Tipos de límite
  * Soft limit. Si se pasa hay un aviso y un margen temporal para bajar del límite. Tras ese periodo de gracia se bloque el almacenamiento si se no se habajado del límite.
  * Hard limit. Bloque total, es como si el disco estuviera lleno.

### Cuotas de disco en Linux

#### Sistemas de archivos compatibles

* ext4
* xfs
* btrfs (con mecanismos propios)
* NFS (según configuración)

#### Herramientas habituales

* `quota`
* `edquota`
* `repquota`
* `quotacheck`

#### Funcionamiento básico (ext4)

1. Activar cuotas en el sistema de archivos
1. Definir cuotas por usuario o grupo
1. Monitorizar el uso
1. Aplicar límites

#### Ejemplo de uso típico en Linux

* Servidores multiusuario
* Centros educativos
* Hosting compartido
* Servidores de archivos (Samba, NFS)

#### Ventajas en Linux

✔ Muy granular
✔ Por usuario y grupo
✔ Integrable con scripts
✔ Visible por consola

### 5️⃣ Cuotas de disco en Windows

#### NTFS Disk Quotas

Windows ofrece cuotas en volúmenes **NTFS**:

* Por usuario
* A nivel de volumen
* Integrado en el sistema

#### Opciones disponibles

* Limitar espacio por usuario
* Mostrar advertencias
* Registrar eventos en el visor
* Bloquear escritura al superar el límite

#### Configuración

Desde:

* Explorador → Propiedades del disco → Cuota
* Directivas de grupo (entornos profesionales)
* PowerShell

#### Limitaciones en Windows

❌ No por carpeta
❌ No por grupo (nativo)
❌ No por aplicación

> NOTA: En Windows Server las posibilidades son más completas

### 6️⃣ Comparativa Linux vs Windows

| Característica          | Linux                | Windows  |
| ----------------------- | -------------------- | -------- |
| Cuotas por usuario      | ✔                    | ✔        |
| Cuotas por grupo        | ✔                    | ❌        |
| Soft / Hard limit       | ✔                    | ❌        |
| Por sistema de archivos | ✔                    | ✔ (NTFS) |
| Gestión por consola     | ✔                    | ✔        |
| Gestión gráfica         | ❌ / ✔ (según distro) | ✔        |

---

### 7️⃣ Relación con Seguridad Informática

Las cuotas ayudan a:

* Prevenir **denegación de servicio local**
* Controlar usuarios maliciosos o descuidados
* Detectar uso anómalo de disco
* Proteger logs y servicios

👉 Son una **medida preventiva**, no reactiva.



## 4. Actualizaciones y parches

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

## 5. Antivirus y antimalware

* Funcionamiento:

  * Firmas.
  * Heurística.
  * Detección basada en comportamiento.
* Tipos de malware.
* Limitaciones de los antivirus.
* Analizadores online (VirusTotal).
* Antimalware en Linux.

## 6. Monitorización y auditoría

* Registros del sistema:

  * Windows Event Viewer.
  * Linux: systemd-journald, /var/log.
* IDS/IPS básicos.
* Control de integridad:

  * AIDE (Linux).
  * Windows Defender Application Control.
* Tareas programadas y servicios sospechosos.

## 7. Seguridad en aplicaciones web

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

## 8. Cloud Computing y seguridad

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

<!-- 
# 🧪 TÍTULOS DE PRÁCTICAS (para VMs)

##Bloque 1 — Seguridad del equipo y del arranque

1. Configuración segura de BIOS/UEFI y arranque protegido.
2. Habilitación del Secure Boot y TPM en máquinas virtuales.
3. Cifrado completo de disco con LUKS en Linux.
4. Cifrado del disco del sistema con BitLocker en Windows.
5. Protección de GRUB con contraseña y verificación de la cadena de arranque.

##Bloque 2 — Autenticación y control de acceso

6. Configuración de políticas de contraseñas en Linux y Windows.
7. Implementación de doble factor en Windows/Linux (autenticación OTP).
8. Gestión de privilegios y sudoers en Linux.
9. Gestión de permisos NTFS y UAC avanzado en Windows.

##Bloque 3 — Administración de recursos

10. Implementación de cuotas de disco en Linux.
11. Configuración de cuotas de almacenamiento en Windows.

##Bloque 4 — Actualización y endurecimiento del SO

12. Actualización, rollback y auditoría de parches (Windows + Linux).
13. Hardening básico del sistema operativo (Windows y Linux).

##Bloque 5 — Protección contra malware

14. Análisis de malware simulado con un antivirus y herramientas online.
15. Monitorización de eventos sospechosos con el visor de eventos y journald.

##Bloque 6 — Seguridad en aplicaciones web

16. Instalación de un servidor web vulnerable y explotación controlada (DVWA / Mutillidae).
17. Aplicación de medidas de hardening en Apache/Nginx.

##Bloque 7 — Seguridad en la nube

18. Creación de una instancia en la nube con políticas de seguridad básicas.
19. Simulación de errores comunes en la nube (bucket público, claves expuestas). -->