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
  final Color? glowColor;
  final double? letterSpacing;
  final String? fontFamily;

  const GAFText(this.text,
      { this.colorOpacity,
      this.softWrap,
      this.fontSize,
      this.fontWeight,
      this.shadows,
      this.glowColor,
      this.letterSpacing,
      this.fontFamily,
      this.textAlign,
      this.colors});

  @override
  Widget build(BuildContext context) {
    final themeColor =
        Provider.of<AppColorController>(context).getColors();
    List<Shadow>? _shadows = shadows;
    if (_shadows == null) {
      _shadows = [
        Shadow(
          color: themeColor.fontShadow,
          offset: Offset(_width * .009, _width * .009),
          blurRadius: _width * .01,
        ),
      ];
      if (glowColor != null) {
        _shadows.add(Shadow(
          color: glowColor!,
          blurRadius: (fontSize ?? 10) * .6,
        ));
      }
    }
    return Text(
      text!,
      softWrap: softWrap ?? true,
      textAlign: textAlign ?? TextAlign.start,
      textScaler: TextScaler.linear(1),
      style: TextStyle(
        color: colors ??
            themeColor.fontColor
                .withOpacity(colorOpacity ?? 1),
        fontSize: fontSize ?? 10,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        shadows: _shadows,
      ),
    );
  }
}
