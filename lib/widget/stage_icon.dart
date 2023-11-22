import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/level_model.dart';
import '../screen/play_screen.dart';
import '../viewmodel/app_color.dart';
import '../viewmodel/game_size.dart';
import '../viewmodel/level_controller.dart';
import '../viewmodel/manager.dart';
import 'gaf_text.dart';

double _height = GameSize().height();
double _width = GameSize().width();

class StageIcon extends StatelessWidget {
  final String? text;
  final int? stageId;

  void goToPlayScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PlayScreen(
          stage: levelList[stageId!],
        ),
      ),
    );

    Manager.startGame();
  }

  StageIcon({this.text, this.stageId});

  bool enable = false;

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
