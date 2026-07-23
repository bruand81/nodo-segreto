import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/plugins/pigpen/pigpen_glyph.dart';

void main() {
  group('pigpenGlyphTable', () {
    test('contiene tutte le 26 lettere', () {
      expect(
        pigpenGlyphTable.keys.toSet(),
        Set.from('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')),
      );
    });

    test(
      'E è il centro della prima griglia: tutti e 4 i lati, nessun punto',
      () {
        final glyph = pigpenGlyphTable['E']! as PigpenBoxGlyph;
        expect(glyph.top, isTrue);
        expect(glyph.bottom, isTrue);
        expect(glyph.left, isTrue);
        expect(glyph.right, isTrue);
        expect(glyph.hasDot, isFalse);
      },
    );

    test(
      'A è l\'angolo in alto a sinistra: solo basso e destra, nessun punto',
      () {
        final glyph = pigpenGlyphTable['A']! as PigpenBoxGlyph;
        expect(glyph.top, isFalse);
        expect(glyph.left, isFalse);
        expect(glyph.bottom, isTrue);
        expect(glyph.right, isTrue);
        expect(glyph.hasDot, isFalse);
      },
    );

    test('J ha la stessa forma di A ma con il punto (seconda griglia)', () {
      final a = pigpenGlyphTable['A']! as PigpenBoxGlyph;
      final j = pigpenGlyphTable['J']! as PigpenBoxGlyph;
      expect(j.top, a.top);
      expect(j.bottom, a.bottom);
      expect(j.left, a.left);
      expect(j.right, a.right);
      expect(a.hasDot, isFalse);
      expect(j.hasDot, isTrue);
    });

    test('S-V sono spicchi della X senza punto, W-Z con il punto', () {
      for (final letter in 'STUV'.split('')) {
        final glyph = pigpenGlyphTable[letter]! as PigpenWedgeGlyph;
        expect(glyph.hasDot, isFalse);
      }
      for (final letter in 'WXYZ'.split('')) {
        final glyph = pigpenGlyphTable[letter]! as PigpenWedgeGlyph;
        expect(glyph.hasDot, isTrue);
      }
      expect(
        (pigpenGlyphTable['S']! as PigpenWedgeGlyph).direction,
        PigpenWedgeDirection.top,
      );
      expect(
        (pigpenGlyphTable['V']! as PigpenWedgeGlyph).direction,
        PigpenWedgeDirection.left,
      );
    });
  });
}
