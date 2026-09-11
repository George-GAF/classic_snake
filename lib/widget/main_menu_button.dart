import 'package:classic_snake/view_model/app_color.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/widget/gaf_text.dart';
import 'package:classic_snake/widget/neon_pressable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../view_model/sound_controller.dart';

double _height = GameSize().height();
double _width = GameSize().width();

class MainMenuButton extends StatelessWidget {
  final String? label;
  final Function? onPressed;
  final double? padding;
  final double? fontSize;
  final Color? color;
  final bool? showImage;

  const MainMenuButton(
      {this.label,
      this.padding,
      this.fontSize,
      this.onPressed,
      this.color,
      this.showImage});

  @override
  Widget build(BuildContext context) {
    return NeonPressable(
      onTap: () {
        GameSound.playSoundEffect(KButtonClick);
        onPressed!();
      },
      builder: (context, down) {
        var colors =
            Provider.of<AppColorController>(context).getColors();
        return Container(
          margin: EdgeInsets.symmetric(vertical: _width * .02),
          width: MediaQuery.of(context).size.width - (padding ?? 50),
          padding: EdgeInsets.symmetric(vertical: _height * .015),
          decoration: BoxDecoration(
            color: (color ?? colors.menuColor).withOpacity(.7),
            borderRadius: BorderRadius.circular(_height),
            border: Border.all(
              color: colors.glowColor.withOpacity(down ? .95 : .3),
              width: down ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.glowColor.withOpacity(down ? .8 : .2),
                blurRadius: _width * (down ? .05 : .02),
                spreadRadius: down ? 1 : 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showImage ?? false
                  ? Container(
                      height: _height * .05,
                      width: _width * .06,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Image(
                        image: AssetImage('assets/images/snakehead.png'),
                      ),
                    )
                  : const SizedBox(),
              GAFText(
                label,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                colorOpacity: 0.9,
                glowColor: colors.glowColor.withOpacity(.4),
              ),
            ],
          ),
        );
      },
    );
  }
}