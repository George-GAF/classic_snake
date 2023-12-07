import 'package:classic_snake/providers/stagePlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/level_model.dart';
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
  late final bool enable ;

  void goToPlayScreen(BuildContext context) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PlayScreen(),
      ),
    );
    Provider.of<StagePlay>(context).start(levelList[stageId!]);
  }

  StageIcon({this.text, this.stageId});

  Future isOpen() async {
    if (stageId == 0) {
      enable = true;
    } else {
      LevelController level = LevelController(stageId! - 1);
      enable = await level.getLevelState();
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = (_width - (_width * .05)) / 3;
    double shadowSpace = _width * .008;
    return InkWell(
      onTap: () {
        if (enable) goToPlayScreen(context);
      },
      child: Consumer<AppColorController>(
        builder: (cont, color, child) {
          return FutureBuilder(
            builder: (cont, snap) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: GAFText(
                  text == '0' ? 'Survival' : text,
                  fontSize:
                      text == '0' ? _width * .06 : _width * .2,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  colors: enable
                      ? null
                      : Provider.of<AppColorController>(context)
                          .getColors()
                          .fontColor
                          .withOpacity(.6),
                ),
                width: iconSize,
                height: iconSize,
                margin: EdgeInsets.symmetric(
                    vertical: _height * .01,
                    horizontal: _width * .015),
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
            future: isOpen(),
          );
        },
      ),
    );
  }
}
