import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnakeCorner extends StatelessWidget {
  final Color? colorSnake;
  final BorderRadiusGeometry? corner;
  final EdgeInsets? snakeMargin;
  final EdgeInsets? backMargin;

  const SnakeCorner(
      {this.colorSnake, this.corner, this.snakeMargin, this.backMargin});

  @override
  Widget build(BuildContext context) {
    double space = GameSize().cellSize() * .12;
    var colors = context.watch<AppColorController>().getColors();
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
              ]),
        ),
        Container(
          margin: backMargin,
          decoration: BoxDecoration(
            color: colors.basicColor,
            borderRadius: corner,
          ),
        ),
      ],
    );
  }
}
