# Criptografía

## ¿Por qué cifrar?

- La información es muy importante. Imagina: planos, dinero, documentos personales o de empresa, fotos, ...
- Actualmente la información viaja a través de redes informáticas, de Internet, y alguien podría interceptarla.

## Introducción a la Criptografía

- Criptografía viene del griego cripto (que significa «ocultar») y graphos (que significa «escribir»).
- Para poder cifrar y descifrar debemos seguir una "reglas". Esas reglas son el llamado **algoritmo**.
- Un mismo algoritmo da diferentes mensajes cifrados. Para lograrlo debemos usar diferentes **claves**.
- Consideraciones sobre las claves:
  - Alguien puede intentar averiguarlas: ataques de **fueza bruta** (todas las combinaciones posibles) y ataques de **diccionario** (es decir usando claves, palabras, que alguien ha recopilado como posibles claves).
  - Cuanto más larga más difícil de averiguar
  - Cuanto mayor número de caracteres se usan más difícil de averiguar
  - Es conveniente cambiarla regularmente
  - No debemos usar palabras identificables.
  - Una medida de seguridad es bloquear cuentras si hay intentos repetidos.

### El origen. Cifrado César

- El primer algoritmo de cifrado fue usado por el general romano Julio Cesar.
- Es un cifrado simple por sustitución. Cada caracter se sustituye por el que ocupa "N" posiciones más adelante en el alfabeto.
- Típicamente el desplazamiento es N=3, pero puede ser cualqier número entre 1 y 25.
- La tabla de sustitución para N=3 es:

```
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
D E F G H I J K L M N O P Q R S T U V W X Y Z A B C
```

- Así "Santiago Hernandez" se cifraría como "Xfsyfnlt Mjwsfsije"
- Prueba a cifrar "Zaragoza" con desplzamiento 3 y con desplazamiento 6


## Criptografía simétrica

- Damos ese nombre a los algoritmos que usan la misma clave para codificar y para decodificar los mensajes. 
- Sencillos de usar y rápidos. Hasta los años 70 todos eran así.
- El primero conocido: César. La clave es el desplazamiento N.
- Más modernos: DES, 3DES, AES, Blowfish e IDEA.
- Ejemplo: telefonía SIM.
  - La tarjeta SIM tiene un identificador único, un *dni* y una clave de cifrado.
  - El proveeror (Movistar, Vodafone,...) conoce el identificador y la clave de cifrado.
  - Toda la comunicación es cifrada y descifrada usando la clave que ambos conocen.
  - La tarjeta SIM es la que cifra (y descifra) la comunicación, no es el teléfono. La clave no puede ser averiguada.
- Sencillo y eficiente. 
- **La dificultad principal es el intercambio de claves**.
- Principales algoritmos: DES, 3DES, **AES** (AES256, AES192, AES128), Blowfish e IDEA.


> **Explicación más detallada algoritmo AES**
>
> - AES cifra usando claves de 128, 192 o 256 bits. Por comparar, una IPv4 es una cadena de 32bits. Una IPv6 es de 128.
> - Sin embargo nosotros le damos una contraseña de longitud aleatoria. 
> 
> ¿Cómo funciona todo esto?
> 
> - La contraseña dada y una cadena aleatoria, inventada al azar. Se pasan por un algoritmo que genera una clave aleatora de 128, 192 o 256bit. Cuanto más larga más segura.
> - La clave obtenida es la que realmente se usa para cifrar.
> - El fichero resultado, lleva una parte no cifrada: el algoritmo usado, y la cadena aleatoria a la que se le llama sal o *salt* en inglés.
> - Si no usaramos esa "sal", la clave de cifrado de una contraseña sería siempre igual y sería fácil hacer ataques por diccionario.
> - Al descifrar, se usa la contraseña dada y la sal para calcular la clave de cifrado y descifrar el mensaje.

- Vídeo: Criptografía simétrica: https://www.youtube.com/watch?v=SlSmI18T2Ns&list=PLG1hKOHdoXkt1V51gyPMZqgQ8LjK3LfmJ&index=2


## Criptografía asimétrica


