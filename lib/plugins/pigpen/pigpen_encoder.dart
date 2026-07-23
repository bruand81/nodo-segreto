import '../../core/cipher/cipher_operation_result.dart';
import '../../core/text_utils/accent_utils.dart';
import 'pigpen_glyph.dart';

/// Il pigpen è puramente visivo: encode/decode normalizzano solo il testo
/// (maiuscolo + regola condivisa degli accenti), mentre la vera "cifratura"
/// è la resa in glifi fatta da [PigpenCipherPlugin.buildOutputView]. Chi
/// riceve il messaggio legge i simboli e li traduce a mano, come nel gioco
/// originale.
class PigpenEncoder {
  const PigpenEncoder._();

  static CipherOperationResult normalize(String text) {
    final buffer = StringBuffer();
    for (final char in text.split('')) {
      final expanded = AccentUtils.expandChar(char);
      final upper = expanded.base.toUpperCase();
      if (pigpenGlyphTable.containsKey(upper)) {
        buffer.write(upper);
        if (expanded.wasAccented) buffer.write("'");
      } else {
        buffer.write(char);
      }
    }
    return CipherOperationResult(output: buffer.toString());
  }
}
