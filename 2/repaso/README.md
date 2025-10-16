# Repaso de criptografía

- Vamos a usar el despliegue RepasoCriptografia (Ubuntu)
- Es una colección de ejercicios par repasar el tema de criptografía
- Los ejercicios usados en la práctica de examen serán semejantes en dificultad pero pueden ser diferentes.

## Preparación

1. Crear 2 usuarios llamados "pepe" y "julia". Debe tener carpeta home y usar "bash".

## Cifrado simétrico (2puntos)

1. Abre sesión como "pepe". Crea un ficheros de texto plano llamado "nombre.txt" con tu nombre y apellidos.
3. Cifra el fichero usando criptografía simétrica. No especifiques el algoritmo. El fichero resultado compartelo con "julia" (usa /tmp)
4. Abre sesión como "julia". Desencripta el fichero y muestra el contenido del mismo.

## Cifrado asimétrico

### Creación e intercambio de claves (2puntos)

1. Crea un juego de claves asimétricas (DSA Elgamal) para "pepe" y otro para "julia".
2. Intercambia las claves públcias entre ambos.
3. Firma las claves intercambiadas:
   1. Comprueba que el fingerprint de las claves recibidas (las públicas) coincide con la original.
   2. Firma la clave recibida (gpg --sign-key)
4. Muestra el contenido de las claves en cada usuario.

### Cifrado asimétrico (2 puntos)

1. Abre sesión como "pepe"
2. Crea un fichero de texto llamado "datos.txt" que debe contener tu nombre y dirección (puedes inventarla).
3. Cifra el fichero usando **criptografía asimétrica** y compártelo con el usuario "julia".
4. Julia debe desencriptar el fichero recibido y mostrar el contenido del mismo.
5. ¿Qué clave se ha usado para encriptar el fichero?

### Firma (2 puntos)

1. Abre sesión con el usuario "pepe".
2. Firma el fichero datos.txt usando firma separada (dettached)
3. ¿Qué clave usas para firmar?
4. Firma y encripta el fichero datos.txt
5. ¿Qué claves se usan para firmar y encriptar?
6. Comparte los ficharos con "julia".
7. Abre sesión como julia y comprueba las firmas de los pasos anteriores.

### Hash 

1. En la carpeta del ejercicio hay 3 ficheros (texto1, texto2, texto3). Dos son iguales y son buenos pero hay uno modificado. Identifica cuál es el *malo* usando "sha256" y "md5"
2. He interceptado el hash de una contraseña. Averigua cuál es la contraseña real.

> Hash:
> 23cdc18507b52418db7740cbb5543e54