- La criptografía simétrica tiene un gran inconveniente: ¿cómo intercambiamos las claves de forma segura?
- La criptografía **asimétrica** se inventó en los años 70 para resolver este problema. El primer algoritmo de este tipo se llama Diffie-Hellman por el apellido de los autores. En 2015 recibieron el premio Touring, algo así como el *Nobel de informática*.
- Está basada en cálculos matemáticos que van más allá de nuesta capacidad.
- Lo importante:
  - No hay una clave sino una pareja de claves. Estas claves son números relacionados matemáticamente.
  - Si usamos una para cifrar, debemos descifrar con la otra (y viceversa)
  - Una de ellas se etiqueta como pública y la otra como privada. La pública se la podemos entregar a cualquiera y no pone en peligro nuestra seguridad. Incluso podemos publicarla en Internet
- La parte mala:
  - Los cálculos de cifrar y descifrar son más largos y necesitan más tiempo.
  - Por ese motivo, no podemos usar estas claves para cifrarlo todo
  - Además si hubiera muchos mensajes cifrados con esas claves se podría poner en peligro la seguridad del sistema.
  - Las claves se guardan en un fichero especial protegido con contraseña (es decir, cifrado simétrico).
- La parte mala:
  - Sí podemos usarla para intercambiar claves simétricas de forma segura
  - De esta manera el esquema habitual de las comunicaciones es mixto: se usan claves simétricas para cifrar la comunicación. Antes de comenzar dicha comunicación se intercambia la clave simétrica usando cifrado asimétrico.
- Vídeo: Criptografía asimétrica: https://www.youtube.com/watch?v=SIIqLgqRMCo&list=PLG1hKOHdoXkt1V51gyPMZqgQ8LjK3LfmJ&index=3


## Hash (fingerprint, huella dactilar)

### ¿Qué es un *hash*? (breve)

Un **hash** es el resultado de aplicar una función matemática (función hash) a un bloque de datos de cualquier tamaño para obtener una cadena de longitud fija. Propiedades importantes:

* determinista (mismo input → mismo hash),
* sensible a cambios pequeños (un bit distinto cambia mucho el hash),
* rápido de calcular.

No todas las funciones hash son iguales: unas están diseñadas para integridad (SHA-256) y otras para contraseñas (bcrypt, Argon2) porque las de integridad son **muy rápidas** y eso es una debilidad para contraseñas.

---

### ¿El dígito de control del DNI es un hash?

Sí —el dígito de control del DNI (la letra final) **funciona como un hash de comprobación** muy simple: se toma el número (8 dígitos) y se calcula el resto de dividirlo por 23; ese resto indexa una tabla de 23 letras (por ejemplo `TRWAGMYFPDXBNJZSQVHLCKE`). La letra resultante es el dígito de control.
Cómo garantiza validez: cualquier error en un dígito (o reordenamiento) normalmente cambia el resto y por tanto la letra, de forma que detectarás la mayoría de errores de transcripción simples. No es criptográficamente resistente (no protege contra ataques deliberados), sólo sirve para detectar errores accidentales.

---

### Ejemplos prácticos para alumnos (Ubuntu, sin programar)

> Antes de los comandos: cuando se usan en ejemplos con contraseñas reales, **no** uses contraseñas simples en entornos reales.

#### 1) Verificar que una ISO es válida (ej.: comprobando SHA-256)

1. Si el fichero de suma viene en `imagen.iso.sha256` (formato `SHA256SUM  nombre`), en la misma carpeta:

```bash
sha256sum -c imagen.iso.sha256
```

Salida esperada: `imagen.iso: OK` si la ISO es íntegra. Si no tienes el `.sha256`, puedes comparar con el hash publicado (p. ej. en la web del proveedor) calculado así:

```bash
sha256sum imagen.iso
# copia el resultado y compáralo visualmente con el publicado
```

#### 2) Comparar varios ficheros para ver si son idénticos

Opciones rápidas:

* **cmp** (compara binario, silencioso):

```bash
cmp --silent ficheroA ficheroB && echo "idénticos" || echo "diferentes"
```

* **Comprobar hashes** (útil para muchos ficheros):

