import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/plugins/caesar/caesar_alphabets.dart';
import 'package:scout_code/plugins/caesar/caesar_config.dart';
import 'package:scout_code/plugins/caesar/caesar_encoder.dart';

void main() {
  const englishShift3 = CaesarConfig(
    shift: 3,
    alphabet: CaesarAlphabetMode.english,
  );
  const italianShift3 = CaesarConfig(
    shift: 3,
    alphabet: CaesarAlphabetMode.italian,
  );

  group('CaesarEncoder.encode', () {
    test('shift semplice su alfabeto inglese, lettere separate da " • "', () {
      final result = CaesarEncoder.encode('AB', englishShift3);
      expect(result.output, 'D • E\nD -> A');
    });

    test('wraparound circolare a fine alfabeto (inglese)', () {
      final result = CaesarEncoder.encode('XYZ', englishShift3);
      expect(result.output, 'A • B • C\nD -> A');
    });

    test('wraparound su alfabeto italiano (21 lettere)', () {
      final result = CaesarEncoder.encode('Z', italianShift3);
      // Z è l'ultima lettera (indice 20); +3 mod 21 = indice 2 -> 'C'.
      expect(result.output, 'C\nD -> A');
    });

    test('lettera accentata: base cifrata + apostrofo letterale', () {
      final result = CaesarEncoder.encode('à', englishShift3);
      expect(result.output, "D'\nD -> A");
    });

    test(
      'simboli e punteggiatura passano invariati, senza separatore intorno',
      () {
        final result = CaesarEncoder.encode('A!B', englishShift3);
        expect(result.output, 'D!E\nD -> A');
      },
    );

    test('lettere fuori dall\'alfabeto italiano passano invariate', () {
      final result = CaesarEncoder.encode('J', italianShift3);
      expect(result.output, 'J\nD -> A');
    });

    test('la chiave in coda riflette shift e alfabeto scelti', () {
      const config = CaesarConfig(
        shift: 5,
        alphabet: CaesarAlphabetMode.english,
      );
      final result = CaesarEncoder.encode('A', config);
      expect(result.output, 'F\nF -> A');
    });
  });

  group('CaesarEncoder.decode', () {
    test('decodifica usando la chiave in coda al messaggio', () {
      final encoded = CaesarEncoder.encode('CIAO MONDO', englishShift3);
      // Config di decodifica con uno shift diverso: la chiave in coda
      // deve prevalere e restituire comunque il messaggio originale.
      const wrongConfig = CaesarConfig(
        shift: 1,
        alphabet: CaesarAlphabetMode.english,
      );
      final decoded = CaesarEncoder.decode(encoded.output, wrongConfig);
      expect(decoded.output, 'CIAO MONDO');
    });

    test('decodifica senza chiave in coda usa la config esplicita', () {
      final decoded = CaesarEncoder.decode('D • E', englishShift3);
      expect(decoded.output, 'AB');
    });

    test('round trip su alfabeto italiano con simboli', () {
      final encoded = CaesarEncoder.encode('CIAO!', italianShift3);
      final decoded = CaesarEncoder.decode(encoded.output, italianShift3);
      expect(decoded.output, 'CIAO!');
    });
  });
}
