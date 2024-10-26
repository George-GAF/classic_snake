

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../gaf_package/ad_widget/banner_widget.dart';
import '../../model/level_model.dart';
import '../../providers/stagePlay.dart';
import '../../view_model/app_color.dart';
import '../../view_model/game_size.dart';
import '../../view_model/level_controller.dart';
import '../../view_model/manager.dart';
import '../../view_model/timer_controller.dart';
import '../gaf_text.dart';

double width = GameSize().width();
double height = GameSize().height();
double avaWidth = GameSize().avaWidth();

double fontSize = width * .04;

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
    var isReward = context.watch<StagePlay>().stage!.reward != '';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * .012),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (cont, snap) {
                return BannerWidget();
              }),
          GAFText(
            'Level : $title',
            fontWeight: FontWeight.w900,
            fontSize: fontSize * 1.1, //width * .04,

          ),
          TimerLine(
            isReward: isReward,
          ),
          ScoreLine(/*stage: stage, level: level*/),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}

class TimerLine extends StatelessWidget {
  final bool isReward;
  const TimerLine({
    super.key,
    required this.isReward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GAFText(
              'play time : ${GameTimer.showTimer()}',
              fontSize: fontSize, //width * .04,
            ),
            SizedBox(
              height: width * .03,
            ),
            isReward ? Reward() : SizedBox.shrink(),
          ],
        ),
        const GameSettingButton(),
      ],
    );
  }
}

class GameSettingButton extends StatelessWidget {
  const GameSettingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorController>(
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
                if (!Manager.isPause) context.read<StagePlay>().gamePlay();
                context.read<StagePlay>().setMenuState();
                Manager.sendToBackground = false;
              },
              child: Icon(
                Manager.sendToBackground ? Icons.pause : Icons.settings,
                color: color.getColors().fontColor,
                size: avaWidth * .08,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScoreLine extends StatelessWidget {
  const ScoreLine({
    super.key,
    // required this.stage,
    // required this.level,
  });
/*
  final LevelModel? stage;
  final LevelController? level;
*/
  @override
  Widget build(BuildContext context) {
    var stage = context.watch<StagePlay>().level;
    var level = context.watch<StagePlay>().controller;
    var child = stage?.rank != 0
        ? GAFText(
            'Target : ${stage?.targetScore} ',
            fontSize: fontSize, //width * .04,
          )
        : SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        child,
        SizedBox(
          width: stage?.rank != 0 ? width * .04 : 0,
        ),
        Consumer<StagePlay>(
          builder: (cont, data, child) {
            var isBroken = data.isTargetBroken();
            var fWeight = isBroken ? FontWeight.w900 : FontWeight.normal;
            var color = isBroken && stage!.rank != 0 ? Colors.green[900] : null;
            return GAFText(
              'Score : ${data.stageCurrentScore()}',
              fontSize: fontSize, // width * .04,
              fontWeight: fWeight,
              colors: color,
            );
          },
        ),
        SizedBox(
          width: width * .04,
        ),
        FutureBuilder(
          builder: (_, hScore) {
            context.watch<StagePlay>().readHScore(hScore.data ?? 0);
            return GAFText(
              'High Score : ${(hScore.data ?? 0)}',
              fontSize: width * .04,
              fontWeight: FontWeight.w900,
            );
          },
          future: level?.getLevelHighScore(),
        ),
      ],
    );
  }
}

class Reward extends StatelessWidget {
  const Reward({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var stage = context.watch<StagePlay>().stage;
    return Row(
      children: [
        GAFText(
          stage!.reward,
          fontWeight: FontWeight.w900,
          fontSize: fontSize, // width * .04,
          softWrap: true,
        ),
        const SizedBox(
          width: 5,
        ),
        GAFText(
          '${stage.sec == 0 ? '' : stage.sec}',
          fontWeight: FontWeight.w900,
          fontSize: fontSize, // width * .04,
        ),
      ],
    );
  }
}
