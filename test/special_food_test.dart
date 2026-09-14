import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:classic_snake/view_model/sound_controller.dart';
import 'package:classic_snake/view_model/special_food.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    GameSound.soundON = false;
    Manager.startGame();
    Manager.giftFoods = [];
    Manager.snake = [];
    Manager.food = 0;
  });

  group('SpecialFood', () {
    test('becomeImmortal grants 30s of immortality', () {
      final food = SpecialFood();
      SpecialFood.immortal = false;
      expect(food.becomeImmortal(), 'IMMORTAL');
      expect(SpecialFood.immortal, isTrue);
      expect(Manager.seconds, 30);
    });

    test('getRandomReward always returns a known reward string', () {
      const known = [
        'IMMORTAL',
        'Game Over',
        'Score Plus',
        'Score Minus',
        'More Food',
        'Increase Speed',
        'Decrease Speed',
        'Change Color',
      ];
      for (int i = 0; i < 40; i++) {
        final reward = SpecialFood().getRandomReward();
        expect(known.any((k) => reward.startsWith(k)), isTrue,
            reason: reward);
        expect(reward.trim(), isNotEmpty);
      }
    });
  });

  group('CreateGiftFoodIndex', () {
    test('fillList creates valid gift food indices', () {
      CreateGiftFoodIndex().fillList();
      expect(Manager.giftFoods.length, inInclusiveRange(10, 30));
      for (final value in Manager.giftFoods) {
        expect(value, inInclusiveRange(0, GameSize.boxCount() - 1));
        expect(value, isNot(Manager.food));
        expect(Manager.snake.contains(value), isFalse);
      }
      expect(Manager.giftFoods.toSet().length, Manager.giftFoods.length);
    });
  });
}