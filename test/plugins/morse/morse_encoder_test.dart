import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/plugins/morse/morse_encoder.dart';
import 'package:scout_code/plugins/morse/morse_table.dart';

void main() {
  group('MorseEncoder.encode', () {
    test('codifica ogni lettera A-Z secondo la tabella standard', () {
      for (final entry in morseEncodeTable.entries) {
        if (int.tryParse(entry.key) != null) continue;
        expect(MorseEncoder.encode(entry.key).output, entry.value);
        expect(
          MorseEncoder.encode(entry.key.toLowerCase()).output,
          entry.value,
        );
      }
    });

    test('codifica ogni cifra 0-9 secondo la tabella standard', () {
      for (final entry in morseEncodeTable.entries) {
        if (int.tryParse(entry.key) == null) continue;
        expect(MorseEncoder.encode(entry.key).output, entry.value);
      }
    });

    test('separa le lettere della stessa parola con "|"', () {
      expect(MorseEncoder.encode('SOS').output, '•••|⁃⁃⁃|•••');
      expect(MorseEncoder.encode('CIAO').output, '⁃•⁃•|••|•⁃|⁃⁃⁃');
    });

    test('separa le parole con "||"', () {
      expect(
        MorseEncoder.encode('CIAO MONDO').output,
        '⁃•⁃•|••|•⁃|⁃⁃⁃||⁃⁃|⁃⁃⁃|⁃•|⁃••|⁃⁃⁃',
      );
    });

    test('lettera accentata: base codificata + apostrofo letterale', () {
      expect(MorseEncoder.encode('à').output, "•⁃'");
      expect(MorseEncoder.encode('è').output, "•'");
    });

    test('lettera accentata seguita da unaltra lettera resta nella parola', () {
      expect(MorseEncoder.encode('àb').output, "•⁃'|⁃•••");
    });

    test(
      'il punto e il carattere | vengono saltati senza lasciare separatori',
      () {
        expect(MorseEncoder.encode('A.B').output, '•⁃|⁃•••');
        expect(MorseEncoder.encode('A|B').output, '•⁃|⁃•••');
        expect(MorseEncoder.encode('...').output, '');
      },
    );

    test('gli altri simboli passano invariati, senza separatore intorno', () {
      expect(MorseEncoder.encode('A!B').output, '•⁃!⁃•••');
      expect(MorseEncoder.encode('!').output, '!');
    });

    test('stringa vuota produce output vuoto', () {
      expect(MorseEncoder.encode('').output, '');
    });
  });

  group('MorseEncoder.decode', () {
    test('decodifica lettere separate da "|" nella stessa parola', () {
      expect(MorseEncoder.decode('•••|⁃⁃⁃|•••').output, 'SOS');
    });

    test('decodifica il separatore di parola "||" come spazio', () {
      expect(
        MorseEncoder.decode('⁃•⁃•|••|•⁃|⁃⁃⁃||⁃⁃|⁃⁃⁃|⁃•|⁃••|⁃⁃⁃').output,
        'CIAO MONDO',
      );
    });

    test('decodifica il marcatore di accento come apostrofo letterale', () {
      expect(MorseEncoder.decode("•⁃'").output, "A'");
      expect(MorseEncoder.decode("•⁃'|⁃•••").output, "A'B");
    });

    test('decodifica i simboli grezzi frapposti alle lettere', () {
      expect(MorseEncoder.decode('•⁃!⁃•••').output, 'A!B');
    });

    test('segnala con un warning una sequenza morse non riconosciuta', () {
      final result = MorseEncoder.decode('••••••');
      expect(result.warnings, isNotEmpty);
    });
  });
}
