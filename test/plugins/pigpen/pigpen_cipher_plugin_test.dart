import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/plugins/pigpen/pigpen_cipher_plugin.dart';
import 'package:scout_code/plugins/pigpen/pigpen_glyph_painter.dart';

void main() {
  final plugin = PigpenCipherPlugin();

  group('PigpenCipherPlugin.encode/decode', () {
    test('normalizza il testo in maiuscolo', () {
      expect(plugin.encode('ciao', plugin.defaultConfig).output, 'CIAO');
    });

    test('lettera accentata: base + apostrofo letterale', () {
      expect(plugin.encode('città', plugin.defaultConfig).output, "CITTA'");
    });

    test('i simboli passano invariati', () {
      expect(plugin.encode('SOS!', plugin.defaultConfig).output, 'SOS!');
    });

    test('decode è equivalente a encode (cifrario puramente visivo)', () {
      final encoded = plugin.encode('Nodo', plugin.defaultConfig);
      final decoded = plugin.decode(encoded.output, plugin.defaultConfig);
      expect(decoded.output, encoded.output);
    });

    test('isVisualOutput è true: export/condivisione devono usare l\'immagine', () {
      expect(plugin.isVisualOutput, isTrue);
    });
  });

  group('PigpenCipherPlugin.buildOutputView', () {
    testWidgets('renderizza un glifo per ogni lettera', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => plugin.buildOutputView(context, 'AB'),
            ),
          ),
        ),
      );

      expect(find.byType(PigpenGlyphView), findsNWidgets(2));
    });

    testWidgets('mostra un trattino per output vuoto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => plugin.buildOutputView(context, ''),
            ),
          ),
        ),
      );

      expect(find.text('—'), findsOneWidget);
    });
  });
}
