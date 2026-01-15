# 506 Ejercicios Antivirus

## Resuelve las siguientes preguntas a partir de los apuntes

1. ¿Qué es un antivirus y cuál es su función principal?
2. ¿Qué se entiende por malware?
3. Explica qué es la detección por firmas.
4. ¿Por qué la detección por firmas no es suficiente hoy en día?
5. ¿En qué consiste la detección heurística?
6. ¿Qué es la detección basada en comportamiento?
7. Nombra y explica brevemente tres tipos de malware.
8. ¿Qué es el ransomware y por qué es especialmente peligroso?
9. ¿Qué limitaciones tienen los antivirus?
10. ¿Qué es VirusTotal y para qué se utiliza?
11. ¿Por qué no se deben subir archivos sensibles a VirusTotal?
12. ¿Por qué en Linux de escritorio rara vez se usa antivirus?
13. ¿En qué casos sí tiene sentido usar antimalware en Linux?
14. ¿Qué características hacen que Windows Defender sea suficiente en Windows 11?
15. ¿Qué es Google Play Protect?
16. ¿Qué tipo de amenazas puede detectar Play Protect?
17. ¿Por qué la ingeniería social supone un problema para los antivirus?
18. ¿Qué papel juega el usuario en la seguridad de un sistema?
19. Explica por qué un antivirus no garantiza la seguridad total.
20. Justifica la afirmación: “la seguridad no depende solo del antivirus, sino también del comportamiento del usuario”.

---

## Ejercicios prácticos

### Windows

**Ejercicio 1: Antivirus integrado**

1. Abrir *Seguridad de Windows*.
2. Localizar *Protección contra virus y amenazas*.
3. Comprobar:

   * Estado del antivirus.
   * Fecha de actualización.
4. Ejecutar un análisis rápido.

📌 Pregunta:

> ¿Qué tipos de análisis ofrece Windows Defender? Haz captura de las distintas opciones.

---

**Ejercicio 2: VirusTotal**

1. Descargar un archivo de prueba (EICAR).
2. Subirlo a VirusTotal.
3. Analizar el resultado.

📌 Pregunta:

> ¿Todos los motores detectan el archivo como malware?

---

### 🐧 Linux (Ubuntu)

**Ejercicio 3: Instalación de ClamAV**

```bash
sudo apt update
sudo apt install clamav clamav-daemon
```

**Ejercicio 4: Análisis de una carpeta**

```bash
clamscan -r ~/Descargas
```

📌 Pregunta:

> ¿Detecta algo? ¿Qué mensajes aparecen?

---

### 🤖 Android

**Ejercicio 5: Permisos de aplicaciones**

1. Abrir *Ajustes → Privacidad → Gestor de permisos*.
2. Revisar:

   * Apps con acceso a cámara.
   * Apps con acceso a ubicación.
3. Identificar una app con permisos excesivos.

📌 Pregunta:

> ¿Tiene sentido que esa app tenga esos permisos?

---

**Ejercicio 6: Google Play Protect**

1. Abrir Google Play.
2. Acceder a *Play Protect*.
3. Ejecutar un análisis.

📌 Pregunta:

> ¿Qué tipo de amenazas puede detectar?