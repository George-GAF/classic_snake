import 'package:classic_snake/model/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every reversible neon theme defines a distinct glow color', () {
    for (final c in appColorList) {
      expect(c.glowColor, isNot(Colors.black),
          reason: '${c.title} must define a glow color');
      expect(c.snakeColor, isNot(Colors.black),
          reason: '${c.title} must define a snake color');
      expect(c.foodColor, isNot(Colors.black),
          reason: '${c.title} must define a food color');
    }
  });
}