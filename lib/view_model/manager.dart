import 'package:classic_snake/constant/game_values.dart';
import 'package:flutter/material.dart' show BuildContext, showDialog;
import 'package:flutter/services.dart';

import '../constant/enum_file.dart';
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

  static int bonus = 0;
  static int seconds = 0;
  static List<int> giftFoods = [];
  static List<int> snake = [];
  static List<int> blocks = [];
  static int food = 0;

  static void startGame() {
    gameRun = false;
    gameOver = false;
    isPause = false;
    showChild = false;
    sendToBackground = false;
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
    bonus = 0;
    snake = [];
    food = 0;
    blocks = [];
  }

  static void changeGameSpeed(int newSpeed) {
    gameSpeed = newSpeed;
    isChangeGameSpeed = true;
  }

  static void screenAdjust() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
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
  /*
  static bool moveNow = false;

  static Direct defaultDirect = Direct.Down ;

   REMOVED
  //---------------------------------------------------------------------
   MOVE TO STAGE

  static List<int> snakeBody = [30, 50, 70, 90]; // MOVE TO GAME VALUES
  //----------------------------------------------------------------------
  static int snakeFood = 0; //stageMange
   // snake
  static int defaultLevelGameSpeed = 300; // snake

  static void restGame(){
    gameOver = false;
    gameRun = false;
    moveNow = false;
    requestLife = false;
    isExtraLifeTaken = false;
    isChangeGameSpeed = false;
    seconds = 0;
    bonus = 0;
    giftFood = [];
    gameSpeed = 300;
    defaultLevelGameSpeed = 300;
    snakeBody = [30, 50, 70, 90];
    defaultDirect = Direct.Down ;
  } 


//-------------------------------------------------------
/*
        USING IN SNAKE CLASS
  static bool isLastCellInRow(int index) {
    return ((index - 19) % GameSize().cellInRow()) == 0;
  }

  static bool isFirstCellInRow(int index) {
    return (index % GameSize().cellInRow()) == 0;
  }
  */

//----------------------------------------------------------




   */
}
