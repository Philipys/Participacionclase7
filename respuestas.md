# Respuestas y Análisis Comparativo: Vibe Coding vs. SDD con GitHub Spec Kit

**Estudiante:** Felipe  
**Materia:** Programación Asistida de Aplicaciones · USFQ  
**Profesor:** Jose David Vega Sánchez  
**Proyecto:** Divisor de Cuenta (`divisor_cuenta`)  

---

## 1. Tabla de Métricas Comparativas y Evaluación General

### Metadatos del Entorno
- **Agente de código:** Antigravity IDE (integración oficial `agy` / Gemini CLI).
- **Modelo LLM:** Gemini 3.8 Flash.
- **Nivel de razonamiento:** Default / Balanced (configuración estándar del agente).
- **Archivo de instrucciones:** `GEMINI.md` en la raíz del proyecto.
- **Caso de Git (Parte 1.5):** **Caso C**. Al ejecutar `git rev-parse --show-toplevel`, se detectó que la carpeta superior general `ClaseApps2026` ya constituía un repositorio Git previo. Siguiendo la recomendación explícita de la guía metodológica para evitar la contaminación cruzada de ramas en proyectos de otras semanas, se inicializó un repositorio Git independiente (`git init`) dentro del proyecto `divisor_cuenta`.

### Tabla de Métricas

| Métrica | rama vibe | rama sdd |
|---|:---:|:---:|
| **Iteraciones** (veces que se tuvo que volver a pedir algo) | **1** | **0** |
| **Casos de aceptación que cumple (0–6)** | **6** | **6** |
| **Pruebas automatizadas que pasan** | **0** (no compilan en dominio) | **10** (7 dominio/LSP + 3 widget) |
| **Archivos en `lib/`** | **1** | **11** |
| **Líneas de código en `lib/`** | **183** | **355** |
| **¿`domain/` depende de Flutter?** | *No existe capa domain* | **No** (Dart puro, 0 dependencias) |
| **¿Existe separación `presentation/domain/data`?** | **No** (Monolito en `main.dart`) | **Sí** (3 capas estrictas) |
| **¿El agente agregó algo que nadie pidió?** | **Sí** (`Slider` interactivo, iconos) | **No** (Ceñido a la spec) |
| **¿Se puede agregar otra estrategia sin modificar el cálculo existente?** | **No** (Requiere modificar `if/else`) | **Sí** (OCP y LSP garantizados) |

#### Métrica Secundaria (Opcional)
| Métrica secundaria | rama vibe | rama sdd |
|---|:---:|:---:|
| Tiempo aproximado hasta cumplir los 6 escenarios | ~6 minutos | ~12 minutos |

### Análisis de Cumplimiento y Decisiones
- **¿Qué enfoque cumplió mejor los escenarios?:** 
  Aunque ambos terminaron cumpliendo visualmente los 6 escenarios en la interfaz gráfica, **la rama `sdd` cumplió de forma significativamente superior** porque los criterios de aceptación quedaron garantizados mediante pruebas automatizadas verificables desde la primera ejecución. En `vibe`, el agente requirió una iteración correctiva porque inicialmente asumió comportamientos arbitrarios (mensajes genéricos de error y falta del selector de redondeo).
- **Iteraciones requeridas:**
  - `vibe`: **1 iteración** (tras el prompt inicial, se tuvo que solicitar explícitamente agregar el modo de redondeo hacia arriba y corregir los textos exactos de validación `"Debe haber al menos una persona"` y `"Monto inválido"`).
  - `sdd`: **0 iteraciones** de corrección en código. El agente implementó directamente las 10 tareas guiado por la `Constitution`, la `Spec` y el `Plan`.
- **Decisiones explícitas vs. completadas por el agente:**
  - En `sdd`, todas las decisiones críticas (redondeo por estrategia, desacoplamiento de framework, validación sin formateo, mensajes exactos y política de propina por defecto) quedaron **explícitas y congeladas** en los artefactos antes de redactar una sola línea de código.
  - En `vibe`, el agente tuvo que "adivinar" e inferir decisiones arquitectónicas y de negocio sobre la marcha, recurriendo a lo más simple (acoplar el cálculo aritmético directamente dentro del método `setState()` de un `StatefulWidget`).
