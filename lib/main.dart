import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de Cuenta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DivisorCuentaPage(),
    );
  }
}

class DivisorCuentaPage extends StatefulWidget {
  const DivisorCuentaPage({super.key});

  @override
  State<DivisorCuentaPage> createState() => _DivisorCuentaPageState();
}

class _DivisorCuentaPageState extends State<DivisorCuentaPage> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _personasController = TextEditingController();
  final TextEditingController _propinaController = TextEditingController();

  String _modoRedondeo = 'exacto'; // 'exacto' o 'arriba'
  String? _resultadoTexto;
  String? _mensajeError;

  void _calcular() {
    setState(() {
      _mensajeError = null;
      _resultadoTexto = null;

      final String montoTexto = _montoController.text.trim();
      final double? monto = double.tryParse(montoTexto);
      if (monto == null || monto.isNaN) {
        _mensajeError = 'Monto inválido';
        return;
      }

      final String personasTexto = _personasController.text.trim();
      final int? personas = int.tryParse(personasTexto);
      if (personas == null || personas <= 0) {
        _mensajeError = 'Debe haber al menos una persona';
        return;
      }

      final String propinaTexto = _propinaController.text.trim();
      final double propinaPorcentaje = double.tryParse(propinaTexto) ?? 0.0;

      final double totalConPropina = monto + (monto * (propinaPorcentaje / 100));
      double porPersona = totalConPropina / personas;

      if (_modoRedondeo == 'arriba') {
        porPersona = porPersona.ceilToDouble();
      }

      _resultadoTexto = porPersona.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _montoController.dispose();
    _personasController.dispose();
    _propinaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Cuenta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _montoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto total',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _personasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de personas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _propinaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Porcentaje de propina (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Modo de redondeo:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'exacto',
                  label: Text('Exacto'),
                ),
                ButtonSegment<String>(
                  value: 'arriba',
                  label: Text('Hacia arriba'),
                ),
              ],
              selected: {_modoRedondeo},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _modoRedondeo = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 24),
            if (_mensajeError != null)
              Text(
                _mensajeError!,
                style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            if (_resultadoTexto != null)
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total por persona:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _resultadoTexto!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
