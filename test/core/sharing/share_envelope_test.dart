import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/core/sharing/share_envelope.dart';

void main() {
  group('ShareEnvelope', () {
    test(
      'encode/decode roundtrip preserva cifrario, direzione, config e testo',
      () {
        const envelope = ShareEnvelope(
          cipherId: 'caesar',
          direction: 'encode',
          config: {'shift': 3, 'alphabet': 'english'},
          text: 'D • E • F',
        );

        final decoded = ShareEnvelope.tryDecode(envelope.encode());

        expect(decoded, isNotNull);
        expect(decoded!.cipherId, 'caesar');
        expect(decoded.direction, 'encode');
        expect(decoded.config, {'shift': 3, 'alphabet': 'english'});
        expect(decoded.text, 'D • E • F');
      },
    );

    test('ritorna null per JSON non valido', () {
      expect(ShareEnvelope.tryDecode('questo non è JSON'), isNull);
    });

    test('ritorna null per JSON valido ma senza il marker "scoutcode"', () {
      expect(ShareEnvelope.tryDecode('{"foo": "bar"}'), isNull);
    });

    test('ritorna null se "config" non è una mappa', () {
      expect(
        ShareEnvelope.tryDecode(
          '{"app":"scoutcode","v":1,"cipherId":"morse","direction":"encode","config":"x","text":"y"}',
        ),
        isNull,
      );
    });
  });
}
