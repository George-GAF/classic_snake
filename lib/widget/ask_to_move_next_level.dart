import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stagePlay.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GAFText(
          "🎉 Congratulations 🎉",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: space,
        ),
        GAFText(
          "🐍 Snake Master! 🐍",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: space,
        ),
        GAFText(
          "You've slithered through the level like a pro. Ready to take it up a notch?.",
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
            text: "YES🔥! Bring on the next challenge,I’m unstoppable! 🐍🔥",
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
            text: "NOPE, let me dominate this level a bit longer! 😎",
          ),
        )
      ],
    );
  }
}
