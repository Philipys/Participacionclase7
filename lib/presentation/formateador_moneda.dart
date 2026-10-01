class FormateadorMoneda {
  const FormateadorMoneda();

  String formatear(double monto) {
    return monto.toStringAsFixed(2);
  }
}
