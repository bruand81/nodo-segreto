import '../core/cipher/cipher_plugin.dart';
import '../plugins/caesar/caesar_cipher_plugin.dart';
import '../plugins/morse/morse_cipher_plugin.dart';
import '../plugins/numeric/numeric_cipher_plugin.dart';
import '../plugins/pigpen/pigpen_cipher_plugin.dart';

/// Unico punto da toccare per aggiungere/rimuovere un cifrario dall'app.
List<CipherPlugin> buildRegisteredPlugins() => [
  MorseCipherPlugin(),
  CaesarCipherPlugin(),
  NumericCipherPlugin(),
  PigpenCipherPlugin(),
];
