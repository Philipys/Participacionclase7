import 'package:flutter/foundation.dart';
import '../domain/calcular_division.dart';
import '../domain/cuenta.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/validar_entrada.dart';
import 'formateador_moneda.dart';

class DivisorController extends ChangeNotifier {
  final ValidarEntrada validarEntrada;
  final CalcularDivision calcularDivision;
  final Map<String, EstrategiaRedondeo> estrategias;
  final FormateadorMoneda formateador;

  DivisorController({
    required this.validarEntrada,
    required this.calcularDivision,
    required this.estrategias,
    this.formateador = const FormateadorMoneda(),
  });

  String modoRedondeo = 'exacto';
  String? resultadoTexto;
  String? mensajeError;

  void cambiarModo(String nuevoModo) {
    modoRedondeo = nuevoModo;
    notifyListeners();
  }

  void calcular({
    required String montoTexto,
    required String personasTexto,
    String? propinaTexto,
  }) {
    resultadoTexto = null;
    mensajeError = null;

    final String? error = validarEntrada.ejecutarTextos(
      montoTexto: montoTexto,
      personasTexto: personasTexto,
      propinaTexto: propinaTexto,
    );

    if (error != null) {
      mensajeError = error;
      notifyListeners();
      return;
    }

    final double monto = double.parse(montoTexto.trim());
    final int personas = int.parse(personasTexto.trim());
    final double propina = double.tryParse(propinaTexto?.trim() ?? '') ?? 0.0;

    final cuenta = Cuenta(
      monto: monto,
      personas: personas,
      porcentajePropina: propina,
    );

    final estrategia = estrategias[modoRedondeo] ?? estrategias.values.first;
    final resultado = calcularDivision.ejecutar(cuenta, estrategia);

    resultadoTexto = formateador.formatear(resultado.montoPorPersona);
    notifyListeners();
  }
}
