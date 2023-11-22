import 'dart:developer';

import 'package:classic_snake/gaf_package/ad_widget/rewarded_Ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../screen/stages_screen.dart';
import '../viewmodel/app_color.dart';
import '../viewmodel/game_size.dart';
import '../viewmodel/manager.dart';
import '../viewmodel/snake.dart';
import '../viewmodel/sound_controller.dart';
import '../viewmodel/timer_controller.dart';
import 'gaf_button.dart';
import 'gaf_item.dart';
import 'gaf_text.dart';

double _height = GameSize().height();
double _width = GameSize().width();

class GameMenu extends StatefulWidget {
  final bool? isPause;
  final bool? visible;

  const GameMenu({this.isPause, this.visible});

  @override
  _GameMenuState createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  @override
  void initState() {
    super.initState();
    //InterstitialAdController.loadInterstitialAd();//TODO: change or remove NativeAds
  }

  @override
  Widget build(BuildContext context) {
    double space = widget.visible! ? (_width - 140) / 4 : 0;
    return AnimatedPositioned(
      top: widget.visible! ? _height * .1 : _height,
      duration: Duration(milliseconds: Manager.gameSpeed),
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: _height * .03, horizontal: _width * .05),
          decoration: BoxDecoration(
            color:
                Provider.of<AppColorController>(context).getColors().basicColor,
            borderRadius: BorderRadius.circular(_width * .05),
          ),
          width: _width * .95,
          height: _height * .8,
          margin: EdgeInsets.symmetric(horizontal: _width * .025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GAFItem(
                child: GAFText(
                  widget.isPause! ? 'Game Pause' : 'Game Over',
                  fontSize: _width * .09,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GAFItem(
                child: GAFText(
                  'Your Score : ${Provider.of<Snake>(context).getScore().toString()}\nPlay Time : ${GameTimer.showTimer()}',
                  fontSize: _width * .045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Manager.requestLife
                  ? GAFItem(
                      paddingH: 0,
                      paddingV: 0,
                      child: GAFButton(
                        text: 'Continue',
                        icon: Icons.play_arrow_rounded,
                        onPressed: ()  {
                          RewardedHelperAd().showAd(() => {runReward(context)});
                        },
                        startSpace: space,
                      ),
                    )
                  : SizedBox(),
              GAFItem(
                paddingH: 0,
                paddingV: 0,
                child: GAFButton(
                  text: widget.isPause! && !Manager.requestLife
                      ? 'Resume'
                      : 'Restart',
                  icon: Icons.reset_tv,
                  onPressed: () {
                    if (widget.isPause! && !Manager.requestLife) {
                      Manager.isPause = false;
                      GameTimer.manageTimer();
                      Provider.of<Snake>(context, listen: false).moveSnake();
                    } else {
                      Manager.gameOver = true;
                      Provider.of<Snake>(context, listen: false).restGame();
                      Manager.startGame();
                      Manager.restartPressed = true;
                    }
                    Provider.of<Snake>(context, listen: false).setMenuState();
                  },
                  startSpace: space,
                ),
              ),
              GAFItem(
                paddingH: 0,
                paddingV: 0,
                child: GAFButton(
                  text: 'Option',
                  icon: Icons.settings_applications_rounded,
                  onPressed: () {
                    Manager.showOptionMenu(context);
                  },
                  startSpace: space,
                ),
              ),
              GAFItem(
                paddingH: 0,
                paddingV: 0,
                child: GAFButton(
                  text: 'Back To Main',
                  icon: Icons.keyboard_return_rounded,
                  onPressed: () async {
                    // await InterstitialAdController.showInterstitialAd();//TODO: change or remove NativeAds
                    Provider.of<Snake>(context, listen: false).showMenu = false;
                    //RewardedAdController.setNull();
                    Manager.endGame();
                    Provider.of<Snake>(context, listen: false).restGame();
                    Navigator.pushReplacementNamed(
                        context, StageScreen.routeName);
                  },
                  startSpace: space,
                ),
              ),
              GAFItem(
                paddingH: 0,
                paddingV: 0,
                //paddingV: 5,
                child: GAFButton(
                  text: 'Exit',
                  icon: Icons.exit_to_app_rounded,
                  onPressed: () {
                    GameSound.stopAllSoundOnExit();
                    SystemNavigator.pop(animated: true);
                  },
                  startSpace: space,
                ),
              )
            ],
          )),
    );
  }
}

void _showToastMassage(BuildContext context) {
  Toast.show('No Ad Available',
      duration: 2,
      webTexColor: Provider.of<AppColorController>(context, listen: false)
          .getColors()
          .fontColor,
      backgroundColor: Provider.of<AppColorController>(context, listen: false)
          .getColors()
          .darkShadow);
}

void runReward(BuildContext context) {
  log("run reward function run");
  try {
    Manager.isExtraLifeTaken = true;
    Manager.requestLife = false;
    Manager.isPause = false;
    Provider.of<Snake>(context, listen: false).giveExtraLife();
    Provider.of<Snake>(context, listen: false).moveSnake();
    Provider.of<Snake>(context, listen: false).setMenuState();
  } catch (e) {}

  /*
  final _ = RewardedAdController(() {
    try {
      Manager.isExtraLifeTaken = true;
      Manager.requestLife = false;
      Manager.isPause = false;
      Provider.of<Snake>(context, listen: false)
          .giveExtraLife();
      Provider.of<Snake>(context, listen: false)
          .moveSnake();
      Provider.of<Snake>(context, listen: false)
          .setMenuState();
    } catch (e) {}
  }, () {
    _showToastMassage(context);
  });*/
}
