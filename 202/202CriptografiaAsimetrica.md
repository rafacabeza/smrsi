# Ejercicios sobre cifrado asimétrico

Crea un documento Word y pega este guión
Escribe lo que consideres y pega las capturas de pantalla que muestren tu trabajo. Cuida las formas y explica lo que sea necesario.

## Objetivo.

Vamos a usar nuestra máquina ubuntu para cifrar mediante criptografía asimétrica. 

## Guión

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

1.  Cambia de usuario y repite el proceso de creación para el usuario 2.

### Parte 2. Intercambio de claves