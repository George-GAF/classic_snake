import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/level_model.dart';
import '../providers/stagePlay.dart';
import '../screen/play_screen.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/level_controller.dart';
import 'gaf_text.dart';

double _height = GameSize().height();
double _width = GameSize().width();

class StageIcon extends StatelessWidget {
  final String? text;
  final int? stageId;
  //late final bool enable;

  void goToPlayScreen(BuildContext context) async {
    await Navigator.pushReplacementNamed(context, PlayScreen.routeName);
  }

  StageIcon({this.text, this.stageId});

  Future<(bool, int)> isOpen() async {
    if (stageId == 0) return (true, 0);
    final open = await LevelController(stageId! - 1).getLevelState();
    final stars = open ? await LevelController(stageId!).getLevelStars() : 0;
    return (open, stars);
  }

  @override
  Widget build(BuildContext context) {
    final stage = context.watch<StagePlay>();
    double iconSize = (_width - (_width * .05)) / 3;
    double shadowSpace = _width * .008;
    return FutureBuilder<(bool, int)>(
      builder: (cont, snap) {
        bool enable = false;
        if (snap.hasData) {
          enable = stageId == 0 ? true : snap.data!.$1;
          final stars = stageId == 0 ? 0 : snap.data!.$2;
          return InkWell(
            onTap: () {
              if (enable) {
                stage.start(stageId!);
                goToPlayScreen(context);
              }
            },
            child: Consumer<AppColorController>(
              builder: (cont, color, child) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: GAFText(
                            text == '0' ? 'Survival' : text,
                            fontSize: text == '0' ? _width * .06 : _width * .2,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            colors: enable
                                ? null
                                : Provider.of<AppColorController>(context)
                                    .getColors()
                                    .fontColor
                                    .withOpacity(.6),
                          ),
                        ),
                      ),
                      if (stars > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (i) {
                            final filled = i < stars;
                            return Icon(
                              filled ? Icons.star : Icons.star_border,
                              size: _width * .04,
                              color: filled
                                  ? color.getColors().glowColor
                                  : color
                                      .getColors()
                                      .fontColor
                                      .withOpacity(.35),
                            );
                          }),
                        ),
                      if (stars > 0)
                        GAFText(
                          'PAR '
                          '${StagePlay.formatTime(levelList[stageId!].targetTime)}',
                          fontSize: _width * .033,
                          fontWeight: FontWeight.w900,
                          colorOpacity: .7,
                          glowColor: color.getColors().glowColor,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                  width: iconSize,
                  height: iconSize,
                  margin: EdgeInsets.symmetric(
                      vertical: _height * .01, horizontal: _width * .015),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_height * .03),
                    color: color
                        .getColors()
                        .basicColor
                        .withOpacity(enable ? 1 : 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: color.getColors().darkShadow,
                        offset: Offset(-shadowSpace, -shadowSpace),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: color.getColors().lightShadow,
                        offset: Offset(shadowSpace, shadowSpace),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
      future: isOpen(),
    );
  }
}
