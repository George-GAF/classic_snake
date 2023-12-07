
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/enum_file.dart';
import '../gaf_package/ad_widget/baneer_widget.dart';
import '../model/level_model.dart';
import '../providers/stagePlay.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/level_controller.dart';
import '../view_model/manager.dart';
import '../view_model/timer_controller.dart';
import '../widget/cell_mod.dart';
import '../widget/gaf_text.dart';
import '../widget/game_menu.dart';

double width = GameSize().width();
double height = GameSize().height();
double avaWidth = GameSize().avaWidth();

int buildTime = 0;

class PlayScreen extends StatelessWidget {
  static const routeName = '/PlayScreen';

  PlayScreen();

  @override
  Widget build(BuildContext context) {
    Manager.screenAdjust();
    final stagePlay = Provider.of<StagePlay>(context);
    return Scaffold(
      backgroundColor:
          Provider.of<AppColorController>(context).getColors().basicColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: GameSize().rowHeight(),
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: Future.delayed(Duration(seconds: 5)),
                          builder: (cont, snap) {
                            return BannerWidget();
                          }),
                      TopPart(
                          title: stagePlay.stage!.getStageTitle(),
                          stage: stagePlay.level,
                          level: stagePlay.controller),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<StagePlay>(
                    builder: (con, stage, child) {
                      /// make function run one time
                      if (Manager.gameOver) {
                        stage.setMenuState(refresh: false);
                      } else if (Manager.requestLife) {
                        stage.setMenuState(refresh: false);
                      }
                      return GestureDetector(
                        onVerticalDragUpdate: (d) {
                          if (stage.getDirect() != Direct.Up &&
                              d.delta.dy > 0) {
                            //if (!Manager.moveNow) {
                            stage.changeDirect(Direct.Down);
                            //Manager.moveNow = true;
                            //}
                          } else if (stage.getDirect() != Direct.Down &&
                              d.delta.dy < 0) {
                            // if (!Manager.moveNow) {
                            stage.changeDirect(Direct.Up);
                            // Manager.moveNow = true;
                            // }
                          }
                        },
                        onHorizontalDragUpdate: (d) {
                          if (stage.getDirect() != Direct.Left &&
                              d.delta.dx > 0) {
                            // if (!Manager.moveNow) {
                            stage.changeDirect(Direct.Right);
                            // Manager.moveNow = true;
                            // }
                          } else if (stage.getDirect() != Direct.Right &&
                              d.delta.dx < 0) {
                            //  if (!Manager.moveNow) {
                            stage.changeDirect(Direct.Left);
                            //  Manager.moveNow = true;
                            // }
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
                          child: Consumer<StagePlay>(
                            builder: (context, stage, child) {
                              return GridView.builder(
                                itemCount: GameSize.boxCount(),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: GameSize().cellInRow(),
                                ),
                                itemBuilder: (cont, i) {
                                  stage.setCellType(i);
                                  return CellMod(
                                    stage.cellType,
                                    i,
                                  );
                                },
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
            stagePlay.showMenu
                ? shadowContainer(stagePlay.showMenu, context)
                : SizedBox(),
            GameMenu(
              visible: stagePlay.showMenu,
              isPause: Manager.isPause,
            ),
            stagePlay.showTapMassage
                ? GestureDetector(
                    onTap: () {
                      if (!Manager.gameRun && !Manager.gameOver) {
                        // todo: add level speed
                        Provider.of<StagePlay>(context, listen: false)
                            .endGame();
                        Provider.of<StagePlay>(context, listen: false)
                            .hideTapMassage();
                        Provider.of<StagePlay>(context, listen: false)
                            .gamePlay();
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
                        Provider.of<StagePlay>(context).stage!.reward,
                        fontWeight: FontWeight.w900,
                        fontSize: width * .04,
                        softWrap: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GAFText(
                        '${Provider.of<StagePlay>(context).stage!.sec == 0 ? '' : Provider.of<StagePlay>(context).stage!.sec}',
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
                            Provider.of<StagePlay>(context, listen: false)
                                .gamePlay();
                          Provider.of<StagePlay>(context, listen: false)
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
              Consumer<StagePlay>(
                builder: (cont, data, child) {
                  return GAFText(
                    'Score : ${data.stageCurrentScore()}',
                    fontSize: width * .04,
                    fontWeight: data.isTargetBroken()
                        ? FontWeight.w900
                        : FontWeight.normal,
                    colors: data.isTargetBroken() && stage!.rank != 0
                        ? Colors.green[900]
                        : null,
                  );
                },
              ),
              SizedBox(
                width: width * .04,
              ),
              FutureBuilder(
                builder: (_, hScore) {
                  Provider.of<StagePlay>(context).readHScore(hScore.data ?? 0);
                  return GAFText(
                    'High Score : ${(hScore.data ?? 0)}',
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