- **Por qué el tiempo no basta como criterio de calidad:**
  La rama `vibe` tomó menos tiempo inicial (~6 min vs ~12 min), pero generó **deuda técnica inmediata**: cero modularidad, imposibilidad de pruebas automatizadas aisladas y violación directa de principios de extensibilidad. En proyectos reales, el tiempo ahorrado al inicio se pierde exponencialmente durante el mantenimiento o al agregar nuevas funciones.

---

## 2. Experimento Cruzado: Pruebas de `sdd` en la Rama `vibe` (Parte 10)

Al ejecutar en la rama `vibe` los comandos:
```bash
git checkout vibe
git checkout sdd -- test/
flutter test
```

### ¿Compilaron las pruebas?
**No, las pruebas de dominio (`test/division_test.dart`) fallaron en tiempo de compilación.**

### Primer error de compilación registrado:
```text
Compilation failed for testPath=C:/.../divisor_cuenta/test/division_test.dart: 
test/division_test.dart:2:8: Error: Error when reading 'lib/domain/calcular_division.dart': 
El sistema no puede encontrar la ruta especificada
import 'package:divisor_cuenta/domain/calcular_division.dart';
       ^
test/division_test.dart:28:17: Error: 'EstrategiaRedondeo' isn't a type.
```

### ¿Fallo funcional o diferencia de arquitectura y testabilidad?
Este fallo **demuestra una profunda diferencia de arquitectura y testabilidad, no un fallo funcional**.
La aplicación de la rama `vibe` funciona a nivel de interfaz de usuario cuando un humano interactúa con ella, pero su lógica de negocio está atrapada dentro de clases privadas de la interfaz gráfica (`_DivisorCuentaPageState`). Al carecer de contratos (`EstrategiaRedondeo`), entidades (`Cuenta`) y casos de uso (`CalcularDivision`, `ValidarEntrada`), es imposible aislar la lógica para verificarla sin montar el árbol completo de widgets de Flutter.

### Comparación de Ejecución Manual de los 6 Escenarios:
Al ejecutar manualmente la interfaz en ambas ramas:
1. **100.00, 4 personas, 10% propina, exacto:** Ambos muestran `27.50`.
2. **90.00, 3 personas, 0% propina, exacto:** Ambos muestran `30.00`.
3. **50.00, 0 personas:** Ambos muestran `"Debe haber al menos una persona"` y ocultan el resultado.
4. **Monto "abc":** Ambos muestran `"Monto inválido"`.
5. **10.00, 3 personas, 0%, exacto:** Ambos muestran `3.33`.
6. **10.00, 3 personas, 0%, hacia arriba:** Ambos muestran `4.00`.

**Conclusión:** El comportamiento de caja negra es equivalente, pero el costo de verificación es abismal: en `sdd` toma 1 segundo vía `flutter test`, mientras que en `vibe` requiere un operador humano clickeando manualmente la pantalla en cada cambio.

---

## 3. Demostración Comprobable de SOLID con Comandos `grep` (Parte 9.5)

### Comando 1: DIP + Capas (El dominio no depende de Flutter)
```bash
git grep -rn "package:flutter" lib/domain/
```
- **Rama `sdd`:** Salida vacía (0 ocurrencias). `lib/domain/` es Dart puro y desacoplado del motor gráfico.
- **Rama `vibe`:** No pasa. Ni siquiera existe la carpeta `domain/`. Todo el código está en `lib/main.dart` e importa `package:flutter/material.dart`.
- **Regla explicativa en la Constitution:**
  > *"lib/domain/ no importa package:flutter (es Dart puro). presentation -> domain <- data."*

