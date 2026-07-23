import 'package:diacritic/diacritic.dart';

class ExpandedChar {
  const ExpandedChar({required this.base, required this.wasAccented});

  final String base;
  final bool wasAccented;
}

/// Regola condivisa da tutti i cifrari: una lettera accentata (qualsiasi
/// accento) va trattata come la lettera base senza accento.
class AccentUtils {
  const AccentUtils._();

  static ExpandedChar expandChar(String char) {
    final stripped = removeDiacritics(char);
    return ExpandedChar(base: stripped, wasAccented: stripped != char);
  }
}
