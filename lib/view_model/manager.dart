import 'package:classic_snake/view_model/timer_controller.dart';
import 'package:flutter/material.dart' show BuildContext, showDialog;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/game_values.dart';
import '../widget/option_menu.dart';
import 'game_size.dart';

class Manager {
  static bool gameRun = false;
  static bool gameOver = false;
  static bool isPause = false;
  static bool showChild = false;
  static bool restartPressed = false;
  static bool isChangeGameSpeed = false;
  static bool requestLife = false;
  static bool isExtraLifeTaken = false;
  static int gameSpeed = KDefaultGameSpeed;
  static bool timerSFRun = false;
  static bool sendToBackground = false;
  static bool isMustChangeSnakeColor = false;
  static bool isSFoodEating = false;

  static bool dPadEnabled = false;
  static const String _dPadStateKey = 'dPadState';

  static int currentStageID = 0;
  static int gameScore = 0;
  static int seconds = 0;
  static List<int> giftFoods = [];
  static List<int> snake = [];
  static List<int> blocks = [];
  static int food = 0;

  static void startGame() {
    GameTimer.manageTimer();
    gameRun = false;
    gameOver = false;
    isPause = false;
    showChild = false;
    sendToBackground = false;
    timerSFRun = false;
    isSFoodEating = false;
    gameScore = 0;
    gameSpeed = KDefaultGameSpeed;
  }

  static void endGame() {
    gameRun = false;
    gameOver = true;
    requestLife = false;
    isExtraLifeTaken = false;
    isChangeGameSpeed = false;
    giftFoods = [];
    GameSize.isGameBuild = false;
    restartPressed = true;
    seconds = 0;
    gameScore = 0;
    snake = [];
    food = 0;
    blocks = [];
  }

  static void changeGameSpeed(int newSpeed) {
    gameSpeed = newSpeed;
    isChangeGameSpeed = true;
  }

  static Future<void> loadDPadSetting() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dPadEnabled = pref.getBool(_dPadStateKey) ?? false;
  }

  static Future<void> switchDPadSetting() async {
    dPadEnabled = !dPadEnabled;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(_dPadStateKey, dPadEnabled);
  }

  static void screenAdjust() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void showOptionMenu(BuildContext context) {
    showDialog(
        context: context,
        builder: (cont) {
          return OptionMenu();
        });
  }

  static bool isLastCellInRow(int index) {
    return ((index - 19) % GameSize().cellInRow()) == 0;
  }

  static bool isFirstCellInRow(int index) {
    return (index % GameSize().cellInRow()) == 0;
  }
}
