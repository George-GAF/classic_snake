import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../gaf_package/ad_widget/rewarded_Ad.dart';
import '../constant/constant.dart';
import '../providers/stagePlay.dart';
import '../screen/stages_screen.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../view_model/sound_controller.dart';
import '../view_model/timer_controller.dart';
import 'ask_to_move_next_level.dart';
import 'gaf_button.dart';
import 'gaf_text.dart';
import 'play_screen_widget/top_section.dart' show AnimatedNumber;

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
  Widget build(BuildContext context) {
    var stagePlayWatch = context.watch<StagePlay>();
    var stageRead = context.read<StagePlay>();
    var colors = context.watch<AppColorController>().getColors();
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.visible!)
          BackdropFilter(
            // ponytail: full-screen blur while paused; KMenuBlurSigma -> 0 on low-end if jank
            filter: ImageFilter.blur(
                sigmaX: KMenuBlurSigma, sigmaY: KMenuBlurSigma),
            child: Container(color: Colors.black.withOpacity(.45)),
          ),
        AnimatedPositioned(
          top: widget.visible! ? _height * .07 : _height,
          duration: Duration(milliseconds: Manager.gameSpeed),
          child: Container(
            padding:
                EdgeInsets.symmetric(vertical: _height * .02, horizontal: _width * .05),
            decoration: BoxDecoration(
              color: colors.menuColor.withOpacity(.96),
              borderRadius: BorderRadius.circular(_width * .06),
              border: Border.all(
                  color: colors.glowColor.withOpacity(.45), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: colors.glowColor.withOpacity(.35),
                  blurRadius: _width * .05,
                  spreadRadius: _width * .005,
                ),
              ],
            ),
            width: _width * .95,
            height: _height * .78,
            margin: EdgeInsets.symmetric(horizontal: _width * .025),
            child: stagePlayWatch.showAskMenu
                ? AskToMoveNextLevel()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GAFText(
                        widget.isPause! ? 'PAUSE' : 'GAME OVER',
                        fontSize: _width * .1,
                        fontWeight: FontWeight.w900,
                        glowColor: colors.glowColor,
                        textAlign: TextAlign.center,
                        letterSpacing: 4,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: _width * .04, vertical: _height * .01),
                        decoration: BoxDecoration(
                          color: colors.basicColor.withOpacity(.6),
                          borderRadius: BorderRadius.circular(_width * .02),
                          border: Border.all(
                              color: colors.glowColor.withOpacity(.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GAFText(
                                  'SCORE',
                                  fontSize: _width * .03,
                                  colorOpacity: .6,
                                ),
                                AnimatedNumber(
                                  target:
                                      '${stagePlayWatch.stageCurrentScore()}',
                                  bold: true,
                                  accent: colors.glowColor,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GAFText(
                                  'TIME',
                                  fontSize: _width * .03,
                                  colorOpacity: .6,
                                ),
                                GAFText(
                                  GameTimer.showTimer(),
                                  fontSize: _width * .04,
                                  fontWeight: FontWeight.w900,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (Manager.requestLife)
                        GAFButton(
                          text: 'Continue',
                          icon: Icons.play_arrow_rounded,
                          heightRate: 1.2,
                          onPressed: () async {
                            await RewardedHelperAd().showAd(() {
                              runReward(context);
                            }, context);
                          },
                        ),
                      GAFButton(
                        text: widget.isPause! && !Manager.requestLife
                            ? 'Resume'
                            : 'Restart',
                        icon: Icons.reset_tv,
                        onPressed: () {
                          if (widget.isPause! && !Manager.requestLife) {
                            Manager.isPause = false;
                            GameTimer.manageTimer();
                            stageRead.gamePlay();
                          } else {
                            Manager.gameOver = true;
                            stageRead.endGame();
                            Manager.restartPressed = true;
                            stagePlayWatch.start(Manager.currentStageID);
                          }
                          stageRead.setMenuState();
                        },
                      ),
                      GAFButton(
                        text: 'Option',
                        icon: Icons.settings_applications_rounded,
                        onPressed: () {
                          Manager.showOptionMenu(context);
                        },
                      ),
                      GAFButton(
                        text: 'Back To Main',
                        icon: Icons.keyboard_return_rounded,
                        onPressed: () async {
                          stageRead.showMenu = false;
                          stageRead.endGame();
                          await Navigator.pushReplacementNamed(
                              context, StageScreen.routeName);
                        },
                      ),
                      GAFButton(
                        text: 'Exit',
                        icon: Icons.exit_to_app_rounded,
                        onPressed: () {
                          GameSound.stopAllSoundOnExit();
                          SystemNavigator.pop(animated: true);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

void runReward(BuildContext context) {
  var stagePlay = context.read<StagePlay>();
  try {
    Manager.isExtraLifeTaken = true;
    Manager.requestLife = false;
    Manager.isPause = false;
    stagePlay.giveExtraLife();
    stagePlay.gamePlay();
    stagePlay.setMenuState();
  } catch (e) {
    Toast.show('No Ad Available',
        duration: 2,
        webTexColor: context.read<AppColorController>().getColors().fontColor,
        backgroundColor:
            context.read<AppColorController>().getColors().darkShadow);
  }
}