### Comando 2: DIP (Punto único de instanciación concreta)
```bash
git grep -rn -E "RedondeoExacto\(\)|RedondeoHaciaArriba\(\)" lib/
```
- **Rama `sdd`:**
  ```text
  lib/main.dart:21:      'exacto': const RedondeoExacto(),
  lib/main.dart:22:      'arriba': const RedondeoHaciaArriba(),
  ```
  Aparece **exclusivamente** en `lib/main.dart`, que actúa como Composition Root.
- **Rama `vibe`:** No pasa. No existen clases de redondeo; la lógica está hardcodeada dentro de un método `setState`.
- **Regla explicativa en la Constitution:**
  > *"main.dart es el ÚNICO lugar donde se instancian implementaciones concretas."*

### Comando 3: OCP y LSP (Cálculo sin bifurcaciones por tipo)
```bash
git grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart
```
- **Rama `sdd`:** Salida vacía (0 ocurrencias). `CalcularDivision` recibe `EstrategiaRedondeo` y llama polimórficamente a `estrategia.redondear(...)` sin validar el tipo concreto.
- **Rama `vibe`:** No pasa. En `lib/main.dart` existe la bifurcación condicional:
  ```dart
  if (_modoRedondeo == 'arriba') {
    porPersona = porPersona.ceilToDouble();
  }
  ```
  Para agregar una tercera estrategia (ej. redondeo bancario), `vibe` obliga a modificar el código existente rompiendo OCP.
- **Regla explicativa en la Constitution:**
  > *"OCP: agregar una nueva regla de redondeo no obliga a editar las clases que ya existen. LSP: cualquier implementación de una interfaz puede sustituir a otra sin que quien la usa tenga que preguntar de qué tipo es."*

### Comando 4: SRP (El caso de uso no formatea ni valida)
```bash
git grep -n -E "toStringAsFixed|inválido|al menos una persona" lib/domain/calcular_division.dart
```
- **Rama `sdd`:** Salida vacía (0 ocurrencias). La validación reside únicamente en `ValidarEntrada` y el formateo textual en `FormateadorMoneda`.
- **Rama `vibe`:** No pasa. El método `_calcular` en `lib/main.dart` valida los textos, efectúa la división, aplica el redondeo, compone los strings de error y ejecuta `toStringAsFixed(2)`, concentrando cuatro responsabilidades disímiles en una sola función.
- **Regla explicativa en la Constitution:**
  > *"SRP: una clase, una razón de cambio. El cálculo no valida ni formatea."*

---

## 4. Preguntas y Ambigüedades de `/speckit-clarify` (Parte 6.2)

Durante la ejecución del skill de clarificación, se destaparon dos ambigüedades centrales:

1. **Pregunta 1:** *¿Qué valor debe considerarse si el usuario deja el campo de porcentaje de propina completamente vacío al presionar "Calcular"?*
   - **Ambigüedad destapada:** La especificación inicial indicaba ingresar propina, pero no definía si la propina era obligatoria o si existía un valor por defecto.
   - **Resolución en SDD:** Se definió que un campo vacío se interpreta automáticamente como `0%` de propina, evitando bloquear el cálculo.
   - **¿Quién decidió en Vibe?:** El agente por su cuenta decidió colocar un `Slider` inicializado arbitrariamente en `10%`, forzando al usuario a tener una propina precargada.

2. **Pregunta 2:** *¿Cómo debe representarse el resultado cuando el cálculo da un número entero exacto (por ejemplo 30 o 4)?*
   - **Ambigüedad destapada:** En Dart, `30.0 / 1` se imprime como `30.0`, pero los criterios de aceptación exigían `"30.00"` y `"4.00"` (dos decimales fijos de moneda).
   - **Resolución en SDD:** Se acordó formalmente en el artefacto que todo resultado numérico debe presentarse formateado con exactamente dos cifras decimales.
   - **¿Quién decidió en Vibe?:** El agente lo omitió en la primera versión y sólo lo implementó cuando se le exigió en la iteración posterior.

---

## 5. Análisis de `git diff vibe sdd --stat` (Parte 11)

### Salida del comando:
```text
49 files changed, 5463 insertions(+), 193 deletions(-)
```

