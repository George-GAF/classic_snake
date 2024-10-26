import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/enum_file.dart';
import '../providers/stagePlay.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../widget/cell/cell.dart';
import '../widget/game_menu.dart';
import '../widget/play_screen_widget/tap_to_play.dart';
import '../widget/play_screen_widget/top_section.dart';

double width = GameSize().width();
double height = GameSize().height();
double avaWidth = GameSize().avaWidth();

class PlayScreen extends StatelessWidget {
  static const routeName = '/PlayScreen';

  PlayScreen();

  @override
  Widget build(BuildContext context) {
    final stagePlay = context.watch<StagePlay>();
    final stage = stagePlay.stage;
    if (Manager.gameOver || Manager.requestLife) {
      stagePlay.setMenuState(refresh: false);
    }
    Manager.screenAdjust();
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 150, 255, 1),
      //context.watch<AppColorController>().getColors().basicColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: GameSize().rowHeight(),
                  child: TopPart(
                      title: stage!.getStageTitle(),
                      stage: stagePlay.level,
                      level: stagePlay.controller),
                ),
                Expanded(
                  child: GestureDetector(
                    onVerticalDragUpdate: (d) {
                      if (stagePlay.getDirect() != Direct.Up &&
                          d.delta.dy > 0) {
                        stagePlay.changeDirect(Direct.Down);
                      } else if (stagePlay.getDirect() != Direct.Down &&
                          d.delta.dy < 0) {
                        stagePlay.changeDirect(Direct.Up);
                      }
                    },
                    onHorizontalDragUpdate: (d) {
                      if (stagePlay.getDirect() != Direct.Left &&
                          d.delta.dx > 0) {
                        stagePlay.changeDirect(Direct.Right);
                      } else if (stagePlay.getDirect() != Direct.Right &&
                          d.delta.dx < 0) {
                        stagePlay.changeDirect(Direct.Left);
                      }
                    },
                    child: Container(
                      width: avaWidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: context
                              .watch<AppColorController>()
                              .getColors()
                              .blockColor,
                        ),
                      ),
                      child: PlayArea(stagePlay: stagePlay),
                    ),
                  ),
                ),
              ],
            ),
            GameMenu(
              visible: stagePlay.showMenu,
              isPause: Manager.isPause,
            ),
            TapToPlay(),
          ],
        ),
      ),
    );
  }
}

class PlayArea extends StatelessWidget {
  const PlayArea({
    super.key,
    required this.stagePlay,
  });

  final StagePlay stagePlay;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: GameSize.boxCount(),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: GameSize().cellInRow(),
      ),
      itemBuilder: (cont, i) {
        // stagePlay.setCellType(i);
        var snake = stagePlay.snake!.getBody();
        var blocks = stagePlay.level!.blocks;
        var giftFood = Manager.giftFoods;
        var food = Manager.food;
        var sFood = stagePlay.stage!.sFood;
        CellType cellType = CellType.Ground;

        if (blocks!.contains(i)) {
          cellType = CellType.Block;
        } else if (snake.contains(i)) {
          cellType = CellType.Snake;
        } else if (food == i || giftFood.contains(i)) {
          cellType = CellType.Food;
        } else if (sFood == i) {
          cellType = CellType.SpecialFood;
        }

        return Cell(
          cellType,
          i,
        );
      },
    );
  }
}
