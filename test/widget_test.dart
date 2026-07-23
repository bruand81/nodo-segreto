import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scout_code/app/scout_code_app.dart';

void main() {
  testWidgets('ScoutCodeApp mostra selettore, input e output', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ScoutCodeApp()));

    expect(find.text('Nodo Segreto'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

    // Il Morse è il primo cifrario registrato, quindi è già selezionato di
    // default: verifica il ciclo UI -> plugin -> output con un cifrario reale.
    await tester.enterText(find.byKey(const Key('input-area-text-field')), 'A');
    await tester.tap(find.text('Esegui'));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byKey(const Key('output-area-text')),
        matching: find.text('•⁃'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'Mostra QR è nascosto per i cifrari con output visivo (Pigpen)',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: ScoutCodeApp()));

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Pigpen').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Mostra QR'), findsNothing);
      expect(find.text('Condividi'), findsOneWidget);
      expect(find.text('Esporta file'), findsOneWidget);
    },
  );
}
