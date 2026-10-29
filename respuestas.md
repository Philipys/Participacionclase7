# Respuestas — Deber 3: TDD, linter y refactorización

**Estudiante:** Felipe  
**Materia:** Programación Asistida de Aplicaciones · USFQ  
**Profesor:** Jose David Vega Sánchez  

---

### 1. Rojo antes de verde
* **Mensaje de error en la Parte 2:**
  ```text
  Expected: 'La propina no puede superar el 100%'
    Actual: <null>
     Which: not an <Instance of 'String'>
  ```
* **¿Por qué era importante ver esa prueba fallar antes de escribir el código?:**  
  Porque si una prueba nunca ha fallado, no sabemos si realmente está probando algo o si daría un falso positivo. Ver el fallo en rojo demuestra que la prueba efectivamente detecta la ausencia de la regla de negocio y valida que cuando pase a verde sea gracias a nuestra implementación.

---

### 2. Linter vs. IA
* **Aviso de `flutter analyze`:** `unused_local_variable` (advertencia sobre una variable declarada sin uso) y `avoid_print` (uso indebido de `print` en código de producción).
* **Code smell señalado por la IA:** `Código duplicado` (la lógica de validación de monto, personas y propina estaba escrita dos veces: en `ejecutar` y en `ejecutarTextos`).
* **¿Por qué el linter no encontró el code smell?:**  
  Porque el linter analiza reglas sintácticas y estándares estáticos fijos (como convenciones de nombres o variables huérfanas), mientras que un code smell es un problema de diseño y arquitectura. Para las reglas del compilador y del linter, repetir una validación dos veces es código sintácticamente válido, pero para un desarrollador o una IA representa deuda técnica y violación del principio DRY.

---

### 3. Tu refactorización
* **Code smell elegido:** Código duplicado en `ValidarEntrada`.
* **¿Qué cambió en el código?:**  
  En `ValidarEntrada`, se refactorizó el método `ejecutarTextos` para que solo se encargue de convertir los textos (`String`) a tipos numéricos (`double`/`int`) y luego delegue la validación de las reglas de negocio directamente al método `ejecutar(...)`, eliminando la repetición de lógica.
* **¿Cómo sabes que la app sigue haciendo exactamente lo mismo?:**  
  Porque ejecutamos `flutter test` tras el refactor y todas las 12 pruebas (tanto las pruebas de dominio como las de la interfaz de usuario) pasaron en verde (`All tests passed!`). La suite de pruebas automatizadas sirve como red de seguridad que garantiza que no hubo regresiones.

---

### 4. Coverage
* **¿Qué archivo de `lib/` tiene el porcentaje más bajo?:**  
  `lib/main.dart` y `lib/presentation/divisor_controller.dart`, ambos empatados con un **83.3 %** de cobertura de líneas.
* **¿Significa eso que ese archivo tiene errores?:**  
  No. El porcentaje de cobertura únicamente indica qué líneas de código fueron recorridas o ejecutadas durante la ejecución de las pruebas, no si el código funciona bien o tiene errores. En `main.dart`, la función de entrada `main()` no se llama en los widget tests porque estos instancian `MyApp()` directamente. De igual manera, en `divisor_controller.dart`, el método `cambiarModo()` no fue ejecutado en las pruebas existentes. Un porcentaje menor solo refleja código no testeado, no código defectuoso.
