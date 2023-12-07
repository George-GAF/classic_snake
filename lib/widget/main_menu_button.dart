
import 'package:classic_snake/view_model/app_color.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/widget/gaf_text.dart';
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


    return Container(
      margin: EdgeInsets.symmetric(vertical: _width * .02),
      width: MediaQuery.of(context).size.width - (padding ?? 50),
      decoration: BoxDecoration(
          color: color ??
              Provider.of<AppColorController>(context).getColors().basicColor,
          borderRadius: BorderRadius.circular(_height),
          boxShadow: [
            BoxShadow(
              color: Provider.of<AppColorController>(context)
                  .getColors()
                  .darkShadow,
              offset: Offset(_width * .007, _width * .007),
              blurRadius: 5,
            ),
            BoxShadow(
              color: Provider.of<AppColorController>(context)
                  .getColors()
                  .lightShadow,
              offset: Offset(-_width * .007, -_width * .007),
              blurRadius: 5,
            )
          ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: _height * .015),
          backgroundColor: Provider.of<AppColorController>(context).getColors().basicColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed:() {
          GameSound.playSoundEffect(KButtonClick);
          onPressed!();
          },
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
                : SizedBox(),
            GAFText(
              label,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              colorOpacity: 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
