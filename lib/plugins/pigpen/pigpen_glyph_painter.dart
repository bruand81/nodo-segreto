import 'package:flutter/material.dart';

import 'pigpen_glyph.dart';

class PigpenGlyphView extends StatelessWidget {
  const PigpenGlyphView({
    super.key,
    required this.glyph,
    this.size = 40,
    this.color,
  });

  final PigpenGlyph glyph;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PigpenGlyphPainter(glyph, resolvedColor)),
    );
  }
}

class _PigpenGlyphPainter extends CustomPainter {
  _PigpenGlyphPainter(this.glyph, this.color);

  final PigpenGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide * 0.08
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final glyphValue = glyph;

    switch (glyphValue) {
      case PigpenBoxGlyph box:
        if (box.top) canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
        if (box.bottom) canvas.drawLine(Offset(0, h), Offset(w, h), paint);
        if (box.left) canvas.drawLine(Offset(0, 0), Offset(0, h), paint);
        if (box.right) canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
      case PigpenWedgeGlyph wedge:
        final center = Offset(w / 2, h / 2);
        final topLeft = const Offset(0, 0);
        final topRight = Offset(w, 0);
        final bottomLeft = Offset(0, h);
        final bottomRight = Offset(w, h);
        switch (wedge.direction) {
          case PigpenWedgeDirection.top:
            canvas.drawLine(topLeft, center, paint);
            canvas.drawLine(topRight, center, paint);
          case PigpenWedgeDirection.right:
            canvas.drawLine(topRight, center, paint);
            canvas.drawLine(bottomRight, center, paint);
          case PigpenWedgeDirection.bottom:
            canvas.drawLine(bottomLeft, center, paint);
            canvas.drawLine(bottomRight, center, paint);
          case PigpenWedgeDirection.left:
            canvas.drawLine(topLeft, center, paint);
            canvas.drawLine(bottomLeft, center, paint);
        }
    }

    if (glyphValue.hasDot) {
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(w / 2, h / 2),
        size.shortestSide * 0.07,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PigpenGlyphPainter oldDelegate) {
    return oldDelegate.glyph != glyph || oldDelegate.color != color;
  }
}
