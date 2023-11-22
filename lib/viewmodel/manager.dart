import 'package:flutter/material.dart' show BuildContext, showDialog;
import 'package:flutter/services.dart';

import '../widget/option_menu.dart';
import 'game_size.dart';

class Manager {
  static bool gameRun = false;
  static bool gameOver = false;
  static bool requestLife = false;
  static bool isExtraLifeTaken = false;
  static bool isPause = false;
  static bool showChild = false;
  static bool isChangeGameSpeed = false;
  static bool timerSFRun = false;
  static bool restartPressed = false;
  static bool isMustChangeSnakeColor = false;
  static bool moveNow = false;
  static bool sendToBackground = false;

  static int seconds = 0;
  static int bonus = 0;
  static List<int> giftFood = [];  // stageMange
  static List<int> snakeIndex = [30, 50, 70, 90]; // snake
  static int snakeFood = 0; //stageMange
  static int gameSpeed = 300; // snake
  static int defaultLevelGameSpeed = 300; // snake

  static void screenAdjust() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static bool isLastCellInRow(int index) {
    return ((index - 19) % GameSize().cellInRow()) == 0;
  }

  static bool isFirstCellInRow(int index) {
    return (index % GameSize().cellInRow()) == 0;
  }

  static void showOptionMenu(BuildContext context) {
    showDialog(
        context: context,
        builder: (cont) {
          return OptionMenu();
        });
  }

  static void startGame() {
    gameRun = false;
    gameOver = false;
    isPause = false;
    showChild = false;
    snakeIndex = [30, 50, 70, 90];
    bonus = 0;
  }

  static void endGame() {
    Manager.gameRun = false;
    Manager.gameOver = true;
    GameSize.isGameBuild = false;
    Manager.restartPressed = true;
  }
}
