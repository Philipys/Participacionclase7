# Implementation Plan: Divisor de Cuenta de Restaurante

**Branch**: `001-divisor-cuenta` | **Date**: 2026-10-01 | **Spec**: [spec.md](./spec.md)

## 1. Arquitectura y Tecnologías
- **Framework & SDK**: Flutter con Dart SDK estable, null safety estricto.
- **Dependencias**: Sin paquetes externos (cero librerías de terceros).
- **Gestión de Estado**: Estado local con `StatefulWidget` / `setState` adecuado para una sola pantalla sin sobreingeniería.
- **Punto de Composición**: `lib/main.dart` es el único lugar donde se crean las instancias concretas y se inyectan al controlador.

---

## 2. Estructura de Capas y Componentes (SOLID)

### Capa Domain (`lib/domain/`) - Dart Puro (Sin imports de Flutter)
- **`cuenta.dart`**: Entidad inmutable que representa la cuenta (`monto`, `personas`, `porcentajePropina`).
- **`resultado.dart`**: Entidad o Value Object con el resultado (`montoPorPersona`, `totalConPropina`).
- **`estrategia_redondeo.dart`**: Interfaz abstracta con un único método (`double redondear(double valor);`). Cumple ISP.
- **`validar_entrada.dart`**: Caso de uso que valida cadenas de texto ingresadas. Devuelve mensaje de error si el monto no es numérico ("Monto inválido") o si personas es <= 0 ("Debe haber al menos una persona"). Cumple SRP.
- **`calcular_division.dart`**: Caso de uso que realiza la operación aritmética `(monto + propina) / personas` y aplica la `EstrategiaRedondeo` inyectada. No formatea ni valida. Cumple SRP, OCP y LSP.

### Capa Data (`lib/data/`)
- **`redondeo_exacto.dart`**: Implementa `EstrategiaRedondeo` retornando el valor tal cual.
- **`redondeo_hacia_arriba.dart`**: Implementa `EstrategiaRedondeo` aplicando `.ceilToDouble()`.

### Capa Presentation (`lib/presentation/`)
- **`divisor_controller.dart`**: Recibe por constructor sus dependencias (`ValidarEntrada`, `CalcularDivision`, estrategias). Maneja el flujo y el estado de la UI. Cumple DIP.
- **`formateador_moneda.dart`**: Responsabilidad única de dar formato de dos decimales a los números (`toStringAsFixed(2)`). Cumple SRP.
- **`pantalla_divisor.dart`**: Widget de la pantalla con campos de texto, selector de modo de redondeo y botón "Calcular". Cumple SRP (solo renderizado visual y delegación de eventos al controlador).

---

## 3. Verificación de Cumplimiento Constitucional
- **SRP**: Separación total entre validación (`validar_entrada`), cálculo (`calcular_division`), formateo (`formateador_moneda`) y UI (`pantalla_divisor`).
- **OCP/LSP**: Nueva regla de redondeo sólo requiere crear una clase en `data/` que implemente `EstrategiaRedondeo`, sin tocar `calcular_division.dart`.
- **DIP**: `presentation` y `domain` no conocen detalles de `data`. `main.dart` ensambla todo.
- **Pureza**: `lib/domain/` no contiene ninguna referencia a `package:flutter`.
