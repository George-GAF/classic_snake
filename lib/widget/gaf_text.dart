import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/app_color.dart';
import '../view_model/game_size.dart';

double _width = GameSize().width();

class GAFText extends StatelessWidget {
  final String? text;
  final double? colorOpacity;
  final Color? colors;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? softWrap;
  final List<Shadow>? shadows;


  const GAFText(this.text,
      { this.colorOpacity,
      this.softWrap,
      this.fontSize,
      this.fontWeight,
      this.shadows,
      this.textAlign,
      this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      softWrap: softWrap ?? true,
      textAlign: textAlign ?? TextAlign.start,
      textScaleFactor: 1,
       // textScaler:TextScaler.linear(1),
      style: TextStyle(
        color: colors ??
            Provider.of<AppColorController>(context)
                .getColors()
                .fontColor
                .withOpacity(colorOpacity ?? 1),
        fontSize: fontSize ?? 10,
        fontWeight: fontWeight ?? FontWeight.normal,
        shadows: shadows ??
            [
              Shadow(
                color: Provider.of<AppColorController>(context)
                    .getColors()
                    .fontShadow,
                offset: Offset(_width * .009, _width * .009),
                blurRadius: _width * .01,
              ),
            ],
      ),
    );
  }
}
