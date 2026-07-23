import '../../core/cipher/cipher_operation_result.dart';
import '../../core/text_utils/accent_utils.dart';
import 'numeric_config.dart';

const String _letterSeparator = ' • ';
const String _accentMarker = "'";
const int _alphabetLength = 26;

/// Codifica/decodifica secondo il cifrario a sostituzione numerica: vedi
/// istruzioni.md per le regole esatte (chiave base per A, shift circolare
/// o lineare, chiave di decifratura in coda al messaggio).
class NumericEncoder {
  const NumericEncoder._();

  static int numberForIndex(int index, NumericConfig config) {
    final base = config.baseValueForA;
    return switch (config.shiftMode) {
      NumericShiftMode.circular => ((base - 1 + index) % _alphabetLength) + 1,
      NumericShiftMode.linear => base + index,
    };
  }

  /// Ritorna la lettera corrispondente a [number], o null se [number] non è
  /// un valore valido per la config data (può accadere in modalità lineare,
  /// dove non tutti i numeri sono raggiungibili).
  static String? letterForNumber(int number, NumericConfig config) {
    final base = config.baseValueForA;
    int index;
    switch (config.shiftMode) {
      case NumericShiftMode.circular:
        index = (number - base) % _alphabetLength;
        if (index < 0) index += _alphabetLength;
        break;
      case NumericShiftMode.linear:
        index = number - base;
        if (index < 0 || index >= _alphabetLength) return null;
        break;
    }
    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }

  static CipherOperationResult encode(String plainText, NumericConfig config) {
    final buffer = StringBuffer();
    var previousWasLetter = false;
    int? firstLetterNumber;

    for (final char in plainText.split('')) {
      final expanded = AccentUtils.expandChar(char);
      final upper = expanded.base.toUpperCase();
      final index = upper.codeUnitAt(0) - 'A'.codeUnitAt(0);
      final isLetter =
          upper.length == 1 && index >= 0 && index < _alphabetLength;

      if (!isLetter) {
        buffer.write(char);
        previousWasLetter = false;
        continue;
      }

      final number = numberForIndex(index, config);
      firstLetterNumber ??= number;

      if (previousWasLetter) {
        buffer.write(_letterSeparator);
      }
      buffer.write(number.toString());
      if (expanded.wasAccented) {
        buffer.write(_accentMarker);
      }
      previousWasLetter = true;
    }

    final demoNumber = config.demoNumber ?? firstLetterNumber;
    if (demoNumber != null) {
      final letter = letterForNumber(demoNumber, config);
      if (letter != null) {
        buffer.write('\n$demoNumber -> $letter');
      }
    }

    return CipherOperationResult(output: buffer.toString());
  }

  static CipherOperationResult decode(String cipherText, NumericConfig config) {
    final keyLinePattern = RegExp(r'^\d+ -> [A-Za-z]$');
    final lines = cipherText.split('\n');
    var body = cipherText;
    if (lines.isNotEmpty && keyLinePattern.hasMatch(lines.last.trim())) {
      body = lines.sublist(0, lines.length - 1).join('\n');
    }

    final output = StringBuffer();
    final warnings = <String>[];
    final numberBuffer = StringBuffer();

    void flushNumber() {
      if (numberBuffer.isEmpty) return;
      final number = int.parse(numberBuffer.toString());
      final letter = letterForNumber(number, config);
      if (letter != null) {
        output.write(letter);
      } else {
        warnings.add('Numero non valido per la chiave scelta: $number');
        output.write(number.toString());
      }
      numberBuffer.clear();
    }

    var i = 0;
    while (i < body.length) {
      final char = body[i];

      if (_isDigit(char)) {
        numberBuffer.write(char);
        i++;
        continue;
      }

      if (char == ' ' &&
          i + 2 < body.length &&
          body[i + 1] == '•' &&
          body[i + 2] == ' ') {
        flushNumber();
        i += 3;
        continue;
      }

      if (char == _accentMarker) {
        flushNumber();
        output.write(_accentMarker);
        i++;
        continue;
      }

      flushNumber();
      output.write(char);
      i++;
    }
    flushNumber();

    return CipherOperationResult(output: output.toString(), warnings: warnings);
  }

  static bool _isDigit(String char) {
    final code = char.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}
