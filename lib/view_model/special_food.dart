import 'dart:math';

import '../constant/constant.dart';
import '../constant/game_values.dart';
import 'game_size.dart';
import 'manager.dart';
import 'sound_controller.dart';

class SpecialFood {
  SpecialFood();
  int? _giftBonus;
  static bool immortal = false;
  String _reward = '';

  String getRandomReward() {
    int index = Random().nextInt(23);
    if (index < 2) {
      _reward = _immortal();
    } else if (index == 2) {
      _reward = _gameOver();
    } else if (index < 7) {
      _reward = _increaseScore();
    } else if (index < 10) {
      _reward = _decreaseScore();
    } else if (index < 13) {
      _reward = _giftFoods();
    } else if (index < 17) {
      _reward = _increaseSpeed();
    } else if (index < 21) {
      _reward = _decreaseSpeed();
    } else if (index <= 23) {
      _reward = _changeColor();
    }
    restReward();
    return _reward;
  }

  String becomeImmortal() {
    _reward = _immortal();
    restReward();
    return _reward;
  }

  void restReward() {
    Future.delayed(Duration(seconds: Manager.seconds), () {
      _reward = '';
      immortal = false;
      Manager.giftFoods = [];
      Manager.timerSFRun = false;
      Manager.isSFoodEating = false;
      //Manager.gameScore = 0;
      Manager.seconds = 0;
      if (Manager.gameSpeed != KDefaultGameSpeed) {
        Manager.changeGameSpeed(KDefaultGameSpeed);
      }
      if (Manager.isMustChangeSnakeColor)
        Manager.isMustChangeSnakeColor = false;
    });
  }

  String _immortal() {
    Manager.seconds = 30;
    immortal = true;
    GameSound.playSoundEffect(KGoodLuckFileSound);
    return 'IMMORTAL';
  }



  String _increaseScore() {
    _giftBonus = 0;
    Manager.seconds = 1;
    _giftBonus = Random().nextInt(200) + 10;
    Manager.gameScore += _giftBonus!;
    GameSound.playSoundEffect(KGoodLuckFileSound);
    return 'Score Plus $_giftBonus';
  }

  String _decreaseScore() {
    _giftBonus = 0;
    Manager.seconds = 1;
    _giftBonus = -Random().nextInt(200) - 10;
    Manager.gameScore += _giftBonus!;
    GameSound.playSoundEffect(KBadLuckFileSound);
    return 'Score Minus $_giftBonus';
  }

  String _gameOver() {
    Manager.gameOver = true;
    return 'Game Over';
  }

  String _giftFoods() {
    Manager.seconds = 50;

    CreateGiftFoodIndex().fillList();
    GameSound.playSoundEffect(KGoodLuckFileSound);
    return 'More Food';
  }

  String _increaseSpeed() {
    Manager.seconds = 55;
    Manager.changeGameSpeed(KDefaultGameSpeed - (Random().nextInt(50) + 40));
    GameSound.playSoundEffect(KBadLuckFileSound);
    return 'Increase Speed';
  }

  String _decreaseSpeed() {
    Manager.seconds = 55;
    Manager.changeGameSpeed(KDefaultGameSpeed + (Random().nextInt(50) + 40));
    GameSound.playSoundEffect(KGoodLuckFileSound);
    return 'Decrease Speed';
  }

  String _changeColor() {
    Manager.seconds = 15;
    Manager.isMustChangeSnakeColor = true;
    GameSound.playSoundEffect(KGoodLuckFileSound);
    return 'Change Color';
  }
}

class CreateGiftFoodIndex {
  void fillList() {
    int len = Random().nextInt(20) + 10;
    for (int i = 0; i < len; i++) {
      int value = 0;
      while (!_isValueOk(value)) {
        value = Random().nextInt(GameSize.boxCount());
      }
      Manager.giftFoods.add(value);
    }
  }

  bool _isValueOk(int value) {
    if (Manager.giftFoods.contains(value) ||
        Manager.snake.contains(value) ||
        value == Manager.food) return false;

    /*
    else if (GameSize.blockIndex.contains(value))
      return false;
    else if (Manager.snakeBody.contains(value))
      return false;
    else if (Manager.snakeFood == value) return false;*/
    return true;
  }
}
