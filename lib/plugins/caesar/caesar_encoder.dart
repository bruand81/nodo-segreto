import '../../core/cipher/cipher_operation_result.dart';
import '../../core/text_utils/accent_utils.dart';
import 'caesar_alphabets.dart';
import 'caesar_config.dart';

const String _letterSeparator = ' • ';
const String _accentMarker = "'";

/// Codifica/decodifica secondo il cifrario di Cesare: vedi istruzioni.md
/// per le regole esatte (shift configurabile, alfabeto IT/EN, chiave in
/// coda al messaggio).
class CaesarEncoder {
  const CaesarEncoder._();

  static CipherOperationResult encode(String plainText, CaesarConfig config) {
    final alphabet = alphabetFor(config.alphabet);
    final buffer = StringBuffer();
    var previousWasLetter = false;

    for (final char in plainText.split('')) {
      final expanded = AccentUtils.expandChar(char);
      final upper = expanded.base.toUpperCase();
      final index = alphabet.indexOf(upper);

      if (index == -1) {
        buffer.write(char);
        previousWasLetter = false;
        continue;
      }

      final cipherLetter = alphabet[(index + config.shift) % alphabet.length];
      if (previousWasLetter) {
        buffer.write(_letterSeparator);
      }
      buffer.write(cipherLetter);
      if (expanded.wasAccented) {
        buffer.write(_accentMarker);
      }
      previousWasLetter = true;
    }

    final demoPlain = alphabet[0];
    final demoCipher = alphabet[config.shift % alphabet.length];
    buffer.write('\n$demoCipher -> $demoPlain');

    return CipherOperationResult(output: buffer.toString());
  }

  static CipherOperationResult decode(String cipherText, CaesarConfig config) {
    final alphabet = alphabetFor(config.alphabet);
    final keyLinePattern = RegExp(r'^([A-Za-z]) -> ([A-Za-z])$');

    final lines = cipherText.split('\n');
    var body = cipherText;
    var shift = config.shift;

    if (lines.isNotEmpty) {
      final match = keyLinePattern.firstMatch(lines.last.trim());
      if (match != null) {
        final cipherLetter = match.group(1)!.toUpperCase();
        final plainLetter = match.group(2)!.toUpperCase();
        final cipherIndex = alphabet.indexOf(cipherLetter);
        final plainIndex = alphabet.indexOf(plainLetter);
        if (cipherIndex != -1 && plainIndex != -1) {
          shift = (cipherIndex - plainIndex) % alphabet.length;
          if (shift < 0) shift += alphabet.length;
          body = lines.sublist(0, lines.length - 1).join('\n');
        }
      }
    }

    final output = StringBuffer();
    var i = 0;
    while (i < body.length) {
      final char = body[i];

      if (char == ' ' &&
          i + 2 < body.length &&
          body[i + 1] == '•' &&
          body[i + 2] == ' ') {
        i += 3;
        continue;
      }

      if (char == _accentMarker) {
        output.write(_accentMarker);
        i++;
        continue;
      }

      final upper = char.toUpperCase();
      final index = alphabet.indexOf(upper);
      if (index != -1) {
        var plainIndex = (index - shift) % alphabet.length;
        if (plainIndex < 0) plainIndex += alphabet.length;
        output.write(alphabet[plainIndex]);
        i++;
        continue;
      }

      output.write(char);
      i++;
    }

    return CipherOperationResult(output: output.toString());
  }
}
