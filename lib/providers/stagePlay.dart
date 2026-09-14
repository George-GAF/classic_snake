import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../constant/constant.dart';
import '../constant/enum_file.dart';
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
  int _lastPersistedHighScore = 0;

  final Uint8List _grid = Uint8List(GameSize.boxCount());
  int frame = 0;

  int fxPulse = 0;
  int eatenAt = -1;
  bool fxIsSpecial = false;

  bool _targetBroken = false;
  bool _hScoreBroken = false;
  bool _isAskedToMoveToNextLevel = false;
  bool showAskMenu = false;

  Timer? gameTimer;
  Timer? _sfTimer;
  int _session = 0;

  Uint8List get grid => _grid;

  int get highScore => _hScore;

  void gamePlay() {
    if (gameTimer?.isActive ?? false) return;
    gameTimer = Timer.periodic(
        Duration(milliseconds: Manager.gameSpeed), (timer) {
      if (Manager.isChangeGameSpeed) {
        timer.cancel();
        gameTimer = null;
        Manager.isChangeGameSpeed = false;
        gamePlay();
        return;
      }
      if (Manager.gameOver || Manager.isPause) return;
      snake!.moving();
      _isaLife();
      _eating();
      checkAvailabilityForSpecialFood();
      _reindex();
      notifyListeners();
    });
  }

  void _reindex() {
    final body = snake!.getBody();
    _grid.fillRange(0, _grid.length, 0);
    for (final b in level!.blocks!) {
      _grid[b] = 1;
    }
    for (final s in body) {
      _grid[s] = 2;
    }
    _grid[Manager.food] = 3;
    for (final g in Manager.giftFoods) {
      _grid[g] = 4;
    }
    final sf = stage!.sFood;
    if (sf >= 0 && sf < _grid.length) _grid[sf] = 5;
    frame++;
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

  Direct getDirect() {
    return snake!.getDirect();
  }

  void changeDirect(Direct direct) {
    snake!.setDirect(direct);
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
        _triggerFx(false);
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
        _triggerFx(true);
        break;
    }
  }

  void _triggerFx(bool special) {
    eatenAt = snake!.getBody().last;
    fxIsSpecial = special;
    fxPulse++;
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
      _hScore = _score;
      if (_score > _lastPersistedHighScore) {
        _lastPersistedHighScore = _score;
        controller!.setLevelHighScore(_score);
      }
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
    if (Manager.timerSFRun) return;
    Manager.timerSFRun = true;
    _sfTimer = Timer(Duration(seconds: Random().nextInt(30) + 60), () {
      _sfTimer = null;
      _showSpecialFood();
    });
  }

  void _showSpecialFood() {
    if (Manager.gameOver) return;
    if (Manager.restartPressed) {
      Manager.restartPressed = false;
      return;
    }
    if (Manager.isPause) {
      Manager.timerSFRun = false;
      return;
    }
    final session = _session;
    int guard = 0;
    do {
      stage!.sFood = Random().nextInt(GameSize.boxCount() - 1);
      guard++;
    } while (guard < 64 &&
        (snake!.getBody().contains(stage!.sFood) ||
            level!.blocks!.contains(stage!.sFood) ||
            stage!.sFood == stage!.food ||
            Manager.giftFoods.contains(stage!.sFood)));
    if (guard >= 64) {
      Manager.timerSFRun = false;
      return;
    }
    Future<void>.delayed(const Duration(seconds: 15), () {
      if (session != _session) return;
      if (Manager.gameOver || Manager.isSFoodEating) return;
      stage!.sFood = GameSize.boxCount() + 1;
      Manager.timerSFRun = false;
    });
  }

  void giveExtraLife() {
    stage!.reward = SpecialFood().becomeImmortal();
    stage!.getRestTime();
    notifyListeners();
  }

  void start(int levelID) {
    gameTimer?.cancel();
    gameTimer = null;
    _sfTimer?.cancel();
    _sfTimer = null;
    _session++;
    Manager.startGame();
    Manager.currentStageID = levelID;
    level = levelList[levelID];
    if (kDebugMode) {
      print('id = $levelID level detail ${level.toString()}');
    }
    controller = new LevelController(level!.rank!);
    snake = new Snake();
    stage = new Stage(level!);
    _hScore = 0;
    _lastPersistedHighScore = 0;
    _targetBroken = false;
    _hScoreBroken = false;
    showTapMassage = true;
    showMenu = false;
    _isAskedToMoveToNextLevel = false;
    showAskMenu = false;
    _reindex();
    controller!.getLevelHighScore().then((value) {
      _hScore = value;
      _lastPersistedHighScore = value;
      notifyListeners();
    });
    notifyListeners();
  }

  void endGame() {
    gameTimer?.cancel();
    gameTimer = null;
    _sfTimer?.cancel();
    _sfTimer = null;
    _session++;
    Manager.endGame();
    notifyListeners();
  }
}
