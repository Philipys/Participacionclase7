# Instrucciones del Proyecto: Divisor de Cuenta

## Descripción
App en Flutter de una sola pantalla para dividir la cuenta de un restaurante entre varias personas, calculando el monto por persona según la propina y modo de redondeo.

## Estructura y Arquitectura
- Capas limpias en `lib/`:
  - `lib/presentation/`: Controladores, pantallas y formateadores visuales.
  - `lib/domain/`: Entidades, casos de uso e interfaces abstractas.
  - `lib/data/`: Implementaciones concretas de interfaces de dominio.
- Regla de dependencia: `presentation -> domain <- data`.
- Pureza del dominio: `lib/domain/` NO importa nada de `package:flutter` (Dart puro).
- Inversión de dependencias: `lib/main.dart` es el único punto de composición donde se instancian las implementaciones concretas.

## Estándares de Código
- Null safety estricto.
- Nombres de clases, métodos, variables y archivos en español.
- Sin paquetes externos (únicamente Flutter y Dart SDK).

## Restricciones (Qué NO tocar)
- NO modifiques la carpeta `test/` a menos que se solicite explícitamente.
- NO agregues dependencias externas a `pubspec.yaml` sin avisar.
- NO modifiques carpetas de plataformas nativas (`android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`).

## Comandos Principales
- Obtener dependencias: `flutter pub get`
- Ejecutar aplicación: `flutter run`
- Análisis estático: `flutter analyze`
- Ejecutar pruebas: `flutter test`
