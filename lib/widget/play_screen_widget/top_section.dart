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
    var colors = context.watch<AppColorController>().getColors();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * .02),
      decoration: BoxDecoration(
        color: colors.menuColor.withOpacity(.35),
        borderRadius: BorderRadius.circular(width * .035),
        border: Border.all(color: colors.glowColor.withOpacity(.35)),
        boxShadow: [
          BoxShadow(
            color: colors.glowColor.withOpacity(.18),
            blurRadius: width * .03,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: width * .02, vertical: width * .015),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BannerWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HudChip(
                label: 'LEVEL',
                value: '$title',
                size: fontSize * 1.1,
              ),
            ],
          ),
          TimerLine(
            isReward: isReward,
          ),
          ScoreLine(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  final String? label;
  final String? value;
  final double? size;

  const _HudChip({this.label, this.value, this.size});

  @override
  Widget build(BuildContext context) {
    var colors = context.watch<AppColorController>().getColors();
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * .03, vertical: height * .003),
      decoration: BoxDecoration(
        color: colors.basicColor.withOpacity(.7),
        borderRadius: BorderRadius.circular(width * .02),
        border: Border.all(color: colors.glowColor.withOpacity(.4)),
      ),
      child: GAFText(
        value,
        fontSize: size ?? fontSize,
        fontWeight: FontWeight.w900,
        glowColor: colors.glowColor,
        colors: colors.fontColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HudBadge extends StatelessWidget {
  final Color accent;
  final String label;
  final String value;
  final bool bold;

  const _HudBadge({
    required this.accent,
    required this.label,
    required this.value,
    this.bold = true,
  });

  @override
  Widget build(BuildContext context) {
    var colors = context.watch<AppColorController>().getColors();
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * .02, vertical: height * .002),
        decoration: BoxDecoration(
          color: colors.menuColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(width * .02),
          border: Border.all(color: accent.withOpacity(.55)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(.25),
              blurRadius: width * .02,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GAFText(
              label,
              fontSize: fontSize * .75,
              colorOpacity: .7,
            ),
            AnimatedNumber(
              target: value,
              bold: bold,
              accent: accent,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedNumber extends StatefulWidget {
  final String target;
  final bool bold;
  final Color accent;

  const AnimatedNumber({
    super.key,
    required this.target,
    required this.bold,
    required this.accent,
  });

  @override
  _AnimatedNumberState createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber> {
  int _from = 0;

  @override
  void didUpdateWidget(covariant AnimatedNumber old) {
    super.didUpdateWidget(old);
    if (old.target != widget.target) {
      _from = int.tryParse(old.target) ?? _from;
    }
  }

  int get _to => int.tryParse(widget.target) ?? 0;

  @override
  Widget build(BuildContext context) {
    if (_to == _from) {
      return _text('${widget.target}');
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _from.toDouble(), end: _to.toDouble()),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => _text('${v.round()}'),
    );
  }

  Widget _text(String text) {
    final colors = context.watch<AppColorController>().getColors();
    return GAFText(
      text,
      fontSize: fontSize,
      fontWeight: widget.bold ? FontWeight.w900 : FontWeight.normal,
      glowColor: widget.accent,
      colors: widget.bold ? colors.fontColor : null,
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
          children: [
            GAFText(
              'play time : ${GameTimer.showTimer()}',
              fontSize: fontSize,
            ),
            isReward ? SizedBox(height: width * .01) : const SizedBox.shrink(),
            isReward ? Reward() : const SizedBox.shrink(),
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
            color: color.getColors().menuColor,
            borderRadius: BorderRadius.circular(width * .03),
            border:
                Border.all(color: color.getColors().glowColor.withOpacity(.5)),
            boxShadow: [
              BoxShadow(
                color: color.getColors().glowColor.withOpacity(.35),
                blurRadius: width * .02,
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(avaWidth * .01),
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
                size: avaWidth * .07,
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
  });

  @override
  Widget build(BuildContext context) {
    var stage = context.watch<StagePlay>().level;
    var data = context.watch<StagePlay>();
    var colors = context.watch<AppColorController>().getColors();
    var score = '${data.stageCurrentScore()}';
    var isBroken = data.isTargetBroken();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (stage?.rank != 0)
          _HudBadge(
            accent: colors.glowColor,
            label: 'TARGET',
            value: '${stage!.targetScore}',
          ),
        _HudBadge(
          accent: isBroken && stage?.rank != 0 ? colors.glowColor : colors.foodColor,
          label: 'SCORE',
          value: score,
          bold: isBroken,
        ),
        FutureBuilder(
          builder: (_, hScore) {
            context.read<StagePlay>().readHScore(hScore.data ?? 0);
            return _HudBadge(
              accent: colors.glowColor,
              label: 'HIGH',
              value: '${hScore.data ?? 0}',
            );
          },
          future: context.read<StagePlay>().controller?.getLevelHighScore(),
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
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * .02, vertical: height * .002),
      decoration: BoxDecoration(
        color: context
            .watch<AppColorController>()
            .getColors()
            .glowColor
            .withOpacity(.15),
        borderRadius: BorderRadius.circular(width * .02),
        border: Border.all(
          color: context
              .watch<AppColorController>()
              .getColors()
              .glowColor
              .withOpacity(.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GAFText(
            stage!.reward,
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            softWrap: true,
            glowColor: context
                .watch<AppColorController>()
                .getColors()
                .glowColor,
          ),
          const SizedBox(
            width: 5,
          ),
          GAFText(
            '${stage.sec == 0 ? '' : stage.sec}',
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }
}