import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

class CalcularDivision {
  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final double totalPropina = cuenta.monto * (cuenta.porcentajePropina / 100.0);
    final double totalConPropina = cuenta.monto + totalPropina;
    final double cuota = totalConPropina / cuenta.personas;
    final double cuotaFinal = estrategia.redondear(cuota);

    return Resultado(montoPorPersona: cuotaFinal);
  }
}
