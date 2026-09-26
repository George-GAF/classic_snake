import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stagePlay.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../view_model/timer_controller.dart';
import 'gaf_button.dart';
import 'gaf_item.dart';
import 'gaf_text.dart';

class AskToMoveNextLevel extends StatelessWidget {
  const AskToMoveNextLevel({super.key});

  @override
  Widget build(BuildContext context) {
    var rate = 1.55;
    var space = GameSize().height() * .025;
    var width = GameSize().width();
    final play = context.watch<StagePlay>();
    final colors = context.watch<AppColorController>().getColors();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GAFText(
          "CONGRATULATIONS",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: space,
        ),
        GAFText(
          "SNAKE MASTER!",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: space,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final filled = i < play.earnedStars;
            return Icon(
              filled ? Icons.star : Icons.star_border,
              size: width * .08,
              color:
                  filled ? colors.glowColor : colors.fontColor.withOpacity(.35),
            );
          }),
        ),
        SizedBox(
          height: space * .5,
        ),
        GAFText(
          '${play.earnedStars} / 3',
          fontSize: 16,
          colorOpacity: .7,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: space * .5,
        ),
        _ResultRow(
          label: 'TIME',
          value: StagePlay.formatTime(play.earnedTime),
          width: width * .55,
          glow: colors.glowColor,
        ),
        _ResultRow(
          label: 'PAR',
          value: StagePlay.formatTime(play.level!.targetTime),
          width: width * .55,
          glow: colors.glowColor,
        ),
        _ResultRow(
          label: 'BEST',
          value: play.bestTime > 0 ? StagePlay.formatTime(play.bestTime) : '--',
          width: width * .55,
          glow: colors.glowColor,
        ),
        SizedBox(
          height: space,
        ),
        GAFText(
          "You've slithered through the level like a pro.\nReady to take it up a notch?",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: space,
        ),
        GAFItem(
          paddingH: 0,
          paddingV: 0,
          child: GAFButton(
            heightRate: rate,
            isCenter: true,
            onPressed: () {
              var tempId = Manager.currentStageID + 1;
              Manager.gameOver = true;
              context.read<StagePlay>().endGame();
              Manager.restartPressed = true;
              context.read<StagePlay>().start(tempId);
              context.read<StagePlay>().showMenu = false;
            },
            text: "YES! BRING ON THE NEXT CHALLENGE — I'M UNSTOPPABLE",
          ),
        ),
        SizedBox(
          height: space,
        ),
        GAFItem(
          paddingH: 0,
          paddingV: 0,
          child: GAFButton(
            heightRate: rate,
            isCenter: true,
            onPressed: () {
              Manager.isPause = false;
              GameTimer.manageTimer();
              context.read<StagePlay>().gamePlay();
              context.read<StagePlay>().showMenu = false;
              context.read<StagePlay>().showAskMenu = false;
            },
            text: "NOT YET — I'LL DOMINATE THIS LEVEL A BIT LONGER",
          ),
        )
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final double width;
  final Color glow;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.width,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GAFText(
            label,
            fontSize: 16,
            colorOpacity: .7,
            fontWeight: FontWeight.bold,
          ),
          GAFText(
            value,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            glowColor: glow,
          ),
        ],
      ),
    );
  }
}
