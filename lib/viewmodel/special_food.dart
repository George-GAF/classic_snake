import 'dart:math';

import 'package:flutter/foundation.dart';

import '../constant/constant.dart';
import '../screen/play_screen.dart';
import 'game_size.dart';
import 'manager.dart';
import 'sound_controller.dart';

class SpecialFood extends ChangeNotifier {
  SpecialFood();

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
      Manager.giftFood = [];
      // Manager.bonus = 0;
      Manager.seconds = 0;
      if (Manager.gameSpeed != Manager.defaultLevelGameSpeed) {
        PlayScreen.assManager.changeGameSpeed(Manager.defaultLevelGameSpeed);
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

  int? _giftBonus;

  String _increaseScore() {
    Manager.seconds = 1;
    _giftBonus = Random().nextInt(200) + 10;
    Manager.bonus += _giftBonus!;
    GameSound.playSoundEffect(KGoodLuckFileSound);
    return 'Score Plus $_giftBonus';
  }

  String _decreaseScore() {
    Manager.seconds = 1;
    _giftBonus = -Random().nextInt(200) - 10;
    Manager.bonus += _giftBonus!;
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
    PlayScreen.assManager.changeGameSpeed(
        Manager.defaultLevelGameSpeed - (Random().nextInt(50) + 40));
    GameSound.playSoundEffect(KBadLuckFileSound);
    return 'Increase Speed';
  }

  String _decreaseSpeed() {
    Manager.seconds = 55;
    PlayScreen.assManager.changeGameSpeed(
        Manager.defaultLevelGameSpeed + (Random().nextInt(50) + 40));
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
      Manager.giftFood.add(value);
    }
  }

  bool _isValueOk(int value) {
    if (Manager.giftFood.contains(value))
      return false;
    else if (GameSize.blockIndex.contains(value))
      return false;
    else if (Manager.snakeIndex.contains(value))
      return false;
    else if (Manager.snakeFood == value) return false;
    return true;
  }
}
