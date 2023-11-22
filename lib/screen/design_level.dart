import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/enum_file.dart';
import '../model/level_model.dart';
import '../viewmodel/app_color.dart';
import '../viewmodel/game_size.dart';
import '../viewmodel/level_controller.dart';
import '../viewmodel/manager.dart';
import '../widget/cell_mod.dart';
import '../widget/gaf_back_button.dart';
import '../widget/gaf_change_value_button.dart';
import '../widget/gaf_rasid_button.dart';
import '../widget/gaf_text.dart';
import 'play_screen.dart';
import 'stages_screen.dart';

class DesignLevel extends StatefulWidget {
  static const routeName = '/designLevel';

  @override
  _DesignLevelState createState() => _DesignLevelState();
}

class _DesignLevelState extends State<DesignLevel> {
  List<int> blocks = [];
  List<CellType> cellTypeList =
      List.generate(GameSize.boxCount(), (i) => CellType.Ground);

  double? rowHeight;
  int targetScore = 0;
  bool up = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < Manager.snakeIndex.length; i++) {
      cellTypeList[Manager.snakeIndex[i]] = CellType.Snake;
    }
    cellTypeList[Manager.snakeIndex.last] = CellType.Head;
    rowHeight = GameSize().height() - (GameSize().getStageHeight());
    fullData();
  }

  void fullData() async {
    LevelController level = LevelController(999);
    final temp = await level.levelRestore();
    setState(() {
      targetScore = temp.targetScore;
      blocks = LevelController.customBlocks;
    });
  }

  void increaseScore() {
    Duration d = Duration(milliseconds: 20);
    Timer.periodic(d, (timer) {
      if (up) {
        setState(() {
          if (targetScore < maxScore()) targetScore += 10;
        });
      } else
        timer.cancel();
    });
  }

  int maxScore() {
    return (GameSize.boxCount() - Manager.snakeIndex.length - blocks.length) *
        10;
  }

  void decreaseScore() {
    Duration d = Duration(milliseconds: 20);
    Timer.periodic(d, (timer) {
      if (up) {
        setState(() {
          if (targetScore > 0) targetScore -= 10;
        });
      } else
        timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    Manager.screenAdjust();
     double width = GameSize().width();
     double height = GameSize().height();
     double avaWidth = GameSize().avaWidth();
    return Scaffold(
      backgroundColor:
          Provider.of<AppColorController>(context).getColors().basicColor,
      body: SafeArea(
        child: Consumer<AppColorController>(
          builder: (cont, color, child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: GameSize().avaWidth() * .01),
                  child: SizedBox(
                    height: rowHeight,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GAFBackButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, StageScreen.routeName);
                              },
                            ),
                            GAFText(
                              'Blocks : ${blocks.length}',
                              fontSize: width* .04,
                            ),
                            Column(
                              children: [
                                GAFText(
                                  'Target $targetScore',
                                  fontSize: width * .035,
                                ),
                                Row(
                                  children: [
                                    GAFChangeValueButton(
                                      onStart: () {
                                        up = true;
                                        increaseScore();
                                      },
                                      onEnd: () {
                                        up = false;
                                      },
                                      onPressed: () {
                                        setState(() {
                                          if (targetScore < maxScore())
                                            targetScore += 10;
                                        });
                                        blocks.sort();
                                      },
                                      icon: Icons.add,
                                    ),
                                    SizedBox(
                                      width: width * .12,
                                    ),
                                    GAFChangeValueButton(
                                      onPressed: () {
                                        setState(() {
                                          if (targetScore > 0)
                                            targetScore -= 10;
                                        });
                                      },
                                      onStart: () {
                                        up = true;
                                        decreaseScore();
                                      },
                                      onEnd: () {
                                        up = false;
                                      },
                                      icon: Icons.remove,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (cont) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GAFText(
                                                  'Information',
                                                  fontSize:
                                                      GameSize().avaWidth() * .06,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(cont);
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Provider.of<
                                                                AppColorController>(
                                                            context)
                                                        .getColors()
                                                        .fontColor,
                                                    size: GameSize().avaWidth() *
                                                        .09,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: height * .02,
                                            )
                                          ],
                                        ),
                                        content: GAFText(
                                          '1-Put And Remove Block By Click on Play Stage\n2-Set your target score\n3-Save And Play\n4-Enjoy It',
                                          softWrap: true,
                                          fontSize: GameSize().avaWidth() * .05,
                                        ),
                                        backgroundColor:
                                            Provider.of<AppColorController>(
                                                    context)
                                                .getColors()
                                                .menuColor,
                                      );
                                    });
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.all(GameSize().avaWidth() * .015),
                                decoration: BoxDecoration(
                                  color:
                                      Provider.of<AppColorController>(context)
                                          .getColors()
                                          .basicColor,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Provider.of<AppColorController>(
                                                context)
                                            .getColors()
                                            .lightShadow,
                                        offset: Offset(-1, -1),
                                        blurRadius: 3),
                                    BoxShadow(
                                        color: Provider.of<AppColorController>(
                                                context)
                                            .getColors()
                                            .darkShadow,
                                        offset: Offset(1, 1),
                                        blurRadius: 3)
                                  ],
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: avaWidth * .08,
                                  color:
                                      Provider.of<AppColorController>(context)
                                          .getColors()
                                          .fontColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .005,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(avaWidth * .015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GAFRaisedButton(
                                  onPressed: () async {
                                    LevelController controller =
                                        LevelController(999);
                                    bool saved = await controller.levelSave(
                                        targetScore, blocks);
                                    if (saved) {
                                      LevelModel level = LevelModel(
                                        rank: 999,
                                        enable: true,
                                        targetScore: targetScore,
                                        buildWell: blocks,
                                      );
                                      await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PlayScreen(
                                            stage: level,
                                          ),
                                        ),
                                      );
                                      Manager.startGame();
                                    }
                                  },
                                  label: 'SAVE & PLAY',
                                ),
                                SizedBox(
                                  width: avaWidth * .02,
                                ),
                                GAFRaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      targetScore = 0;
                                      blocks = [];
                                    });
                                  },
                                  label: 'Reset',
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: avaWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: color.getColors().blockColor,
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: GameSize.boxCount(),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: GameSize().cellInRow(),
                    ),
                    itemBuilder: (cont, i) {
                      if (!Manager.snakeIndex.contains(i)) {
                        if (blocks.contains(i)) {
                          cellTypeList[i] = CellType.Block;
                        } else {
                          cellTypeList[i] = CellType.Ground;
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!Manager.snakeIndex.contains(i)) {
                              if (blocks.contains(i)) {
                                blocks.remove(i);
                                cellTypeList[i] = CellType.Ground;
                              } else {
                                blocks.add(i);
                                cellTypeList[i] = CellType.Block;
                                if (targetScore > maxScore())
                                  targetScore = maxScore();
                              }
                            }
                          });
                        },
                        child: Manager.snakeIndex.contains(i)
                            ? Container(
                                color: Provider.of<AppColorController>(context)
                                    .getColors()
                                    .snakeColor,
                              )
                            : CellMod(
                                cellTypeList[i],
                                i,
                              ),
                      );
                    },
                  ),
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
