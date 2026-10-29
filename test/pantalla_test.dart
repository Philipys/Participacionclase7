import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('1. Escribo 100, 4 y 10, toco "Calcular" y aparece "27.50" en pantalla',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), '100');
    await tester.enterText(textFields.at(1), '4');
    await tester.enterText(textFields.at(2), '10');

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('27.50'), findsOneWidget);
  });

  testWidgets(
      '2. Escribo 50 y 0 personas, toco "Calcular" y aparece "Debe haber al menos una persona", y NO aparece ningún resultado',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), '50');
    await tester.enterText(textFields.at(1), '0');

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.text('Cada persona paga:'), findsNothing);
  });

  testWidgets('3. Escribo "abc" en el monto, toco "Calcular" y aparece "Monto inválido"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'abc');

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
