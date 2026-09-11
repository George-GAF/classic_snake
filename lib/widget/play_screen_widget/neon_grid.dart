import 'package:flutter/material.dart';

/// Faint neon grid lines behind the playfield.
class NeonGridPainter extends CustomPainter {
  final Color gridColor;
  final int columns;
  final int rows;

  NeonGridPainter(this.gridColor, this.columns, this.rows);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / columns;
    final paint = Paint()
      ..color = gridColor.withOpacity(.12)
      ..strokeWidth = 1;
    for (int c = 1; c < columns; c++) {
      final x = c * cell;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int r = 1; r < rows; r++) {
      final y = r * cell;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant NeonGridPainter old) {
    return old.gridColor != gridColor ||
        old.columns != columns ||
        old.rows != rows;
  }
}