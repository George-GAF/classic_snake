import 'dart:developer';

import 'package:classic_snake/gaf_package/ad_widget/baneer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../constant/enum_file.dart';
import '../model/level_model.dart';
import '../viewmodel/app_color.dart';
import '../viewmodel/assiest_manger.dart';
import '../viewmodel/game_size.dart';
import '../viewmodel/level_controller.dart';
import '../viewmodel/manager.dart';
import '../viewmodel/snake.dart';
import '../viewmodel/sound_controller.dart';
import '../viewmodel/timer_controller.dart';
import '../widget/cell_mod.dart';
import '../widget/gaf_text.dart';
import '../widget/game_menu.dart';

double width = GameSize().width();
double height = GameSize().height();
double avaWidth = GameSize().avaWidth();

int buildTime = 0;

class PlayScreen extends StatelessWidget {
  static const routeName = '/PlayScreen';
  final LevelModel stage;
  static late AssManager assManager;

  PlayScreen({required this.stage});

  bool isPlayMusicHighScore = false;
  bool isScoreDone = false;
  bool isScoreBroken = false;

  @override
  Widget build(BuildContext context) {
    bool isLevelGetRank = false;
    log("build fun run");
    log("build time : ${++buildTime}");
    LevelController? level;
    Manager.screenAdjust();
    if (!isLevelGetRank) {
      level = LevelController(stage.rank);
      isLevelGetRank = true;
    }

    String title = stage.rank == 0
        ? 'Survival'
        : stage.rank == 999
            ? 'Custom Level'
            : '${stage.rank}';

    if (!GameSize.isGameBuild) {
      GameSize.isGameBuild = true;
      GameSize.blockIndex = [];
      GameSize.blockIndex = stage.buildWell!;
      assManager = AssManager(context);
    }

    double rowHeight = GameSize().height() - (GameSize().getStageHeight());

    if (!isScoreDone) {
      isScoreDone = level.scoreLevelDone(
          stage.targetScore, Provider.of<Snake>(context).getScore());
    }

    Future<bool> highBroken = level.highScoreBroken(
        level.getLevelHighScore(), Provider.of<Snake>(context).getScore());
    log("will test $isPlayMusicHighScore");
    if (!isPlayMusicHighScore) {
      highBroken.then((isBroken) {
        log("is broken $isBroken");
        if (isBroken) {
          GameSound.playSoundEffect(KHeightScoreBreakFileSound);
          isPlayMusicHighScore = true;
        }
      });
    }

    if (isScoreDone) {
      if (!isScoreBroken && stage.targetScore != 0) {
        GameSound.playSoundEffect(KTargetDoneFileSound);
        isScoreBroken = true;
      }
    }

    return Scaffold(
      backgroundColor:
          Provider.of<AppColorController>(context).getColors().basicColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: rowHeight,
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: Future.delayed(Duration(seconds: 5)),
                          builder: (cont, snap) {
                            return BannerWidget();
                          }),
                      TopPart(title: title, stage: stage, level: level),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<Snake>(
                    builder: (con, snake, child) {
                      /// make function run one time
                      if (Manager.gameOver) {
                        snake.setMenuState(refresh: false);
                      } else if (Manager.requestLife) {
                        snake.setMenuState(refresh: false);
                      }
                      return GestureDetector(
                        onVerticalDragUpdate: (d) {
                          if (snake.direct != Direct.Up && d.delta.dy > 0) {
                            if (!Manager.moveNow) {
                              snake.direct = Direct.Down;
                              Manager.moveNow = true;
                            }
                          } else if (snake.direct != Direct.Down &&
                              d.delta.dy < 0) {
                            if (!Manager.moveNow) {
                              snake.direct = Direct.Up;
                              Manager.moveNow = true;
                            }
                          }
                        },
                        onHorizontalDragUpdate: (d) {
                          if (snake.direct != Direct.Left && d.delta.dx > 0) {
                            if (!Manager.moveNow) {
                              snake.direct = Direct.Right;
                              Manager.moveNow = true;
                            }
                          } else if (snake.direct != Direct.Right &&
                              d.delta.dx < 0) {
                            if (!Manager.moveNow) {
                              snake.direct = Direct.Left;
                              Manager.moveNow = true;
                            }
                          }
                        },
                        child: Container(
                          width: avaWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Provider.of<AppColorController>(context)
                                  .getColors()
                                  .blockColor,
                            ),
                          ),
                          child: GridView.builder(
                            itemCount: GameSize.boxCount(),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: GameSize().cellInRow(),
                            ),
                            itemBuilder: (cont, i) {
                              snake.setCellType(i);
                              return CellMod(
                                snake.cellType,
                                i,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Provider.of<Snake>(context).showMenu
                ? shadowContainer(Provider.of<Snake>(context).showMenu, context)
                : SizedBox(),
            GameMenu(
              visible: Provider.of<Snake>(context).showMenu,
              isPause: Manager.isPause,
            ),
            Provider.of<Snake>(context).showTapMassage
                ? GestureDetector(
                    onTap: () {
                      if (!Manager.gameRun && !Manager.gameOver) {
                        // todo: add level speed
                        Provider.of<Snake>(context, listen: false).restGame();
                        Provider.of<Snake>(context, listen: false)
                            .hideTapMassage();
                        Provider.of<Snake>(context, listen: false).moveSnake();
                        Manager.gameRun = true;
                        GameTimer.runTimer();
                      }
                    },
                    child: Container(
                      width: width,
                      height: height,
                      alignment: AlignmentDirectional.center,
                      color: Provider.of<AppColorController>(context)
                          .getColors()
                          .menuColor
                          .withOpacity(.3),
                      child: GAFText(
                        'Tap to Play',
                        fontSize: width * .20,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w900,
                        colorOpacity: .7,
                        softWrap: true,
                        shadows: [],
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Container shadowContainer(bool showMenu, BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: showMenu ? MediaQuery.of(context).size.width : 0,
      height: showMenu ? MediaQuery.of(context).size.height : 0,
    );
  }
}

class TopPart extends StatelessWidget {
  const TopPart({
    Key? key,
    @required this.title,
    @required this.stage,
    @required this.level,
  }) : super(key: key);

  final String? title;
  final LevelModel? stage;
  final LevelController? level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * .012),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GAFText(
            'Level : $title',
            fontWeight: FontWeight.w900,
            fontSize: width * .04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GAFText(
                    'play time : ${GameTimer.showTimer()}',
                    fontSize: width * .04,
                  ),
                  SizedBox(
                    width: width * .03,
                  ),
                  Row(
                    children: [
                      GAFText(
                        Provider.of<Snake>(context).reward,
                        fontWeight: FontWeight.w900,
                        fontSize: width * .04,
                        softWrap: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GAFText(
                        '${Provider.of<Snake>(context).sec == 0 ? '' : Provider.of<Snake>(context).sec}',
                        fontWeight: FontWeight.w900,
                        fontSize: width * .04,
                      ),
                    ],
                  ),
                ],
              ),
              Consumer<AppColorController>(
                builder: (cont, color, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: color.getColors().basicColor,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: color.getColors().lightShadow,
                            offset: Offset(-1, -1),
                            blurRadius: 3),
                        BoxShadow(
                            color: color.getColors().darkShadow,
                            offset: Offset(1, 1),
                            blurRadius: 3)
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(avaWidth * .015),
                      child: InkWell(
                        onTap: () {
                          Manager.isPause = !Manager.isPause;
                          GameTimer.manageTimer();
                          if (!Manager.isPause)
                            Provider.of<Snake>(context, listen: false)
                                .moveSnake();
                          Provider.of<Snake>(context, listen: false)
                              .setMenuState();
                          Manager.sendToBackground = false;
                        },
                        child: Icon(
                          Manager.sendToBackground
                              ? Icons.pause
                              : Icons.settings,
                          color: color.getColors().fontColor,
                          size: avaWidth * .08,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              stage?.rank != 0
                  ? GAFText(
                      'Target : ${stage?.targetScore} ',
                      fontSize: width * .04,
                    )
                  : SizedBox(),
              SizedBox(
                width: stage?.rank != 0 ? width * .04 : 0,
              ),
              Consumer<Snake>(
                builder: (cont, data, child) {
                  return GAFText(
                    'Score : ${data.getScore()}',
                    fontSize: width * .04,
                    fontWeight: data.getScore() >= stage!.targetScore
                        ? FontWeight.w900
                        : FontWeight.normal,
                    colors: data.getScore() >= stage!.targetScore &&
                            stage!.rank != 0
                        ? Colors.green[900]
                        : null,
                  );
                },
              ),
              SizedBox(
                width: width * .04,
              ),
              FutureBuilder(
                builder: (_, data) {
                  return GAFText(
                    'High Score : ${(data.data ?? 0)}',
                    fontSize: width * .04,
                    fontWeight: FontWeight.w900,
                  );
                },
                future: level?.getLevelHighScore(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
