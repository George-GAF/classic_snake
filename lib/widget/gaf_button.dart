import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../view_model/sound_controller.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import 'gaf_text.dart';
import 'neon_pressable.dart';

class GAFButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final IconData? icon;
  final double? startSpace;
  final double heightRate;
  final bool isCenter;
  const GAFButton({
    this.startSpace,
    this.text,
    this.icon,
    required this.onPressed,
    this.heightRate = 1.0,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    double buttonH = GameSize().height() * .06 * heightRate;
    var width = GameSize().width();
    return NeonPressable(
      onTap: () {
        GameSound.playSoundEffect(KButtonClick);
        onPressed!();
      },
      builder: (context, down) {
        var colors = context.watch<AppColorController>().getColors();
        return Container(
          height: buttonH,
          padding: EdgeInsets.symmetric(horizontal: width * .04),
          decoration: BoxDecoration(
            color: colors.menuColor.withOpacity(.65),
            borderRadius: BorderRadius.circular(buttonH / 2),
            border: Border.all(
              color: colors.glowColor.withOpacity(down ? .9 : .3),
              width: down ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.glowColor.withOpacity(down ? .75 : .15),
                blurRadius: width * (down ? .045 : .015),
                spreadRadius: down ? 1 : 0,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: startSpace ?? 0,
              ),
              Icon(
                icon,
                size: GameSize().width() * .055,
                color: colors.fontColor,
              ),
              SizedBox(
                width: GameSize().width() * .02,
              ),
              Expanded(
                child: GAFText(
                  text,
                  fontSize: GameSize().width() * .045,
                  textAlign: isCenter ? TextAlign.center : TextAlign.start,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}