```bash
sha256sum ficheroA ficheroB
# compara las cadenas de salida; si son iguales, los ficheros son idénticos
sha256sum *.txt
# compara las cadenas de salida; si son iguales, los ficheros son idénticos

```

Para una carpeta entera:

```bash
find . -type f -exec sha256sum {} + > checksums.sha256
# así se calcula un fichero con todos los hashes 
# si hacemos un hash de "checksums.sha256", tenemos un único hash de la carpeta
# luego comparar con otra carpeta o volver a calcular y diff
```

#### 3) Hashear una contraseña con SHA (ejemplo de debilidad)

Para ilustrar cómo funcionan los hash simples:

```bash
# evitar dejar salto de línea: usamos -n en echo
echo -n 'micontraseña' | sha1sum
# o con SHA-256
echo -n 'micontraseña' | sha256sum
```

**Debilidad:** SHA1/SHA256 son **muy rápidos** y **no llevan sal** (sal = valor aleatorio distinto por usuario). Eso permite ataques por fuerza bruta y uso de tablas/rainbow tables: un atacante puede probar millones de contraseñas por segundo y encontrar coincidencias si la contraseña es débil o común.

#### 4) Dónde buscar si un hash de una contraseña sencilla ya está "invertido"

Hay servicios públicos que mantienen grandes bases de datos de hashes ya rotos (para fines de recuperación o investigación): p. ej. **CrackStation** o **Hashes.com**. Su uso adecuado es educativo/forense: introducir hashes propios o con permiso.

* *CrackStation* (buscador de hashes): suele permitir pegar un hash para ver si coincide con una contraseña conocida (diccionarios y tablas precomputadas).
  (Nota: no abuses ni pegues hashes ajenos sin permiso.)

#### 5) Uso de **bcrypt** y `openssl passwd` en la consola (formas seguras)

##### Preparar herramientas

En Ubuntu:

```bash
sudo apt update
sudo apt install apache2-utils openssl
# apache2-utils proporciona htpasswd (para bcrypt -B)
```

##### Generar hash con **bcrypt** (htpasswd)

```bash
# genera la línea "usuario:$2y$..." en pantalla, sin crear fichero (-n), contraseña en línea (-b), bcrypt (-B)
htpasswd -nbB alumno 'micontraseña'
```

Salida típica:

```
alumno:$2y$10$abcdefghijklmnopqrstuvO7a1b2c3d4e5f6g7h8i9j0k
```

**Partes del hash bcrypt** (ejemplo ` $2y$10$<22char_salt><31char_hash>`):

* `$2y$` — versión/identificador de algoritmo (puede verse también `$2b$` o `$2a$`).
* `10$` — factor de coste (log2(rounds)). Aquí `10` significa 2^10 iteraciones internas. A mayor número, más lento y más seguro contra fuerza bruta.
* `22 caracteres` — **sal** codificada (salt) usada para diversificar el hash.
* `31 caracteres` — el resultado cifrado (hash).
  Formato completo: `$versión$coste$sal+hash` (60 caracteres en total en la implementación típica).

**Verificar una contraseña contra un hash bcrypt**:
Concepto: se toma la contraseña candidata, se reejecuta bcrypt usando **la misma sal y coste** que tiene el hash almacenado; si el resultado coincide con la parte hash almacenada, la contraseña es correcta. En la práctica, las bibliotecas lo hacen por ti. Con `htpasswd` puedes verificar si tienes el hash en un fichero de contraseñas:

1. Crea un fichero de contraseñas (sencillo para la prueba):

```bash
htpasswd -b -B -c passwdfile alumno micontraseña
# -c crea fichero, -b password en argumento, -B bcrypt
```

2. Verificar (comprobar) la contraseña:

```bash
# -v para verificar, -b para pasar la contraseña en la línea
htpasswd -vb passwdfile alumno micontraseña
```

`htpasswd` comprobará la contraseña comparando bcrypt (sal + hash) y devolverá éxito o fallo.

> Observación de seguridad para prácticas: en un entorno de aula evita pasar contraseñas reales en la línea de comandos (se pueden ver en el historial). Mejor usar los modos interactivos o leer desde entrada segura. Para demostración corta puede emplearse `-b` pero explicando el riesgo.


