import '../../core/cipher/cipher_config.dart';

enum NumericShiftMode { circular, linear }

/// Config del cifrario a sostituzione numerica.
///
/// [baseValueForA] è il numero assegnato alla lettera A (1 per la chiave
/// standard, o un valore maggiore per uno shift, es. 3 -> A=3, B=4, ...).
/// [demoNumber] è il numero che l'utente sceglie di mostrare nella chiave
/// finale (formato "N -> Lettera"), come richiesto da istruzioni.md.
class NumericConfig extends CipherConfig {
  const NumericConfig({
    required this.baseValueForA,
    required this.shiftMode,
    this.demoNumber,
  }) : assert(baseValueForA > 0, 'Il valore base di A deve essere positivo');

  final int baseValueForA;
  final NumericShiftMode shiftMode;

  /// Se null, l'encoder usa un default deterministico (il numero della
  /// prima lettera alfabetica del messaggio).
  final int? demoNumber;

  NumericConfig copyWith({
    int? baseValueForA,
    NumericShiftMode? shiftMode,
    int? demoNumber,
  }) {
    return NumericConfig(
      baseValueForA: baseValueForA ?? this.baseValueForA,
      shiftMode: shiftMode ?? this.shiftMode,
      demoNumber: demoNumber ?? this.demoNumber,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'baseValueForA': baseValueForA,
    'shiftMode': shiftMode.name,
    'demoNumber': demoNumber,
  };

  factory NumericConfig.fromJson(Map<String, dynamic> json) {
    return NumericConfig(
      baseValueForA: json['baseValueForA'] as int,
      shiftMode: NumericShiftMode.values.byName(json['shiftMode'] as String),
      demoNumber: json['demoNumber'] as int?,
    );
  }
}
