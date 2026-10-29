# Feature Specification: Divisor de Cuenta de Restaurante

**Feature Branch**: `001-divisor-cuenta`  
**Created**: 2026-10-01  
**Status**: Clarified & Approved  
**Input**: Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas.

## Resumen Ejecutivo
Aplicación Flutter de una sola pantalla que permite a los comensales calcular de forma offline la cuota exacta que cada persona debe pagar, considerando monto total, número de personas, porcentaje de propina y una estrategia de redondeo configurable (exacto o hacia arriba al entero más cercano).

---

## User Scenarios & Testing

### User Story 1 - Cálculo de división estándar (Prioridad: P1)
Como comensal, quiero ingresar el monto, número de comensales y propina para ver rápidamente cuánto le corresponde pagar a cada persona con dos decimales.

**Criterios de Aceptación:**
- **Escenario 1 (Reparto normal con propina):**
  - Dado monto = 100.00, personas = 4, propina = 10%, modo = exacto.
  - Cuando se presiona "Calcular".
  - Entonces el resultado mostrado por persona es 27.50.
- **Escenario 2 (Sin propina):**
  - Dado monto = 90.00, personas = 3, propina = 0%, modo = exacto.
  - Cuando se presiona "Calcular".
  - Entonces el resultado mostrado por persona es 30.00.
- **Escenario 5 (Redondeo exacto con decimales periódicos):**
  - Dado monto = 10.00, personas = 3, propina = 0%, modo = exacto.
  - Cuando se presiona "Calcular".
  - Entonces el resultado mostrado por persona es 3.33.

---

### User Story 2 - Estrategias de Redondeo (Prioridad: P2)
Como usuario que no dispone de monedas fraccionarias o desea dejar una cuota entera, quiero poder elegir el redondeo hacia arriba al entero más cercano.

**Criterios de Aceptación:**
- **Escenario 6 (Redondeo hacia arriba):**
  - Dado monto = 10.00, personas = 3, propina = 0%, modo = hacia arriba.
  - Cuando se presiona "Calcular".
  - Entonces el resultado mostrado por persona es 4.00.

---

### User Story 3 - Validación de Entradas y Manejo de Errores (Prioridad: P1)
Como usuario, si cometo un error al tipear los datos, la aplicación debe alertarme con un mensaje claro y NO mostrar ningún resultado de cálculo.

**Criterios de Aceptación:**
- **Escenario 3 (Cero o menos personas):**
  - Dado monto = 50.00 y personas = 0.
  - Cuando se presiona "Calcular".
  - Entonces se muestra el mensaje exacto "Debe haber al menos una persona" y NO se muestra resultado.
- **Escenario 4 (Monto no numérico o inválido):**
  - Dado monto = "abc" o valores no numéricos.
  - Cuando se presiona "Calcular".
  - Entonces se muestra el mensaje exacto "Monto inválido" y NO se muestra resultado.

---

## Clarificaciones (/speckit-clarify)

Durante la fase de clarificación se identificaron y resolvieron las siguientes ambigüedades clave:
1. **Pregunta 1:** *¿Qué ocurre si el usuario deja el campo de porcentaje de propina vacío?*  
   **Resolución:** Se asume un valor por defecto de `0%` de propina para no bloquear el cálculo si los comensales no desean incluir propina.
2. **Pregunta 2:** *¿Cómo deben presentarse los resultados cuando el valor es un entero exacto (por ejemplo 30 o 4)?*  
   **Resolución:** El formateador siempre debe mostrar exactamente dos cifras decimales (`30.00`, `4.00`, etc.) utilizando la representación estándar monetaria.

---

## Restricciones Técnicas
- **Offline First:** 100% desconectado, sin peticiones de red ni persistencia en base de datos.
- **Sin paquetes externos:** Exclusivamente Flutter y Dart SDK estándar.
- **Alineación Constitucional:** Cumplimiento total de SOLID y separación en `presentation`, `domain` y `data`.
