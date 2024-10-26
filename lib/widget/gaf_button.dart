import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../view_model/sound_controller.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import 'gaf_text.dart';

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
    return SizedBox(
      height: buttonH,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, double.infinity),
          backgroundColor:
              Provider.of<AppColorController>(context).getColors().basicColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonH / 2),
          ),
        ),
        onPressed: () {
          GameSound.playSoundEffect(KButtonClick);
          onPressed!();
        },
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: startSpace ?? 0,
              ),
              Icon(
                icon,
                size: GameSize().width() * .055,
                color: Provider.of<AppColorController>(context)
                    .getColors()
                    .fontColor,
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
        ),
      ),
    );
  }
}
