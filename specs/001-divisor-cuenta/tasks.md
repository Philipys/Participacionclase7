# Tasks: Divisor de Cuenta de Restaurante

**Feature**: `001-divisor-cuenta` | **Status**: Defined

## Lista de Tareas de Implementación

- [ ] **T001**: Crear entidades de dominio inmutables `Cuenta` y `Resultado` en `lib/domain/cuenta.dart` y `lib/domain/resultado.dart`.
- [ ] **T002**: Definir la interfaz abstracta `EstrategiaRedondeo` con un único método en `lib/domain/estrategia_redondeo.dart` (ISP).
- [ ] **T003**: Implementar el caso de uso `ValidarEntrada` en `lib/domain/validar_entrada.dart` para validar monto y número de personas (SRP).
- [ ] **T004**: Implementar el caso de uso `CalcularDivision` en `lib/domain/calcular_division.dart` que recibe la entidad `Cuenta` y la estrategia de redondeo (SRP, OCP, LSP).
- [ ] **T005**: Implementar la estrategia `RedondeoExacto` en `lib/data/redondeo_exacto.dart`.
- [ ] **T006**: Implementar la estrategia `RedondeoHaciaArriba` en `lib/data/redondeo_hacia_arriba.dart`.
- [ ] **T007**: Implementar la utilidad de presentación `FormateadorMoneda` en `lib/presentation/formateador_moneda.dart` (SRP).
- [ ] **T008**: Implementar el controlador `DivisorController` en `lib/presentation/divisor_controller.dart` recibiendo sus dependencias por constructor (DIP).
- [ ] **T009**: Implementar el widget `PantallaDivisor` en `lib/presentation/pantalla_divisor.dart` conectada al controlador.
- [ ] **T010**: Configurar la composición e instanciación de dependencias en `lib/main.dart`.
