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
    if (propina > 100) {
      return 'La propina no puede superar el 100%';
    }
    return null;
  }

  String? ejecutarTextos({
    required String montoTexto,
    required String personasTexto,
    String? propinaTexto,
  }) {
    final double? monto = double.tryParse(montoTexto.trim());
    if (monto == null) {
      return 'Monto inválido';
    }
    final int? personas = int.tryParse(personasTexto.trim());
    if (personas == null) {
      return 'Debe haber al menos una persona';
    }
    final double propina = double.tryParse(propinaTexto?.trim() ?? '') ?? 0.0;

    return ejecutar(
      monto: monto,
      personas: personas,
      propina: propina,
    );
  }
}
