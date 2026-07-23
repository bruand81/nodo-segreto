import 'package:flutter/material.dart';

import '../../core/cipher/cipher_config.dart';
import '../../core/cipher/cipher_operation_result.dart';
import '../../core/cipher/cipher_plugin.dart';
import 'caesar_alphabets.dart';
import 'caesar_config.dart';
import 'caesar_config_form.dart';
import 'caesar_encoder.dart';

class CaesarCipherPlugin extends CipherPlugin {
  @override
  String get id => 'caesar';

  @override
  String get displayName => 'Cifrario di Cesare';

  @override
  String get shortDescription =>
      'Sostituzione a spostamento fisso, con alfabeto italiano o inglese e '
      'chiave di decifratura in coda al messaggio.';

  @override
  IconData get icon => Icons.rotate_right;

  @override
  CipherConfig get defaultConfig =>
      const CaesarConfig(shift: 3, alphabet: CaesarAlphabetMode.english);

  @override
  Widget buildConfigForm(
    BuildContext context,
    CipherConfig config,
    ValueChanged<CipherConfig> onChanged,
  ) {
    return CaesarConfigForm(
      config: config as CaesarConfig,
      onChanged: onChanged,
    );
  }

  @override
  CipherOperationResult encode(String plainText, CipherConfig config) {
    return CaesarEncoder.encode(plainText, config as CaesarConfig);
  }

  @override
  CipherOperationResult decode(String cipherText, CipherConfig config) {
    return CaesarEncoder.decode(cipherText, config as CaesarConfig);
  }

  @override
  CipherConfig configFromJson(Map<String, dynamic> json) =>
      CaesarConfig.fromJson(json);
}
