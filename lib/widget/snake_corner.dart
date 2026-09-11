import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/color_app.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';

class SnakeCorner extends StatelessWidget {
  final Color? colorSnake;
  final BorderRadiusGeometry? corner;
  final EdgeInsets? snakeMargin;
  final EdgeInsets? backMargin;

  const SnakeCorner(
      {this.colorSnake, this.corner, this.snakeMargin, this.backMargin});

  @override
  Widget build(BuildContext context) {
    AppColor colors =
        context.watch<AppColorController>().getColors();
    double space = GameSize().cellSize() * .12;
    return Stack(
      children: [
        Container(
          margin: snakeMargin,
          decoration: BoxDecoration(
              color: colorSnake,
              borderRadius: corner,
              boxShadow: [
                BoxShadow(
                  color: colors.darkShadow,
                  offset: Offset(space, space),
                ),
                BoxShadow(
                  color: colors.lightShadow,
                  offset: Offset(-space, -space),
                ),
                BoxShadow(
                  color: colors.glowColor.withOpacity(.3),
                  blurRadius: GameSize().cellSize() * .6,
                  spreadRadius: GameSize().cellSize() * .1,
                ),
              ]),
        ),
        Container(
          margin: backMargin,
          decoration: BoxDecoration(
            color: colors.glowColor.withOpacity(.5),
            borderRadius: corner,
          ),
        ),
      ],
    );
  }
}