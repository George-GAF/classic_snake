import 'package:classic_snake/viewmodel/app_color.dart';
import 'package:classic_snake/viewmodel/game_size.dart';
import 'package:classic_snake/widget/gaf_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../viewmodel/sound_controller.dart';

class GAFRaisedButton extends StatelessWidget {
  final String? label;
  final Function? onPressed;

  const GAFRaisedButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = GameSize().width();
    return GestureDetector(
      onTap: (){
        GameSound.playSoundEffect(KButtonClick);
        onPressed!();
        },
      child: Container(
        padding: EdgeInsets.all(width * .015),
        child: GAFText(
          label,
          fontWeight: FontWeight.bold,
          fontSize: width * .04,
          softWrap: true,
        ),
        decoration: BoxDecoration(
            color:
                Provider.of<AppColorController>(context).getColors().darkShadow,
            borderRadius: BorderRadius.circular(width * .15),
            boxShadow: [
              BoxShadow(
                  offset: Offset(width * .008, width * .008),
                  blurRadius: width * .02,
                  color: Provider.of<AppColorController>(context)
                      .getColors()
                      .basicColor),
              BoxShadow(
                  offset: Offset(-width * .008, -width * .008),
                  blurRadius: width * .02,
                  color: Provider.of<AppColorController>(context)
                      .getColors()
                      .lightShadow),
            ]),
      ),
    );
  }
}
