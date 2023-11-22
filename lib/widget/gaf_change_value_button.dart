import 'package:classic_snake/viewmodel/app_color.dart';
import 'package:classic_snake/viewmodel/game_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../viewmodel/sound_controller.dart';

class GAFChangeValueButton extends StatelessWidget {
  final Function? onStart;
  final Function? onPressed;
  final Function? onEnd;
  final IconData? icon;

  const GAFChangeValueButton(
      {this.onStart, this.onPressed, this.onEnd, this.icon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GameSound.playSoundEffect(KButtonClick);
        onPressed!();
      },
      onLongPress: () {
        onStart!();
      },
      onLongPressUp: () {
        onEnd!();
      },
      child: Icon(
        icon,
        size: GameSize().width() * .06,
        color: Provider.of<AppColorController>(context).getColors().fontColor,
      ),
    );
  }
}
