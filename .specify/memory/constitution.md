# Divisor de Cuenta Constitution

## Core Principles

### I. CALIDAD DE CÓDIGO (SOLID)
El código debe respetar estrictamente los principios SOLID:
- **SRP (Single Responsibility Principle):** Una clase, una razón de cambio. El cálculo no valida ni formatea.
- **OCP (Open/Closed Principle):** Agregar una nueva regla de redondeo no obliga a editar las clases que ya existen.
- **LSP (Liskov Substitution Principle):** Cualquier implementación de una interfaz puede sustituir a otra sin que quien la usa tenga que preguntar de qué tipo es (sin `is` ni `as`).
- **ISP (Interface Segregation Principle):** Interfaces pequeñas; nadie depende de métodos que no usa (interfaz con un solo método para redondeo).
- **DIP (Dependency Inversion Principle):** `presentation` depende de abstracciones de `domain`, nunca de clases concretas de `data`.

### II. ARQUITECTURA LIMPIA Y CAPAS
- **Capas:** Separación explícita en `lib/presentation`, `lib/domain` y `lib/data`.
- **Regla de dependencia:** `presentation -> domain <- data`.
- **Pureza de dominio:** `lib/domain/` NO importa nada de `package:flutter` (es Dart puro).
- **Punto único de composición:** `lib/main.dart` es el ÚNICO lugar donde se instancian implementaciones concretas (`RedondeoExacto()`, `RedondeoHaciaArriba()`).

### III. SEGURIDAD
- Nunca guardar secretos ni API keys en el repositorio.

### IV. CALIDAD Y PRUEBAS
- Toda funcionalidad crítica tiene pruebas automatizadas.
- Los criterios de aceptación de cada spec se convierten en pruebas ejecutables verificables.

### V. REGLA DE LA MATERIA
- Toda función generada por el agente debe poder explicarla el estudiante: qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.

## Governance
La Constitución es la ley suprema del proyecto y prevalece sobre cualquier sugerencia o atajo de código. Cualquier violación a SOLID o a la separación de capas invalidará la solución.

**Version**: 1.0.0 | **Ratified**: 2026-10-01
