/// Cifrario pigpen: ogni lettera è rappresentata dalla porzione di griglia
/// (o dallo spicchio della "X") che la circonda, più un punto opzionale.
/// Vedi https://it.wikipedia.org/wiki/Cifrario_pigpen.
sealed class PigpenGlyph {
  const PigpenGlyph({required this.hasDot});

  final bool hasDot;
}

/// Lettere A-R: cella di una griglia 3x3 (tris). Ogni lato è disegnato solo
/// se corrisponde a una linea interna della griglia (non al bordo esterno).
class PigpenBoxGlyph extends PigpenGlyph {
  const PigpenBoxGlyph({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required super.hasDot,
  });

  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
}

enum PigpenWedgeDirection { top, right, bottom, left }

/// Lettere S-Z: spicchio della "X", delimitato dai due raggi diagonali
/// adiacenti alla direzione indicata.
class PigpenWedgeGlyph extends PigpenGlyph {
  const PigpenWedgeGlyph({required this.direction, required super.hasDot});

  final PigpenWedgeDirection direction;
}

/// Tabella A-Z generata dalle regole geometriche, non scritta a mano lettera
/// per lettera: evita 26 asset/costanti duplicate e possibili errori.
final Map<String, PigpenGlyph> pigpenGlyphTable = _buildPigpenGlyphTable();

Map<String, PigpenGlyph> _buildPigpenGlyphTable() {
  final table = <String, PigpenGlyph>{};

  const grid1 = 'ABCDEFGHI';
  const grid2 = 'JKLMNOPQR';
  for (final letters in [grid1, grid2]) {
    final hasDot = letters == grid2;
    for (var i = 0; i < letters.length; i++) {
      final row = i ~/ 3;
      final col = i % 3;
      table[letters[i]] = PigpenBoxGlyph(
        top: row > 0,
        bottom: row < 2,
        left: col > 0,
        right: col < 2,
        hasDot: hasDot,
      );
    }
  }

  const wedge1 = 'STUV';
  const wedge2 = 'WXYZ';
  const directions = [
    PigpenWedgeDirection.top,
    PigpenWedgeDirection.right,
    PigpenWedgeDirection.bottom,
    PigpenWedgeDirection.left,
  ];
  for (final letters in [wedge1, wedge2]) {
    final hasDot = letters == wedge2;
    for (var i = 0; i < letters.length; i++) {
      table[letters[i]] = PigpenWedgeGlyph(
        direction: directions[i],
        hasDot: hasDot,
      );
    }
  }

  return table;
}
