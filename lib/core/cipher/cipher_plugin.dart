import 'package:flutter/material.dart';

import 'cipher_config.dart';
import 'cipher_operation_result.dart';

/// Contratto che ogni codifica/cifrario deve implementare per essere
/// registrato in [CipherRegistry] (vedi lib/bootstrap/plugin_registration.dart).
///
/// Non generica di proposito: una collezione eterogenea di
/// `CipherPlugin<T>` con T diversi per ogni plugin non è rappresentabile
/// in modo pulito in Dart. Ogni implementazione concreta fa un cast interno
/// sicuro sulla propria [CipherConfig], perché una config arriva a un plugin
/// solo tramite [defaultConfig], [configFromJson] o il proprio form di
/// configurazione.
abstract class CipherPlugin {
  /// Id stabile, usato per persistenza e lookup nel registry (es. "morse").
  String get id;

  String get displayName;

  String get shortDescription;

  IconData get icon;

  CipherConfig get defaultConfig;

  /// Costruisce la UI di configurazione specifica del cifrario (es. shift,
  /// alfabeto). Il core non conosce il contenuto di questo widget.
  Widget buildConfigForm(
    BuildContext context,
    CipherConfig config,
    ValueChanged<CipherConfig> onChanged,
  );

  CipherOperationResult encode(String plainText, CipherConfig config);

  CipherOperationResult decode(String cipherText, CipherConfig config);

  CipherConfig configFromJson(Map<String, dynamic> json);

  /// Costruisce la vista dell'output. Default: testo selezionabile. I
  /// plugin il cui output è pensato per essere "letto" visivamente più che
  /// come testo (es. Pigpen) possono sovrascriverlo con un rendering
  /// dedicato, senza che il core sappia nulla del contenuto.
  Widget buildOutputView(BuildContext context, String output) {
    return SelectableText(
      output.isEmpty ? '—' : output,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  /// True per i plugin il cui output è pensato per essere letto come
  /// immagine (es. Pigpen) piuttosto che come testo: esportare/condividere
  /// il testo grezzo di questi cifrari ne vanificherebbe la cifratura
  /// (che è puramente visiva), quindi export/condivisione devono usare il
  /// rendering di [buildOutputView] invece del testo. Il QR non è
  /// praticabile per questi plugin (poca capacità dati per un'immagine) e
  /// va nascosto in UI quando questo flag è true.
  bool get isVisualOutput => false;
}
