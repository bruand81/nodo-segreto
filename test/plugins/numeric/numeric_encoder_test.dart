import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/plugins/numeric/numeric_config.dart';
import 'package:scout_code/plugins/numeric/numeric_encoder.dart';

void main() {
  const standardCircular = NumericConfig(
    baseValueForA: 1,
    shiftMode: NumericShiftMode.circular,
  );
  const shiftedCircular = NumericConfig(
    baseValueForA: 3,
    shiftMode: NumericShiftMode.circular,
  );
  const shiftedLinear = NumericConfig(
    baseValueForA: 3,
    shiftMode: NumericShiftMode.linear,
  );

  group('NumericEncoder.encode', () {
    test('chiave standard A=1: numeri separati da " • "', () {
      final result = NumericEncoder.encode('ABC', standardCircular);
      expect(result.output, '1 • 2 • 3\n1 -> A');
    });

    test('shift circolare: A=3 ... Z=2 (wraparound)', () {
      expect(NumericEncoder.numberForIndex(0, shiftedCircular), 3); // A
      expect(NumericEncoder.numberForIndex(25, shiftedCircular), 2); // Z
    });

    test('shift lineare: A=3 ... Z=28 (nessun wraparound)', () {
      expect(NumericEncoder.numberForIndex(0, shiftedLinear), 3); // A
      expect(NumericEncoder.numberForIndex(25, shiftedLinear), 28); // Z
    });

    test('lettera accentata: numero base + apostrofo letterale', () {
      final result = NumericEncoder.encode('à', standardCircular);
      expect(result.output, "1'\n1 -> A");
    });

    test('simboli passano invariati, senza separatore intorno', () {
      final result = NumericEncoder.encode('A!B', standardCircular);
      expect(result.output, '1!2\n1 -> A');
    });

    test('la chiave in coda usa il numero della prima lettera per default', () {
      final result = NumericEncoder.encode('CIAO', shiftedCircular);
      expect(result.output.split('\n').last, '5 -> C');
    });

    test('demoNumber esplicito sostituisce il default automatico', () {
      const config = NumericConfig(
        baseValueForA: 3,
        shiftMode: NumericShiftMode.circular,
        demoNumber: 5,
      );
      final result = NumericEncoder.encode('CIAO', config);
      expect(result.output.split('\n').last, '5 -> C');
    });
  });

  group('NumericEncoder.decode', () {
    test('decodifica un messaggio con la chiave in coda', () {
      final encoded = NumericEncoder.encode('CIAO', standardCircular);
      final decoded = NumericEncoder.decode(encoded.output, standardCircular);
      expect(decoded.output, 'CIAO');
    });

    test('decodifica senza chiave in coda usando la config esplicita', () {
      final decoded = NumericEncoder.decode('1 • 2 • 3', standardCircular);
      expect(decoded.output, 'ABC');
    });

    test('round trip con shift lineare e simboli misti', () {
      final encoded = NumericEncoder.encode('CIAO!', shiftedLinear);
      final decoded = NumericEncoder.decode(encoded.output, shiftedLinear);
      expect(decoded.output, 'CIAO!');
    });

    test(
      'segnala con un warning un numero fuori dal range valido (lineare)',
      () {
        final result = NumericEncoder.decode('99', shiftedLinear);
        expect(result.warnings, isNotEmpty);
      },
    );
  });
}
