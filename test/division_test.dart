import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';

import 'casos_de_prueba.dart';

void main() {
  final validarEntrada = ValidarEntrada();
  final calcularDivision = CalcularDivision();

  group('Criterios de Aceptación de la Especificación', () {
    for (final caso in casos) {
      test(caso.nombre, () {
        final error = validarEntrada.ejecutar(
          monto: caso.monto,
          personas: caso.personas,
          propina: caso.propina,
        );

        if (caso.errorEsperado != null) {
          expect(error, equals(caso.errorEsperado));
        } else {
          expect(error, isNull);
          final EstrategiaRedondeo estrategia = caso.modo == 'arriba'
              ? const RedondeoHaciaArriba()
              : const RedondeoExacto();

          final cuenta = Cuenta(
            monto: caso.monto,
            personas: caso.personas,
            porcentajePropina: caso.propina,
          );

          final resultado = calcularDivision.ejecutar(cuenta, estrategia);
          expect(resultado.montoPorPersona, closeTo(caso.esperado!, 0.001));
        }
      });
    }
  });

  test('Demostración de LSP: CalcularDivision funciona con cualquier EstrategiaRedondeo sin if ni cast', () {
    final cuenta = const Cuenta(
      monto: 10.0,
      personas: 3,
      porcentajePropina: 0.0,
    );

    EstrategiaRedondeo estrategia = const RedondeoExacto();
    final resExacto = calcularDivision.ejecutar(cuenta, estrategia);
    expect(resExacto.montoPorPersona, closeTo(3.333, 0.01));

    estrategia = const RedondeoHaciaArriba();
    final resArriba = calcularDivision.ejecutar(cuenta, estrategia);
    expect(resArriba.montoPorPersona, closeTo(4.00, 0.001));
  });
}
