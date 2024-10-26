import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../constant/enum_file.dart';
import '../constant/game_values.dart';
import '../helper/snake.dart';
import '../helper/stage.dart';
import '../model/level_model.dart';
import '../view_model/game_size.dart';
import '../view_model/level_controller.dart';
import '../view_model/manager.dart';
import '../view_model/sound_controller.dart';
import '../view_model/special_food.dart';
import '../view_model/timer_controller.dart';

class StagePlay extends ChangeNotifier {
  Snake? snake;
  Stage? stage;
  LevelModel? level;
  LevelController? controller;
  CellType? cellType;

  bool showMenu = false;
  bool showTapMassage = true;
  int _hScore = 0;

  bool _targetBroken = false;
  bool _hScoreBroken = false;
  bool _isAskedToMoveToNextLevel = false;
  bool showAskMenu = false;

  late Timer gameTimer;

  void gamePlay() {
    Duration duration = Duration(milliseconds: KDefaultGameSpeed);
    gameTimer = Timer.periodic(duration, (timer) {
      if (Manager.gameOver || Manager.isPause || Manager.isChangeGameSpeed) {
        timer.cancel();
        if (gameTimer.isActive) gameTimer.cancel();
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

  bool isTargetBroken() {
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
/*
  void setCellType(int i) {
    // dev.log('from setCellType ${level.toString()}');
    final tS = snake!.getBody();
    cellType = CellType.Ground;
    if (level!.blocks!.contains(i)) {
      cellType = CellType.Block;
    } else if (tS.contains(i)) {
      cellType = CellType.Snake;
    } else if (stage!.food == i) {
      cellType = CellType.Food;
    } else if (stage!.sFood == i) {
      cellType = CellType.SpecialFood;
    } else if (Manager.giftFoods.contains(i)) cellType = CellType.Food;
  }*/

  void readHScore(int hScore) {
    _hScore = hScore;
  }

  Direct getDirect() {
    return snake!.getDirect();
  }

  void changeDirect(Direct direct) {
    snake!.setDirect(direct);
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

  void _eating() {
    FoodType type = snake!.eating(stage!.food, Manager.giftFoods, stage!.sFood);
    switch (type) {
      case FoodType.None:
        break;
      case FoodType.Food || FoodType.GiftFood:
        GameSound.playSoundEffect(KEatFileSound);
        stage!.addScore();
        testingScoreAndHScore();
        if (type == FoodType.Food) {
          stage!.createFood(snake!.getBody(), Manager.giftFoods);
          break;
        } else if (type == FoodType.GiftFood) {
          stage!.eatingGiftFood(snake!.getBody().last);
          break;
        }
      case FoodType.SFood:
        stage!.eatingSFood();
        testingScoreAndHScore();
        break;
    }
  }

  int stageCurrentScore() {
    Manager.gameScore = Manager.gameScore < 0 ? 0 : Manager.gameScore;
    return Manager.gameScore;
  }

  void testingScoreAndHScore() {
    int _score = stageCurrentScore();
    if (_score >= level!.targetScore! && !_targetBroken) {
      _targetBroken = true;
      controller!.setLevelState();
      GameSound.playSoundEffect(KTargetDoneFileSound);
      if (!_isAskedToMoveToNextLevel) {
        _askToMoveToNextLevel();
      }
    }
    if (_score >= _hScore) {
      controller!.setLevelHighScore(_score);
      if (!_hScoreBroken) {
        _hScoreBroken = true;
        GameSound.playSoundEffect(KHeightScoreBreakFileSound);
      }
    }
  }

  void _askToMoveToNextLevel() {
    _isAskedToMoveToNextLevel = true;
    if (level!.rank != 0 &&
        level!.rank != 999 &&
        level!.rank != levelList[levelList.length - 2].rank) {
      showMenu = true;
      showAskMenu = true;
      //--------------------------------------------
      Manager.isPause = true;
      GameTimer.manageTimer();
      //---------------------------------------------
      notifyListeners();
    }
  }

  void checkAvailabilityForSpecialFood() {
    if (!Manager.timerSFRun) {

      Manager.timerSFRun = true;
      Future.delayed(Duration(seconds: Random().nextInt(30) + 60), () {
        _showSpecialFood();
        // Manager.timerSFRun = false;
      });
    }
  }

  void _showSpecialFood() {
    if (!Manager.restartPressed) {
      if (!Manager.isPause) {
        while (snake!.getBody().contains(stage!.sFood) ||
            level!.blocks!.contains(stage!.sFood) ||
            stage!.sFood == stage!.food ||
            stage!.sFood == GameSize.boxCount() + 1 ||
            Manager.giftFoods.contains(stage!.sFood)) {
          stage!.sFood = Random().nextInt(GameSize.boxCount() - 1);
          Future.delayed(Duration(seconds: 15), () {
            if (!Manager.isSFoodEating) {
              stage!.sFood = GameSize.boxCount() + 1;
              Manager.timerSFRun = false;
            }
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

  void start(int levelID) {
    Manager.startGame();
    Manager.currentStageID = levelID;
    level = levelList[levelID];
    print('id = $levelID level detail ${level.toString()}');
    controller = new LevelController(level!.rank!);
    snake = new Snake();
    stage = new Stage(level!);
    _hScore = 0;
    _targetBroken = false;
    _hScoreBroken = false;
    showTapMassage = true;
    showMenu = false;
    _isAskedToMoveToNextLevel = false;
    showAskMenu = false;
    notifyListeners();
  }

  void endGame() {
    gameTimer.cancel();
    Manager.endGame();
    notifyListeners();
  }
}