##### Generar hash con `openssl passwd` (SHA-512 crypt)

`openssl passwd` genera hashes en el formato de `crypt`. El modo `-6` produce SHA-512 crypt (más seguro que md5/crypt antiguos, pero **no** es bcrypt/Argon2). Usado para la constraseñas de linux acutalmente (/etc/shadow):

```bash
# pide la contraseña y devuelve cadena tipo $6$salt$hash
openssl passwd -6
# o en una sola línea (no recomendado en producción porque la contraseña queda en el history)
openssl passwd -6 'micontraseña'
```

Salida tipo:

```
$6$randomsalt$abcDEFghiJKL...
```

**Verificar**: para verificar una contraseña, recomputas con la misma sal:

```bash
# si conoces la sal (ejemplo 'randomsalt'):
openssl passwd -6 -salt randomsalt 'micontraseña'
# compara la salida con la cadena almacenada
```

Si usas un sistema de gestión (p. ej. PAM, /etc/shadow), el propio sistema hace la verificación automáticamente.

---

### ¿Qué te voy a pedir que hagas en la práctica de examen?

- Te voy a dar un hash y un fichero. Debes saber si el fichero es válido.
- Te voy a dar virios ficheros y debes averiguar cuál es el "falso".
- Te voy a pedir obtener el hash de una contraseña usando sha256sum, htpasswd y openssl
- Te voy a dar un hash de una contraseña y te voy a pedir que averigues si una contraseña es válida

## Cifrar y firmar

### Qué es una firma digital

Una **firma digital** permite:

* Garantizar la **autenticidad**: quién ha creado el archivo.
* Garantizar la **integridad**: el archivo no ha sido modificado.
* Garantizar el **no repudio**: quien firma no puede negar su autoría.

GPG (GNU Privacy Guard) es una herramienta gratuita que implementa **OpenPGP**, y permite:

* Cifrar y descifrar información. (ya visto)
* Firmar archivos y mensajes.
* Verificar firmas.


### Firmar un archivo

GPG ofrece **varias modalidades de firma**:

#### a) Firma normal (detached)

* Firma **separada** del archivo.

```bash
gpg --output archivo.sig --detach-sign archivo.txt
```

* Para verificar:

```bash
gpg --verify archivo.sig archivo.txt
```

> Ventaja: puedes enviar la firma y el archivo por separado.

---

#### b) Firma integrada (inline o clearsign)

* Firma **dentro del archivo**, el contenido es legible.

```bash
gpg --clearsign archivo.txt
```

* Crea `archivo.txt.asc` que contiene el texto y la firma.
* Para verificar:

```bash
gpg --verify archivo.txt.asc
```

---

#### c) Firma y cifrado al mismo tiempo

* Firma el archivo y además lo **cifra** para un destinatario.

```bash
gpg --encrypt --sign -r destinatario@example.com archivo.txt
```

* Crea `archivo.txt.gpg`
* Solo el destinatario puede descifrar y verificar la firma.

---

### Verificación de la firma

* **Detached signature**:

```bash
gpg --verify archivo.sig archivo.txt
```

* **Inline signature**:

```bash
gpg --verify archivo.txt.asc
```

GPG mostrará:

* El usuario que firmó.
* Si la firma es **válida** o **no válida**.
* Si la clave del firmante es **confiable**.

---

### Resumen de modalidades

| Modalidad        | Archivo resultante          | Ventaja                          |
| ---------------- | --------------------------- | -------------------------------- |
| Detached         | `.sig`                      | Firma separada, flexible         |
| Clearsign        | `.asc`                      | Firma legible, contenido intacto |
| Encriptada+Firma | `.gpg`                      | Seguridad y autenticidad         |

### Video interesante

- Firmar documentos con gpg: https://www.youtube.com/watch?v=9gdXvAT2q-4

## PKI, DNIe

### ¿Qué es una infraestructura PKI?

**PKI** significa **Public Key Infrastructure** o **Infraestructura de Clave Pública**. Es un sistema que permite:

