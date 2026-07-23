import '../../core/cipher/cipher_operation_result.dart';
import '../../core/text_utils/accent_utils.dart';
import 'morse_table.dart';

const String _morseDot = '•';
const String _morseDash = '⁃';
const String _letterSeparator = '|';
const String _wordSeparator = '||';
const String _accentMarker = "'";

/// Codifica/decodifica secondo il sottoinsieme Morse non standard usato nei
/// giochi del gruppo: vedi istruzioni.md per le regole esatte.
class MorseEncoder {
  const MorseEncoder._();

  static CipherOperationResult encode(String plainText) {
    final buffer = StringBuffer();
    var previousWasLetter = false;

    for (final char in plainText.split('')) {
      if (char == '.' || char == '|') {
        continue;
      }
      if (char == ' ') {
        buffer.write(_wordSeparator);
        previousWasLetter = false;
        continue;
      }

      final expanded = AccentUtils.expandChar(char);
      final code = morseEncodeTable[expanded.base.toUpperCase()];
      if (code != null) {
        if (previousWasLetter) {
          buffer.write(_letterSeparator);
        }
        buffer.write(code);
        if (expanded.wasAccented) {
          buffer.write(_accentMarker);
        }
        previousWasLetter = true;
      } else {
        buffer.write(char);
        previousWasLetter = false;
      }
    }

    return CipherOperationResult(output: buffer.toString());
  }

  static CipherOperationResult decode(String cipherText) {
    final output = StringBuffer();
    final warnings = <String>[];
    final codeBuffer = StringBuffer();

    void flushCode() {
      if (codeBuffer.isEmpty) return;
      final code = codeBuffer.toString();
      final letter = morseDecodeTable[code];
      if (letter != null) {
        output.write(letter);
      } else {
        warnings.add('Sequenza Morse non riconosciuta: "$code"');
        output.write(code);
      }
      codeBuffer.clear();
    }

    var i = 0;
    while (i < cipherText.length) {
      final char = cipherText[i];
      if (char == _morseDot || char == _morseDash) {
        codeBuffer.write(char);
        i++;
        continue;
      }
      if (char == _accentMarker) {
        flushCode();
        output.write(_accentMarker);
        i++;
        continue;
      }
      if (char == _letterSeparator) {
        flushCode();
        if (i + 1 < cipherText.length &&
            cipherText[i + 1] == _letterSeparator) {
          output.write(' ');
          i += 2;
        } else {
          i++;
        }
        continue;
      }
      flushCode();
      output.write(char);
      i++;
    }
    flushCode();

    return CipherOperationResult(output: output.toString(), warnings: warnings);
  }
}
