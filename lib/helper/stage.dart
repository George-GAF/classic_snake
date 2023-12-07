import 'dart:async';
import 'dart:math';

import 'package:classic_snake/model/level_model.dart';

import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../view_model/special_food.dart';

class Stage {
  late int food;
  late int sFood;
  late String reward;
  late LevelModel level;
  bool timerStart = false;

  int sec = 0;
  static int bonus = 0;

  Stage();
  Stage.withLevel(LevelModel level) {
    this.level = level;
    Manager.blocks = this.level.blocks!;
  }

  String getStageTitle() {
    int rank = level.rank;
    return rank == 0
        ? 'Survival'
        : rank == 999
            ? 'Custom Level'
            : '$rank';
  }

//TODO : test score to run sound
//TODO : Game State over pause restart

  void createFood(List<int> snakeBody, List<int> giftFood) {
    while (snakeBody.contains(food) ||
        level.blocks!.contains(food) ||
        giftFood.contains(food)) {
      food = Random().nextInt(GameSize.boxCount() - 1);
    }
    Manager.food = food;
  }

  void eatingGiftFood(giftFood) {
    Manager.giftFoods.remove(giftFood);
  }

  void eatingSFood() {
    sFood = GameSize.boxCount() + 1;
    reward = SpecialFood().getRandomReward();
    getRestTime();
  }

  int getScore(int snakeLen) {
    int _score = ((snakeLen - 4) * 10) + bonus;
    _score = _score < 0 ? 0 : _score;
    _score += Manager.bonus;
    return _score;
  }

  //---------------------------------------------------------------------
  // helper
  void getRestTime() {
    if (reward != '' && !timerStart) {
      Duration dur = Duration(seconds: 1);
      Timer.periodic(dur, (timer) {
        if (sec > 0) {
          --sec;
          Manager.seconds = sec;
        } else {
          timer.cancel();
          timerStart = false;
          reward = '';
          sec = 0;
          Manager.seconds = sec;
        }
      });
    }
  }
}
