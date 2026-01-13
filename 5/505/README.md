# Ejercicios teórico prácticos sobre actualizaciones y parches

## 📝 Preguntas sobre actualizaciones y parches

### 🔹 Conceptos generales

1. ¿Por qué son importantes las actualizaciones y parches en un sistema operativo?
2. ¿Qué diferencia hay entre una actualización y un parche?
3. ¿Qué consecuencias puede tener no mantener un sistema actualizado?

---

### 🔹 Tipos de actualizaciones

4. Enumera y explica los tres tipos de actualizaciones que existen.
<!-- 5. ¿Qué tipo de actualización está relacionada directamente con la seguridad del sistema? -->
6. Pon un ejemplo de una actualización correctiva.
7. ¿Por qué las actualizaciones evolutivas requieren más planificación que las demás?

---

### 🔹 CVE (Common Vulnerabilities and Exposures)

7. ¿Qué es un CVE?
8. ¿Para qué sirve el identificador CVE?
9. ¿Cuál es la diferencia entre un CVE y un parche de seguridad?
10. ¿Por qué es importante que las vulnerabilidades tengan un identificador estándar?

---

### 🔹 Windows Update y WSUS

11. ¿Qué es Windows Update y qué tipo de actualizaciones gestiona?
12. ¿Qué es WSUS?
14. ¿En qué tipo de entornos se recomienda usar WSUS?
15. Explica cómo funciona WSUS de forma resumida.
16. Nombra dos ventajas de utilizar WSUS frente a Windows Update directo.
17. ¿Qué relación tiene WSUS con el patching escalonado?

---

### 🔹 Linux y gestores de paquetes

17. ¿Qué es un gestor de paquetes en Linux?
19. Nombra dos gestores de paquetes y las distribuciones que los utilizan.
20. ¿Qué son los repositorios en Linux y por qué se consideran seguros?
21. ¿Qué función tienen las firmas GPG en los repositorios?

---

### 🔹 apt update y apt upgrade

21. ¿Qué hace exactamente el comando `apt update`?
23. ¿Qué hace el comando `apt upgrade`?
24. ¿Por qué es necesario ejecutar `apt update` antes de `apt upgrade`?
25. ¿Qué tipo de actualizaciones se instalan normalmente con `apt upgrade`?

---

### 🔹 Actualización de versión en Linux

25. ¿Qué diferencia hay entre actualizar paquetes y actualizar la versión del sistema?
27. ¿Qué comando se utiliza habitualmente para actualizar de versión en Ubuntu?
28. ¿Qué precauciones deben tomarse antes de actualizar de versión un sistema Linux?
29. ¿Por qué no se recomienda actualizar de versión en sistemas críticos sin pruebas previas?

---

### 🔹 Riesgos y estrategias

29. Enumera al menos tres riesgos de no aplicar actualizaciones.
31. ¿Qué es el patching escalonado y qué ventaja ofrece?
32. ¿Qué es una ventana de mantenimiento?
33. ¿Por qué es importante informar a los usuarios de una ventana de mantenimiento?

---

### 🔹 Preguntas de reflexión / aplicación

33. ¿Qué tipo de actualización aplicarías con mayor urgencia y por qué?
35. ¿Qué sistema ofrece más control sobre las actualizaciones en una red: Windows Update o WSUS? Justifica la respuesta.
36. ¿Por qué crees que muchas brechas de seguridad se deben a sistemas desactualizados?
37. En un centro educativo con muchos equipos, ¿qué solución elegirías para gestionar las actualizaciones de Windows? Explica tu elección.

## **Ejercicio práctico 1: Windows 11**

**Objetivo:** Familiarizarse con Windows Update y WSUS (si estuviera disponible), identificar actualizaciones de seguridad y entender los parches y CVE.

### **Instrucciones paso a paso:**

1. **Abrir Windows Update**

   * `Inicio → Configuración → Actualización y seguridad → Windows Update`.

2. **Buscar actualizaciones**

   * Haz clic en **Buscar actualizaciones**.
   * Observa la lista de actualizaciones disponibles.
   * Identifica cuáles son **actualizaciones de seguridad**.

3. **Registrar información de un parche de seguridad**

   * Haz clic en **Detalles de la actualización**.
   * Anota:

     * Nombre de la actualización
     * Fecha
     * Identificador CVE (si aparece, intenta encontrar una que sí aparezca)

4. **Opcional: Comprobar WSUS (si está configurado)**

   * Ejecuta `winver` para ver la versión de Windows.
   * Abre `gpedit.msc → Configuración del equipo → Plantillas administrativas → Windows Update → Especificar ubicación de servicio de actualización de intranet de Microsoft`.
   * Observa si tu máquina está configurada para actualizar desde WSUS.

5. **Reflexión final**

   * Anota la diferencia entre **actualización automática** y **actualización gestionada por WSUS**.
   * ¿Qué tipo de actualización (seguridad, correctiva, evolutiva) has identificado en la lista?

---

**Resultado esperado:**

* Comprender qué es un parche, un CVE y cómo Windows 11 maneja las actualizaciones.
* Diferenciar actualizaciones de seguridad y otras actualizaciones.

---

## **Ejercicio práctico 2: Ubuntu / Linux**

**Objetivo:** Gestionar actualizaciones usando `apt`, diferenciar entre `update` y `upgrade`, y practicar actualización de versión.

### **Instrucciones paso a paso:**

1. **Actualizar la lista de paquetes**

   ```bash
   sudo apt update
   ```

   * Observa los paquetes que tienen nuevas versiones disponibles.

2. **Aplicar actualizaciones de paquetes instalados**

   ```bash
   sudo apt upgrade
   ```

   * Confirma las actualizaciones que se instalarán.
   * Observa cuáles son actualizaciones de seguridad y cuáles son mejoras menores.

3. **Comprobar la versión actual de Ubuntu**

   ```bash
   lsb_release -a
   ```

   * Anota la versión instalada.

4. **Simular actualización de versión (sin instalar realmente)**

   ```bash
   sudo do-release-upgrade -c
   ```

   * Comprueba si hay una nueva versión disponible y qué cambios incluiría.
   * No hace falta actualizar realmente, solo observar.

5. **Reflexión final**

   * Diferencia entre `apt update` y `apt upgrade`.
   * Riesgos de actualizar la versión completa del sistema.
   * Qué precauciones tomar antes de un upgrade completo.
