import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../constant/enum_file.dart';
import 'game_size.dart';
import 'manager.dart';
import 'sound_controller.dart';
import 'special_food.dart';
import 'timer_controller.dart';

class Snake extends ChangeNotifier {
  CellType cellType = CellType.Ground;
  CellType? snakeDetail;

  void setCellType(int i) {
    cellType = CellType.Ground;
    if (GameSize.blockIndex.contains(i)) {
      cellType = CellType.Block;
    } else if (snakePosition.contains(i)) {
      cellType = CellType.Snake;
      snakeDetail = i == snakePosition.last
          ? CellType.Head
          : i == snakePosition.first
              ? CellType.Tail
              : CellType.Snake;
    } else if (food == i) {
      cellType = CellType.Food;
    } else if (sFood == i) {
      cellType = CellType.SpecialFood;
    } else if (Manager.giftFood.contains(i)) cellType = CellType.GiftFood;
  }

//-----------------------Game Provider ------------------------
  Color? currentColor;
  bool showMenu = false;
  bool showTapMassage = true;

  void hideTapMassage() {
    showTapMassage = false;
    notifyListeners();
  }

  void setMenuState({bool refresh = true}) {
    showMenu = Manager.gameOver || Manager.isPause;
    if (refresh) notifyListeners();
  }

  int _score = 0;

  int getScore() {
    _score = ((snakePosition.length - 4) * 10) + Manager.bonus;
    _score = _score < 0 ? 0 : _score;
    return _score;
  }

  void restGame() {
    GameTimer.manageTimer();
    _score = 0;
    Manager.gameOver = false;
    Manager.gameRun = false;
    Manager.moveNow = false;
    Manager.requestLife = false;
    Manager.isExtraLifeTaken = false;
    Manager.isChangeGameSpeed = false;
    showTapMassage = true;
    Manager.seconds = 0;
    Manager.bonus = 0;
    Manager.giftFood = [];
    Manager.gameSpeed = 300;
    Manager.defaultLevelGameSpeed = 300;
    reward = '';
    sec = 0;
    snakePosition = [30, 50, 70, 90];
    Manager.snakeIndex = snakePosition;
    food = GameSize.boxCount() + 1;
    sFood = GameSize.boxCount() + 1;
    direct = Direct.Down;
    createFood();
  }

  bool isGameOver() {
    if (Manager.gameOver) {
      //Manager.gameRun = false;
      GameTimer.manageTimer();
      return true;
    }
    if (SpecialFood.immortal) {
      return false;
    }
    if (GameSize.blockIndex.contains(snakePosition.last)) {
      //Manager.gameRun = false;
      GameTimer.manageTimer();
      return true;
    }
    for (int i = 0; i < snakePosition.length; i++) {
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j] && i != j) {
          //  Manager.gameRun = false;
          GameTimer.manageTimer();
          return true;
        }
      }
    }
    return false;
  }

//----------------------------------------------------
  //--------------------------------  food Controller
  int? food;

  void createFood() {
    while (snakePosition.contains(food) ||
        GameSize.blockIndex.contains(food) ||
        food == GameSize.boxCount() + 1 ||
        Manager.giftFood.contains(food)) {
      food = Random().nextInt(GameSize.boxCount());
    }
  }

