import 'package:flutter/material.dart';

import '../../core/cipher/cipher_config.dart';
import '../../core/cipher/cipher_operation_result.dart';
import '../../core/cipher/cipher_plugin.dart';
import 'pigpen_encoder.dart';
import 'pigpen_glyph.dart';
import 'pigpen_glyph_painter.dart';

class PigpenConfig extends CipherConfig {
  const PigpenConfig();

  @override
  Map<String, dynamic> toJson() => {};
}

class PigpenCipherPlugin extends CipherPlugin {
  @override
  String get id => 'pigpen';

  @override
  String get displayName => 'Pigpen';

  @override
  String get shortDescription =>
      'Ogni lettera diventa un simbolo grafico (griglia o "X"), con un '
      'punto per distinguere le lettere che condividono la stessa forma.';

  @override
  IconData get icon => Icons.grid_view;

  @override
  CipherConfig get defaultConfig => const PigpenConfig();

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
    return PigpenEncoder.normalize(plainText);
  }

  @override
  CipherOperationResult decode(String cipherText, CipherConfig config) {
    return PigpenEncoder.normalize(cipherText);
  }

  @override
  CipherConfig configFromJson(Map<String, dynamic> json) =>
      const PigpenConfig();

  @override
  bool get isVisualOutput => true;

  @override
  Widget buildOutputView(BuildContext context, String output) {
    if (output.isEmpty) {
      return Text('—', style: Theme.of(context).textTheme.bodyLarge);
    }

    final children = <Widget>[];
    var i = 0;
    while (i < output.length) {
      final char = output[i];
      final glyph = pigpenGlyphTable[char];
      if (glyph != null) {
        final hasAccentMarker = i + 1 < output.length && output[i + 1] == "'";
        children.add(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PigpenGlyphView(glyph: glyph),
              if (hasAccentMarker)
                const Text("'", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
        i += hasAccentMarker ? 2 : 1;
      } else if (char == ' ') {
        children.add(const SizedBox(width: 24));
        i++;
      } else {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(char, style: Theme.of(context).textTheme.titleLarge),
          ),
        );
        i++;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surface,
      child: Wrap(
        spacing: 6,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ),
    );
  }
}
