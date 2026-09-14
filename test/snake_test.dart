import 'package:classic_snake/constant/enum_file.dart';
import 'package:classic_snake/helper/snake.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    Manager.startGame();
  });

  group('Snake', () {
    test('starts at KSnakeStarting with Down direction', () {
      final snake = Snake();
      expect(snake.getBody(), [30, 50, 70, 90]);
      expect(snake.getDirect(), Direct.Down);
    });

    test('moving down advances one cell per row without wrap', () {
      final snake = Snake();
      snake.moving();
      expect(snake.getBody().last, 110);
    });

    test('leaving back for a tail on None/food events', () {
      final snake = Snake();
      snake.moving();
      expect(snake.eating(50, [], -1), FoodType.None);
      expect(snake.getBody().length, 4);
    });

    test('eating food grows without trimming', () {
      final snake = Snake();
      expect(snake.eating(90, [], -1), FoodType.Food);
      expect(snake.getBody().length, 4);
    });

    test('eating gift food is reported', () {
      final snake = Snake();
      expect(snake.eating(50, [90], -1), FoodType.GiftFood);
      expect(snake.getBody().length, 4);
    });

    test('eating special food trims the tail', () {
      final snake = Snake();
      expect(snake.eating(50, [], 90), FoodType.SFood);
      expect(snake.getBody().length, 3);
    });

    test('moving right wraps from last cell of a row to the next row start',
        () {
      final snake = Snake();
      ManageSnake(snake, _right, 9);
      expect(snake.getBody().last, 99);
      ManageSnake(snake, _right, 1);
      expect(snake.getBody().last, 80);
    });

    test('moving left wraps from first cell of a row to the previous row end',
        () {
      final snake = Snake();
      ManageSnake(snake, _left, 10);
      expect(snake.getBody().last, 80);
      ManageSnake(snake, _left, 1);
      expect(snake.getBody().last, 99);
    });

    test('moving up wraps around the top edge', () {
      final snake = Snake();
      ManageSnake(snake, _right, 9);
      ManageSnake(snake, _up, 6);
      expect(snake.getBody().last, 579);
    });

    test('moving down wraps around the bottom edge', () {
      final snake = Snake();
      ManageSnake(snake, _down, 26);
      expect(snake.getBody().last, 10);
    });

    test('dies on a block', () {
      final snake = Snake();
      ManageSnake(snake, _down, 1);
      expect(snake.isDie(false, [110]), isTrue);
    });

    test('dies on self collision', () {
      final snake = Snake();
      ManageSnake(snake, _right, 9);
      ManageSnake(snake, _up, 3);
      ManageSnake(snake, _left, 9);
      expect(snake.isDie(false, []), isTrue);
    });

    test('immortal bypasses death', () {
      final snake = Snake();
      ManageSnake(snake, _right, 9);
      ManageSnake(snake, _up, 3);
      ManageSnake(snake, _left, 9);
      expect(snake.isDie(true, []), isFalse);
    });

    test('not die when clear', () {
      final snake = Snake();
      ManageSnake(snake, _down, 1);
      expect(snake.isDie(false, []), isFalse);
    });
  });

  group('Snake input queue', () {
    test('refuses a 180 reversal into a queued turn', () {
      final snake = Snake(initial: Direct.Right);
      snake.setDirect(Direct.Up);
      snake.setDirect(Direct.Down);
      snake.moving();
      expect(snake.getDirect(), Direct.Up);
      expect(snake.getBody().last, 70);
    });

    test('two turns inside one tick are applied one per tick', () {
      final snake = Snake(initial: Direct.Right);
      snake.setDirect(Direct.Up);
      snake.setDirect(Direct.Left);
      expect(snake.getDirect(), Direct.Right);
      snake.moving();
      expect(snake.getDirect(), Direct.Up);
      snake.moving();
      expect(snake.getDirect(), Direct.Left);
    });

    test('drops the oldest queued input when the queue overflows', () {
      final snake = Snake(initial: Direct.Down);
      snake.setDirect(Direct.Right);
      snake.setDirect(Direct.Up);
      snake.setDirect(Direct.Left);
      snake.moving();
      expect(snake.getDirect(), Direct.Left);
    });
  });
}

enum _Dir { up, down, left, right }
const _up = _Dir.up;
const _down = _Dir.down;
const _left = _Dir.left;
const _right = _Dir.right;

void ManageSnake(Snake snake, _Dir dir, int times) {
  for (int i = 0; i < times; i++) {
    switch (dir) {
      case _Dir.up:
        snake.setDirect(Direct.Up);
        break;
      case _Dir.down:
        snake.setDirect(Direct.Down);
        break;
      case _Dir.left:
        snake.setDirect(Direct.Left);
        break;
      case _Dir.right:
        snake.setDirect(Direct.Right);
        break;
    }
    snake.moving();
  }
}