# Ejercicios sobre cifrado asimétrico

Crea un documento Word y pega este guión
Escribe lo que consideres y pega las capturas de pantalla que muestren tu trabajo. Cuida las formas y explica lo que sea necesario.

## Objetivo.

Vamos a usar nuestra máquina ubuntu para cifrar mediante criptografía asimétrica. 

## Guión

### Parte 0. Renombrar equipo

1. Vamos a renombrar nuestro equipo ubuntu con nuestro apellido. Hay varias maneras de hacerlo, pero la más rápida sería:

```bash
sudo hostnamectl set-hostname nuevonombre
exec bash
```

### Parte 1. Creación de claves

1. Crea dos usuarios nuevos en Ubuntu. Llámales apellido1 y apellido2, cambia apellido por el tuyo propio:

```bash
sudo useradd -m -s /bin/bash nombre_usuario
```

2. Generamos un par de claves simétricas.

```bash
cabeza1@cabeza:~$ gpg --full-gen-key 
cabeza1@cabeza:~$ gpg --gen-key //no pregunta opciones
```

> NOTA
> Si el usuario de consola no coincide con el usuario de la sesión gráfica debemos modificar el comando para que la clave la pida por consola:
> gpg --pinentry-mode loopback --full-generate-key

3. Nos preguntará, qué claves (y algoritmos queremos). Usaremos la opción 2. Son un juego de claves DSA para firmar y otro juego de claves Elgamal para cifrar. También preguntará por tamaño de la clave y tiempo de  validez. Tomaremos las opciones por defecto (2048 y nunca caduca).

4. Después nos piden nuestro nombre y cuenta de correo. Debemos **usar datos reales** si queremos publicar las claves en internet asociadas a nuestro email.

5. Las claves se guardan en un fichero cifrado mediante criptografía simétrica. Nos pedirá una cotraseña para el cifrado.
6. El cifrado usa bytes aleatorios de la memoria del sistema por lo que puede tardar. Usar el navegador ayuda a hacerlo. No obstante en pocos instantes tendremos la clave creada.
7. Podemos consultar las claves existentes:

```bash
cabeza1@cabeza:~$ gpg --list-key 
```

8. Comprueba que se ha creado un directorio .gnupg con los ficheros de claves entre otros.

```bash
cabeza1@cabeza:~$ ls ~/.gnupg -la
```

> Deberías encontrar al menos:
> **pubring.kbx** fichero con todas las claves públicas, propias y de terceros
> **trustdb.gpg** base de datos de confianza. Son las claves de las que me puedo fiar.
> **private-keys-v1.d/** Directorio con las claves privadas cifradas.

9.  Cambia de usuario y repite el proceso de creación para el usuario 2.

### Parte 2. Intercambio de claves

1. Ahora vamos a exportar la clave de uno de los usuarios:

```bash
cabeza1@cabeza:~$ gpg -a --export -o /tmp/apellido1.pub cabeza1
```

2. Vamos a una consola del segundo usuario y la vamos a importar:


```bash
cabeza2@cabeza:~$ gpg --import /tmp/alumno.pub
```

3. Podemos verficar la clave importada con "--list-key"
4. Conviene firmar la clave para que no nos pregunte después si es válida. Si no lo hacemos, más adelante nos pedirá verificar el fingerprint de la clave:

```bash
gpg --sign-key "cabeza2"
```

## Parte 4. Cifrado/descifrado

5. Para cifrar el fichero (en el ejemplo mensaje):

```bash
gpg -v -a -o /tmp/mensaje.cifrado --encrypt --recipient  rafacabeza@iessantiagohernandez.com  mensaje
```


6. Por seguridad nos *gpg* nos dice que validemos como segura la clave del pública del otro usuario. Podemos comprobar el *fingerprint* abriendo una consola del usuarioX y ejecutando:

```bash
gpg --list-secret-keys --with-subkey-fingerprints
```

5. Tras aceptar 

### Parte N. Borrar claves

- Recordamos que podemos ver nuestras claves (públicas y privadas) así:

```bash
cabeza1@cabeza:~$ gpg --list-keys
cabeza1@cabeza:~$ gpg --list-secret-keys
```

- Podemos borrar una clave usando el id (hash) o el email del usuario:

```bash
cabeza1@cabeza:~$ gpg --delete-secret-keys ID_CLAVE
cabeza1@cabeza:~$ gpg --delete-keys ID_CLAVE
#Por ejemplo
cabeza1@cabeza:~$ gpg --delete-secret-keys cabeza@example.com
cabeza1@cabeza:~$ gpg --delete-keys cabeza@example.com
#No se puede borrar la clave pública sin haber borrado antes la privada
```
