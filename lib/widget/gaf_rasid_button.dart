import 'package:classic_snake/view_model/app_color.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/widget/gaf_text.dart';
import 'package:classic_snake/widget/neon_pressable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../view_model/sound_controller.dart';

class GAFRaisedButton extends StatelessWidget {
  final String? label;
  final Function? onPressed;

  const GAFRaisedButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = GameSize().width();
    return NeonPressable(
      onTap: () {
        GameSound.playSoundEffect(KButtonClick);
        onPressed!();
      },
      builder: (context, down) {
        var colors =
            Provider.of<AppColorController>(context).getColors();
        return Container(
          padding: EdgeInsets.all(width * .015),
          decoration: BoxDecoration(
            color: colors.glowColor.withOpacity(.25),
            borderRadius: BorderRadius.circular(width * .15),
            border: Border.all(
              color: colors.glowColor.withOpacity(down ? .95 : .4),
              width: down ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.glowColor.withOpacity(down ? .85 : .2),
                blurRadius: width * (down ? .04 : .02),
              ),
            ],
          ),
          child: GAFText(
            label,
            fontWeight: FontWeight.bold,
            fontSize: width * .04,
            softWrap: true,
          ),
        );
      },
    );
  }
}