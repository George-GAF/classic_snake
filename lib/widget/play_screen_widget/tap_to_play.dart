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
                  .basicColor
                  .withOpacity(.55),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GAFText(
                    'Tap to Play',
                    fontSize: width * .14,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w900,
                    colorOpacity: .95,
                    softWrap: true,
                    glowColor:
                        Provider.of<AppColorController>(context).getColors().glowColor,
                    shadows: [],
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  GAFText(
                    'Swipe anywhere to steer',
                    fontSize: width * .04,
                    textAlign: TextAlign.center,
                    colorOpacity: .7,
                    softWrap: true,
                    shadows: [],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}