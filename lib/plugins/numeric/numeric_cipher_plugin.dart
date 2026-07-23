import 'package:flutter/material.dart';

import '../../core/cipher/cipher_config.dart';
import '../../core/cipher/cipher_operation_result.dart';
import '../../core/cipher/cipher_plugin.dart';
import 'numeric_config.dart';
import 'numeric_config_form.dart';
import 'numeric_encoder.dart';

class NumericCipherPlugin extends CipherPlugin {
  @override
  String get id => 'numeric';

  @override
  String get displayName => 'Sostituzione numerica';

  @override
  String get shortDescription =>
      'Ogni lettera diventa un numero secondo una chiave base (A=1 o shift), '
      'circolare o lineare, con chiave di decifratura in coda al messaggio.';

  @override
  IconData get icon => Icons.pin_outlined;

  @override
  CipherConfig get defaultConfig => const NumericConfig(
    baseValueForA: 1,
    shiftMode: NumericShiftMode.circular,
  );

  @override
  Widget buildConfigForm(
    BuildContext context,
    CipherConfig config,
    ValueChanged<CipherConfig> onChanged,
  ) {
    return NumericConfigForm(
      config: config as NumericConfig,
      onChanged: onChanged,
    );
  }

  @override
  CipherOperationResult encode(String plainText, CipherConfig config) {
    return NumericEncoder.encode(plainText, config as NumericConfig);
  }

  @override
  CipherOperationResult decode(String cipherText, CipherConfig config) {
    return NumericEncoder.decode(cipherText, config as NumericConfig);
  }

  @override
  CipherConfig configFromJson(Map<String, dynamic> json) =>
      NumericConfig.fromJson(json);
}
