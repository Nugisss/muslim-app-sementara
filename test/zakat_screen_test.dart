import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_app/presentation/screens/zakat_screen.dart';

void main() {
  Future<void> openCalculator(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ZakatScreen()),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Kalkulator zakat'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('money calculator has one input and calculates at nisab', (
    tester,
  ) async {
    await openCalculator(tester);

    await tester.enterText(find.byType(TextField).at(0), '85000000');
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
    expect(
      find.textContaining(
        'Patokan nisab uang yang digunakan Rp 85.000.000, setara nilai 85 gram emas.',
      ),
      findsOneWidget,
    );
    expect(find.text('Rp 2.125.000'), findsOneWidget);
  });

  testWidgets('money calculator reports when wealth is below nisab', (
    tester,
  ) async {
    await openCalculator(tester);

    await tester.enterText(find.byType(TextField).at(0), '84000000');
    await tester.pumpAndSettle();

    expect(find.text('Belum mencapai nisab'), findsOneWidget);
    expect(find.text('Rp 2.100.000'), findsNothing);
  });

  testWidgets('gold calculator calculates zakat in grams', (tester) async {
    await openCalculator(tester);
    await tester.tap(find.text('Emas').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '100');
    await tester.enterText(find.byType(TextField).at(1), '1000000');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(find.text('2.5 gram'), findsOneWidget);
    expect(find.text('Setara sekitar Rp 2.500.000.'), findsOneWidget);
  });

  testWidgets('silver calculator uses the 595 gram nisab', (tester) async {
    await openCalculator(tester);
    await tester.tap(find.text('Perak').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '600');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(find.text('15 gram'), findsOneWidget);
  });

  testWidgets('livestock calculator shows due animals at the threshold', (
    tester,
  ) async {
    await openCalculator(tester);
    await tester.tap(find.text('Ternak').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '40');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(find.text('1 ekor kambing/domba'), findsOneWidget);
  });

  testWidgets('cattle calculator reports the due animal type', (tester) async {
    await openCalculator(tester);
    await tester.tap(find.text('Ternak').first);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate((widget) => widget is DropdownButtonFormField),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sapi/kerbau').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '30');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    expect(find.text('1 ekor tabi (umur 1 tahun)'), findsOneWidget);
  });

  testWidgets('harvest calculator applies irrigation rate without haul', (
    tester,
  ) async {
    await openCalculator(tester);
    await tester.tap(find.text('Panen').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '1000');
    await tester.pumpAndSettle();

    expect(find.text('50 kg beras'), findsOneWidget);
    expect(
      find.text('Kadar 5.0% sesuai pengairan irigasi berbiaya.'),
      findsOneWidget,
    );
    expect(find.byType(CheckboxListTile), findsNothing);
  });
}
