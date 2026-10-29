import 'package:flutter/material.dart';
import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/estrategia_redondeo.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // lib/main.dart es el ÚNICO punto de composición donde se instancian clases concretas
    final Map<String, EstrategiaRedondeo> estrategias = {
      'exacto': const RedondeoExacto(),
      'arriba': const RedondeoHaciaArriba(),
    };

    final controller = DivisorController(
      validarEntrada: ValidarEntrada(),
      calcularDivision: CalcularDivision(),
      estrategias: estrategias,
    );

    return MaterialApp(
      title: 'Divisor de Cuenta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PantallaDivisor(controller: controller),
    );
  }
}