### Hallazgos principales:
1. **Artefactos del proceso SDD:**
   La gran mayoría de inserciones corresponden a la infraestructura metodológica: la carpeta `.specify/` (plantillas, scripts de automatización en PowerShell y la memoria constitucional) y la especificación viva en `specs/001-divisor-cuenta/` (`spec.md`, `plan.md`, `tasks.md`).
2. **Estructura modular vs. monolito en `lib/`:**
   - En `vibe`, `lib/main.dart` creció a 183 líneas concentrando toda la aplicación en un solo archivo.
   - En `sdd`, `lib/` contiene 11 archivos especializados organizados en `domain/`, `data/` y `presentation/` totalizando 355 líneas.
3. **¿Alguna rama agregó cosas que nadie pidió?:**
   - **En `vibe`:** El agente introdujo un `Slider` interactivo de propina con divisiones predefinidas y un icono `Icons.people` en los campos, elementos que no formaban parte de la solicitud mínima.
   - **En `sdd`:** El agente no inventó funcionalidades visuales ni dependencias ajenas; cada archivo responde exactamente a una de las tareas numeradas (`T001` a `T010`) pactadas en el plan de descomposición.

---

## 6. Ecosistema SDD y Cuándo Elegir Vibe Coding

### Herramienta Alternativa: OpenSpec
- **¿Qué es?:** Es una herramienta y estándar abierto de *Spec-Driven Development* diseñado para definir especificaciones de software neutrales respecto al proveedor de inteligencia artificial.
- **Diferencia con Spec Kit:**
  - Mientras que **GitHub Spec Kit** está fuertemente enfocado en el flujo de trabajo interactivo por comandos/skills dentro del entorno de desarrollo (con hooks para Claude, Copilot, Antigravity, etc.) y plantillas en Markdown, **OpenSpec** prioriza esquemas formales y estructurados (JSON Schema / YAML) con validación estricta de contratos de API y tipos de datos.
- **¿Cuándo preferirla?:** Se prefiere en arquitecturas empresariales políglotas o basadas en microservicios, donde equipos multidisciplinarios o múltiples agentes diferentes necesitan consumir la misma especificación formal sin estar atados a una herramienta de orquestación específica.

### Situación Real y Pequeña donde es Razonable elegir Vibe Coding
El uso de **Vibe Coding** es completamente razonable y ventajoso en:
> **Creación de prototipos visuales descartables ("Throwaway Prototypes") o pruebas de concepto (PoC) durante una sesión de ideación o hackatón de pocas horas.**

Por ejemplo, si un diseñador o cliente desea visualizar en 30 minutos cómo lucirían los colores, tipografía y distribución general de una pantalla en un teléfono móvil para validar una idea de negocio antes de aprobar un presupuesto, utilizar SDD generaría una fricción burocrática innecesaria. En ese escenario no importa la testabilidad, la arquitectura limpia ni los principios SOLID, ya que el código será descartado una vez validada la hipótesis visual.

---

## Resumen de Verificación Previa a la Entrega

- [x] Ramas presentes en el repositorio: `main`, `vibe`, `sdd`.
- [x] Mismo commit inicial base verificado con `git log --oneline --all`.
- [x] Mismo agente (`Antigravity IDE`) y modelo (`Gemini 3.8 Flash`) en ambas ramas.
- [x] `GEMINI.md` y `.specify/` versionados en `sdd`.
- [x] Constitución con los 5 principios SOLID comprobables en `.specify/memory/constitution.md`.
- [x] `specs/001-divisor-cuenta/` con `spec.md`, `plan.md` y `tasks.md`.
- [x] Pruebas unitarias de dominio (`division_test.dart`) y de widget (`pantalla_test.dart`) en verde (`flutter test`: 10/10).
- [x] `flutter analyze` finalizado con `No issues found!`.
- [x] `flutter build apk --debug` compilado exitosamente (`app-debug.apk`).
- [x] Verificaciones con `git grep` para SOLID pasadas limpiamente en `sdd`.
- [x] `respuestas.md` registrado en la rama `main`.
