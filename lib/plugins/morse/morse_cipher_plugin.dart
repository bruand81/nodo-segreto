import 'package:flutter/material.dart';

import '../../core/cipher/cipher_config.dart';
import '../../core/cipher/cipher_operation_result.dart';
import '../../core/cipher/cipher_plugin.dart';
import 'morse_encoder.dart';

class MorseConfig extends CipherConfig {
  @override
  Map<String, dynamic> toJson() => {};
}

class MorseCipherPlugin extends CipherPlugin {
  @override
  String get id => 'morse';

  @override
  String get displayName => 'Morse';

  @override
  String get shortDescription =>
      'Sottoinsieme Morse non standard del gruppo: A-Z e 0-9 in punti/linee, '
      'separatori | e ||.';

  @override
  IconData get icon => Icons.graphic_eq;

  @override
  CipherConfig get defaultConfig => MorseConfig();

  @override
  Widget buildConfigForm(
    BuildContext context,
    CipherConfig config,
    ValueChanged<CipherConfig> onChanged,
  ) {
    return const SizedBox.shrink();
  }

  @override
  CipherOperationResult encode(String plainText, CipherConfig config) {
    return MorseEncoder.encode(plainText);
  }

  @override
  CipherOperationResult decode(String cipherText, CipherConfig config) {
    return MorseEncoder.decode(cipherText);
  }

  @override
  CipherConfig configFromJson(Map<String, dynamic> json) => MorseConfig();
}
