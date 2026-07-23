import '../../core/cipher/cipher_config.dart';
import 'caesar_alphabets.dart';

class CaesarConfig extends CipherConfig {
  const CaesarConfig({required this.shift, required this.alphabet})
    : assert(shift > 0, 'Lo spostamento deve essere un intero positivo');

  final int shift;
  final CaesarAlphabetMode alphabet;

  CaesarConfig copyWith({int? shift, CaesarAlphabetMode? alphabet}) {
    return CaesarConfig(
      shift: shift ?? this.shift,
      alphabet: alphabet ?? this.alphabet,
    );
  }

  @override
  Map<String, dynamic> toJson() => {'shift': shift, 'alphabet': alphabet.name};

  factory CaesarConfig.fromJson(Map<String, dynamic> json) {
    return CaesarConfig(
      shift: json['shift'] as int,
      alphabet: CaesarAlphabetMode.values.byName(json['alphabet'] as String),
    );
  }
}
