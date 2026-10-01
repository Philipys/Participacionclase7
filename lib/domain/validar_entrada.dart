class ValidarEntrada {
  String? ejecutar({
    required double monto,
    required int personas,
    double propina = 0.0,
  }) {
    if (monto.isNaN || monto.isInfinite || monto <= 0) {
      return 'Monto inválido';
    }
    if (personas <= 0) {
      return 'Debe haber al menos una persona';
    }
    return null;
  }

  String? ejecutarTextos({
    required String montoTexto,
    required String personasTexto,
    String? propinaTexto,
  }) {
    final double? monto = double.tryParse(montoTexto.trim());
    if (monto == null || monto.isNaN || monto <= 0) {
      return 'Monto inválido';
    }
    final int? personas = int.tryParse(personasTexto.trim());
    if (personas == null || personas <= 0) {
      return 'Debe haber al menos una persona';
    }
    return null;
  }
}