* Garantizar **identidad** de personas o dispositivos.
* Asegurar que los **mensajes o documentos no han sido alterados** (integridad).
* Proteger la **confidencialidad** de la información.

Para lograr esto, PKI usa **criptografía de clave pública (asimétrica)**, es decir:

* Una **clave pública** (que se puede compartir con cualquiera).
* Una **clave privada** (que se mantiene secreta).

PKI permite asociar de forma segura **identidades reales** (personas, empresas, ....) con claves criptográficas mediante **certificados digitales** emitidos por entidades de confianza.

---

### 2. Componentes de una PKI

Una infraestructura PKI tiene varios elementos clave:

1. **Autoridad Certificadora (CA)**

   * Emite certificados digitales.
   * En el caso del DNIe, es la **Fábrica Nacional de Moneda y Timbre (FNMT)** la que actúa como CA.
   * La CA verifica la identidad antes de emitir un certificado.

2. **Autoridad de Registro (RA)**

   * Valida que quien solicita el certificado es quien dice ser.
   * Para el DNIe, cuando vas a renovar o sacar tu DNI, la policía hace de RA: comprueba tu identidad y envía la solicitud a la CA.

3. **Certificados Digitales**

   * Documento electrónico que vincula la **identidad del titular** con una **clave pública**.
   * En el DNIe, el chip contiene un certificado digital con tus datos personales y tu clave pública.

4. **Gestión de Claves**

   * Incluye generación, almacenamiento seguro y revocación de claves.
   * En el DNIe, la clave privada nunca sale del chip, y el sistema puede revocar certificados si el DNI se pierde o es robado.

5. **Listas de Revocación de Certificados (CRL) / OCSP**

   * Permiten verificar si un certificado sigue siendo válido.
   * Por ejemplo, si tu DNIe se reporta robado, su certificado se revoca y no será confiable.

---

### 3. Cómo funciona PKI en el DNIe

Veamos un ejemplo de uso práctico: **firmar un documento electrónicamente**.

1. Tú quieres firmar un PDF con tu DNIe.
2. Tu ordenador envía el documento al chip del DNIe.
3. El chip usa **tu clave privada** para crear la firma digital.

   * Tu clave privada **nunca sale del DNIe**, eso garantiza seguridad.
4. Cualquiera que reciba el documento puede usar **tu clave pública** (que está en tu certificado digital) para verificar:

   * Que la firma corresponde a ti (autenticidad).
   * Que el documento no ha sido modificado (integridad).
5. La validez del certificado se puede comprobar con la CRL u OCSP de la FNMT para asegurarse de que tu DNI no esté revocado.

---

#### 🔹 Resumen usando DNIe

| Concepto PKI            | Equivalente en DNIe                                                 |
| ----------------------- | ------------------------------------------------------------------- |
| Clave pública           | Contenida en el certificado del chip                                |
| Clave privada           | Guardada en el chip, nunca sale                                     |
| Certificado digital     | Documento electrónico que vincula tu identidad con la clave pública |
| Autoridad certificadora | FNMT                                                                |
| Autoridad de registro   | Policía que verifica tu identidad al emitir el DNIe                 |
| Revocación              | Listas de revocación de certificados si el DNI se pierde/roba       |
| Firma digital           | Documento firmado electrónicamente usando la clave privada del chip |

## Vídeos interesantes:

Repetimos los vídeos que pueden ser interesantes:

- Criptografía cifrado simétrico: https://www.youtube.com/watch?v=SlSmI18T2Ns&list=PLG1hKOHdoXkt1V51gyPMZqgQ8LjK3LfmJ&index=2
- Criptografía cifrado asimétrico: https://www.youtube.com/watch?v=SIIqLgqRMCo&list=PLG1hKOHdoXkt1V51gyPMZqgQ8LjK3LfmJ&index=3
- Qué es un hash: https://www.youtube.com/watch?v=it9suW1HN3Q&list=PLG1hKOHdoXkt1V51gyPMZqgQ8LjK3LfmJ&index=4
- Cifrado asimétrico con gpg: https://www.youtube.com/watch?v=HRK0CqrWUjI
- Firmar documentos con gpg: https://www.youtube.com/watch?v=9gdXvAT2q-4
