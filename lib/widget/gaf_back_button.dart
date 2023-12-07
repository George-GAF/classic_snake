import 'package:classic_snake/view_model/app_color.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../view_model/sound_controller.dart';

class GAFBackButton extends StatelessWidget {
  final Function? onPressed;

  const GAFBackButton({
   required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        GameSound.playSoundEffect(KButtonClick);
        onPressed!();
        },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(GameSize().avaWidth() * .015),
        decoration: BoxDecoration(
          color:
              Provider.of<AppColorController>(context).getColors().basicColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
                color: Provider.of<AppColorController>(context)
                    .getColors()
                    .lightShadow,
                offset: Offset(-1, -1),
                blurRadius: 3),
            BoxShadow(
                color: Provider.of<AppColorController>(context)
                    .getColors()
                    .darkShadow,
                offset: Offset(1, 1),
                blurRadius: 3)
          ],
        ),
        child: Icon(
          Icons.arrow_back,
          size: GameSize().avaWidth() * .08,
          color: Provider.of<AppColorController>(context).getColors().fontColor,
        ),
      ),
    );
  }
}
