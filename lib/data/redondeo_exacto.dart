import '../domain/estrategia_redondeo.dart';

class RedondeoExacto implements EstrategiaRedondeo {
  const RedondeoExacto();

  @override
  double redondear(double valor) {
    return (valor * 100).roundToDouble() / 100.0;
  }
}
