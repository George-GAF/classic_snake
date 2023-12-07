import 'dart:async';
import 'dart:math';

import 'package:classic_snake/constant/game_values.dart';
import 'package:classic_snake/model/level_model.dart';
import 'package:classic_snake/view_model/level_controller.dart';
import 'package:classic_snake/view_model/special_food.dart';
import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../constant/enum_file.dart';
import '../helper/snake.dart';
import '../helper/stage.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../view_model/sound_controller.dart';

class StagePlay extends ChangeNotifier {
  late final Snake? snake;
  late final Stage? stage;
  late final LevelModel? level;
  late final LevelController? controller;
  late CellType cellType;

  bool showMenu = false;
  bool showTapMassage = true;
  int _hScore = 0;

  bool _targetBroken = false;
  bool _hScoreBroken = false;

  void gamePlay() {
    Duration duration = Duration(milliseconds: KDefaultGameSpeed);
    Timer.periodic(duration, (timer) {
      if (Manager.gameOver || Manager.isPause || Manager.isChangeGameSpeed) {
        timer.cancel();
        if (Manager.isChangeGameSpeed) {
          duration = Duration(milliseconds: Manager.gameSpeed);
          gamePlay();
          Manager.isChangeGameSpeed = false;
        }
      } else {
        snake!.moving();
        _isaLife();
        _eating();
        checkAvailabilityForSpecialFood();
      }
      notifyListeners();
    });
  }

  bool isTargetBroken(){
    return _targetBroken;
  }

  void hideTapMassage() {
    showTapMassage = false;
    notifyListeners();
  }

  void setMenuState({bool refresh = true}) {
    showMenu = Manager.gameOver || Manager.isPause;
    if (refresh) notifyListeners();
  }

  void setCellType(int i) {
    final tS = snake!.body;
    cellType = CellType.Ground;
    if (level!.blocks!.contains(i)) {
      cellType = CellType.Block;
    } else if (tS.contains(i)) {
      cellType = CellType.Snake;
      cellType = i == tS.last
          ? CellType.Head
          : i == tS.first
              ? CellType.Tail
              : CellType.Snake;
    } else if (stage!.food == i) {
      cellType = CellType.Food;
    } else if (stage!.sFood == i) {
      cellType = CellType.SpecialFood;
    } else if (Manager.giftFoods.contains(i)) cellType = CellType.GiftFood;
  }

  void readHScore(int hScore) {
    _hScore = hScore;
  }

  Direct getDirect() {
    return snake!.currentDir;
  }

  void changeDirect(Direct direct) {
    /*if (snake!.currentDir == direct) return;
    int dif = snake!.currentDir.index - direct.index;
    if (dif == -2 || dif == 2) return;
    // 0 - 2 = -2  1 - 3 = -3*/
    snake!.currentDir = direct;
    notifyListeners();
  }

  void _isaLife() {
    Manager.requestLife = snake!.isDie(SpecialFood.immortal, level!.blocks!);
    if (Manager.requestLife) {
      if (Manager.isExtraLifeTaken) {
        Manager.gameOver = true;
        Manager.requestLife = false;
      } else {
        Manager.isPause = true;
      }
    }
    if (Manager.gameOver) GameSound.playSoundEffect(KGameOverFileSound);
  }

  void _eating() async {
    FoodType type = snake!.eating(stage!.food, Manager.giftFoods, stage!.sFood);
    switch (type) {
      case FoodType.None:
        break;
      case FoodType.Food || FoodType.GiftFood:
        GameSound.playSoundEffect(KEatFileSound);
        testingScoreAndHScore();
        if (type == FoodType.Food) {
          stage!.createFood(snake!.body, Manager.giftFoods);
          break;
        } else if (type == FoodType.GiftFood) {
          stage!.eatingGiftFood(Manager.giftFoods);
          break;
        }
      case FoodType.SFood:
        stage!.eatingSFood();
        break;
    }
  }

  int stageCurrentScore(){
    return stage!.getScore(snake!.body.length);
  }

  void testingScoreAndHScore() {
    int _score = stageCurrentScore();
    if (_score >= level!.targetScore || !_targetBroken) {
      _targetBroken = true;
      controller!.setLevelState();
      GameSound.playSoundEffect(KTargetDoneFileSound);
    }
    if (_score >= _hScore || !_hScoreBroken) {
      _targetBroken = true;
      GameSound.playSoundEffect(KHeightScoreBreakFileSound);
    }
  }

  void checkAvailabilityForSpecialFood() {
    if (!Manager.timerSFRun) {
      Manager.timerSFRun = true;
      int _seconds = Random().nextInt(30) + 60;
      Duration _duration = Duration(seconds: _seconds);
      Future.delayed(_duration, () {
        _showSpecialFood();
        Manager.timerSFRun = false;
      });
    }
  }

  void _showSpecialFood() {
    if (!Manager.restartPressed) {
      if (!Manager.isPause) {
        while (snake!.body.contains(stage!.sFood) ||
            level!.blocks!.contains(stage!.sFood) ||
            stage!.sFood == stage!.food ||
            Manager.giftFoods.contains(stage!.sFood)) {
          stage!.sFood = Random().nextInt(GameSize.boxCount() - 1);
          Future.delayed(Duration(seconds: 15), () {
            stage!.sFood = GameSize.boxCount() + 1;
          });
        }
      }
    } else {
      Manager.restartPressed = false;
    }
  }

  void giveExtraLife() {
    stage!.reward = SpecialFood().becomeImmortal();
    stage!.getRestTime();
    notifyListeners();
  }

  void start(LevelModel level) {
    Manager.startGame();
    snake = Snake();
    stage = Stage();
    this.level = level;
    controller = LevelController(level.rank);
    _hScore = 0;
    _targetBroken = false;
    _hScoreBroken = false;
    stage!.createFood(snake!.body, Manager.giftFoods);
    notifyListeners();
  }

  void endGame() {
    Manager.endGame();
    snake = null;
    stage = null;
    level = null;
    controller = null;
    showTapMassage = true;

    notifyListeners();
  }
}
