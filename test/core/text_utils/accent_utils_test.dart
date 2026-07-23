import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/core/text_utils/accent_utils.dart';

void main() {
  group('AccentUtils.expandChar', () {
    final accentedCases = {
      'à': 'a',
      'á': 'a',
      'è': 'e',
      'é': 'e',
      'ì': 'i',
      'í': 'i',
      'ò': 'o',
      'ó': 'o',
      'ù': 'u',
      'ú': 'u',
      'ñ': 'n',
      'ç': 'c',
      'À': 'A',
      'É': 'E',
    };

    for (final entry in accentedCases.entries) {
      test('"${entry.key}" si espande in base "${entry.value}"', () {
        final result = AccentUtils.expandChar(entry.key);
        expect(result.base, entry.value);
        expect(result.wasAccented, isTrue);
      });
    }

    for (final char in ['a', 'B', '3', '!', ' ']) {
      test('"$char" non accentato resta invariato', () {
        final result = AccentUtils.expandChar(char);
        expect(result.base, char);
        expect(result.wasAccented, isFalse);
      });
    }
  });
}
