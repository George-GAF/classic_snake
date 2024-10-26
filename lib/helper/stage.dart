import 'dart:async';
import 'dart:math';

import '../constant/game_values.dart';
import '../model/level_model.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../view_model/special_food.dart';

class Stage {
  late LevelModel level;
  int food = 0;
  int sFood = GameSize.boxCount() + 1;
  String reward = '';

  bool timerStart = false;

  int sec = 0;

  Stage(LevelModel level) {
    this.level = level;
    Manager.blocks = this.level.blocks!;
    createFood(KSnakeStarting, [0]);
  }

  String toString() {
    return 'level ${this.level.toString()} rank level ${level.rank} blocks ${this.level.blocks} state ${level.enable}}';
  }

  String getStageTitle() {
    int rank = level.rank!;
    return rank == 0
        ? 'Survival'
        : rank == 999
            ? 'Custom Level'
            : '$rank';
  }

  void createFood(List<int> snakeBody, List<int> giftFood) {
    while (snakeBody.contains(food) ||
        level.blocks!.contains(food) ||
        giftFood.contains(food)) {
      food = Random().nextInt(GameSize.boxCount() - 1);

    }

    Manager.food = food;
  }

  void addScore() {
    Manager.gameScore += KEatScoreValue;
  }

  void eatingGiftFood(int giftFood) {
    Manager.giftFoods.remove(giftFood);
  }

  void eatingSFood() {
    Manager.isSFoodEating = true;
    sFood = GameSize.boxCount() + 1;
    reward = SpecialFood().getRandomReward();
    sec = Manager.seconds;
    getRestTime();
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
          Manager.seconds = 0;
        }
      });
    }
  }
}
