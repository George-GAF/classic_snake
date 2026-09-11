import 'package:classic_snake/constant/enum_file.dart';
import 'package:classic_snake/helper/swipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const t = 5.0;

  group('resolveSwipe', () {
    test('returns null below threshold', () {
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(3, 4),
          currentDir: Direct.Right,
          threshold: t,
        ),
        isNull,
      );
    });

    test('horizontal drag past threshold steers right', () {
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(20, 2),
          currentDir: Direct.Up,
          threshold: t,
        ),
        Direct.Right,
      );
    });

    test('dominant axis wins on diagonal', () {
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(50, 3),
          currentDir: Direct.Up,
          threshold: t,
        ),
        Direct.Right,
      );
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(2, 40),
          currentDir: Direct.Left,
          threshold: t,
        ),
        Direct.Down,
      );
    });

    test('refuses 180 degree reversal', () {
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(30, 0),
          currentDir: Direct.Left,
          threshold: t,
        ),
        isNull,
      );
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(0, -40),
          currentDir: Direct.Down,
          threshold: t,
        ),
        isNull,
      );
    });

    test('opposite axis while holding a turn still fires correctly', () {
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(30, 6),
          currentDir: Direct.Up,
          threshold: t,
        ),
        Direct.Right,
      );
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(4, -30),
          currentDir: Direct.Left,
          threshold: t,
        ),
        Direct.Up,
      );
    });

    test('small opposite-axis slop does not cancel a clear steer', () {
      expect(
        resolveSwipe(
          dragStart: const Offset(0, 0),
          current: const Offset(25, -10),
          currentDir: Direct.Up,
          threshold: t,
        ),
        Direct.Right,
      );
    });
  });
}