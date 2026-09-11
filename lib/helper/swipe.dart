import '../constant/enum_file.dart';
import 'dart:ui';

/// Resolves a drag into the next snake direction.
///
/// [dragStart] is the touch-down point, [current] the live touch point.
/// No direction is returned until the drag travels past [threshold] on the
/// dominant axis; a 180° reversal into [currentDir] is refused.
Direct? resolveSwipe({
  required Offset dragStart,
  required Offset current,
  required Direct currentDir,
  required double threshold,
}) {
  final delta = current - dragStart;
  if (delta.dx.abs() < threshold && delta.dy.abs() < threshold) return null;
  if (delta.dx.abs() >= delta.dy.abs()) {
    if (delta.dx > 0 && currentDir != Direct.Left) return Direct.Right;
    if (delta.dx < 0 && currentDir != Direct.Right) return Direct.Left;
  } else {
    if (delta.dy > 0 && currentDir != Direct.Up) return Direct.Down;
    if (delta.dy < 0 && currentDir != Direct.Down) return Direct.Up;
  }
  return null;
}