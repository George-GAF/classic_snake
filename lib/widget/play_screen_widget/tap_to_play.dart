import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stagePlay.dart';
import '../../view_model/app_color.dart';
import '../../view_model/game_size.dart';
import '../../view_model/manager.dart';
import '../../view_model/timer_controller.dart';
import '../gaf_text.dart';

double width = GameSize().width();
double height = GameSize().height();
double avaWidth = GameSize().avaWidth();

class TapToPlay extends StatelessWidget {
  const TapToPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<StagePlay>().showTapMassage
        ? GestureDetector(
            onTap: () {
              if (!Manager.gameRun && !Manager.gameOver) {
                // todo: add level speed
                //context.read<StagePlay>().endGame();
                context.read<StagePlay>().hideTapMassage();
                context.read<StagePlay>().gamePlay();
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
        : const SizedBox.shrink();
  }
}
