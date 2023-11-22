
import 'package:classic_snake/constant/constant.dart';
import 'package:classic_snake/viewmodel/sound_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/app_color.dart';
import '../viewmodel/game_size.dart';
import 'gaf_text.dart';

class GAFButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final IconData? icon;
  final double? startSpace;
  const GAFButton({this.startSpace, this.text, this.icon,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double buttonH = GameSize().height() * .06;
    return SizedBox(
      height: buttonH,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, double.infinity),
          backgroundColor: Provider.of<AppColorController>(context).getColors().basicColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonH / 2),
          ),
        ),
        onPressed: (){
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
              GAFText(
                text,
                fontSize: GameSize().width() * .045,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