//------------------------------------------------------
  List<int> snakePosition = [30, 50, 70, 90];
  Direct direct = Direct.Down;

  void moveSnake() {
    Duration duration = Duration(milliseconds: Manager.gameSpeed);
    Timer.periodic(duration, (timer) {
      if (Manager.gameOver || Manager.isPause || Manager.isChangeGameSpeed) {
        timer.cancel();
      } else
        _snake();

      notifyListeners();
    });
  }

  void _snake() {
    int newV;
    switch (direct) {
      case Direct.Up:
        newV = _moveUp(snakePosition.last);
        break;
      case Direct.Down:
        newV = _moveDown(snakePosition.last);
        break;
      case Direct.Right:
        newV = _moveRight(snakePosition.last);
        break;
      case Direct.Left:
        newV = _moveLeft(snakePosition.last);
        break;
    }
    snakePosition.add(newV);

    Manager.moveNow = false;

    if (snakePosition.last == food ||
        Manager.giftFood.contains(snakePosition.last)) {

      GameSound.playSoundEffect(KEatFileSound);
    //TODO : run function to run sound effect
    testScoreState();
      if (Manager.giftFood.contains(snakePosition.last)) {
        Manager.giftFood.remove(snakePosition.last);
      } else {
        createFood();
      }

    } else
      snakePosition.removeAt(0);
    if (snakePosition.last == sFood) {
      sFood = GameSize.boxCount() + 1;
      reward = SpecialFood().getRandomReward();
      getRestTime();
    }
    Manager.snakeIndex = snakePosition;
    Manager.snakeFood = food!;

    //Manager.gameOver = isGameOver();
    Manager.requestLife = isGameOver();
    if (Manager.requestLife) {
      if (Manager.isExtraLifeTaken) {
        Manager.gameOver = true;
        Manager.requestLife = false;
      } else {
        Manager.isPause = true;
      }
    }
    if (Manager.gameOver) GameSound.playSoundEffect(KGameOverFileSound);
    checkAvailabilityForSpecialFood();
  }

  void testScoreState(){
    dev.log("from snake model testScoreState function");

  }

  void giveExtraLife() {
    reward = SpecialFood().becomeImmortal();
    getRestTime();
    notifyListeners();
  }

  String reward = '';
  bool timerStart = false;
  int sec = Manager.seconds;

  void getRestTime() {
    if (reward != '' && !timerStart) {
      Duration dur = Duration(seconds: 1);
      sec = Manager.seconds;
      Timer.periodic(dur, (timer) {
        if (sec > 0) {
          --sec;
        } else {
          timer.cancel();
          timerStart = false;
          reward = '';
          sec = Manager.seconds;
        }
      });
    }
  }

  int? sFood;

  void checkAvailabilityForSpecialFood() {
    if (!Manager.timerSFRun) {
      Manager.timerSFRun = true;
      int _seconds = Random().nextInt(30) + 60;
      Duration _duration = Duration(seconds: _seconds);
      Future.delayed(_duration, () {
        _showSpecialFood();
        Manager.timerSFRun = false;
      });
      notifyListeners();
    }
  }

  void _showSpecialFood() {
    if (!Manager.restartPressed) {
      if (!Manager.isPause) {
        while (snakePosition.contains(sFood) ||
            GameSize.blockIndex.contains(sFood) ||
            sFood == food ||
            sFood == GameSize.boxCount() + 1 ||
            Manager.giftFood.contains(sFood)) {
          sFood = Random().nextInt(GameSize.boxCount());
          Future.delayed(Duration(seconds: 15), () {
            sFood = GameSize.boxCount() + 1;
          });
        }
      }
    } else {
      Manager.restartPressed = false;
    }
  }

  int _moveUp(int num) {
    int newV = num;
    newV -= GameSize().cellInRow();
    if (newV < 0) newV += GameSize.boxCount();
    return newV;
  }

  int _moveDown(int num) {
    int newV = num;
    newV += GameSize().cellInRow();
    if (newV >= GameSize.boxCount()) newV -= GameSize.boxCount();
    return newV;
  }

  int _moveLeft(int num) {
    int newV = num;
    if (Manager.isFirstCellInRow(newV))
      newV += (GameSize().cellInRow() - 1);
    else
      newV -= 1;
    return newV;
  }

  int _moveRight(int num) {
    int newV = num;
    if (Manager.isLastCellInRow(newV))
      newV -= (GameSize().cellInRow() - 1);
    else
      newV += 1;
    return newV;
  }
}
