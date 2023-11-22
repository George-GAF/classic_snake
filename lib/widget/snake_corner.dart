import 'package:classic_snake/viewmodel/app_color.dart';
import 'package:classic_snake/viewmodel/game_size.dart';
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
    return Stack(
      children: [
        Container(
          margin: snakeMargin,
          decoration: BoxDecoration(
              color: colorSnake,
              borderRadius: corner,
              boxShadow: [
                BoxShadow(
                  color: Provider.of<AppColorController>(context)
                      .getColors()
                      .darkShadow,
                  offset: Offset(space, space),
                ),
                BoxShadow(
                  color: Provider.of<AppColorController>(context)
                      .getColors()
                      .lightShadow,
                  offset: Offset(-space, -space),
                ),
              ]),
        ),
        Container(
          margin: backMargin,
          decoration: BoxDecoration(
            color:
                Provider.of<AppColorController>(context).getColors().basicColor,
            borderRadius: corner,
          ),
        ),
      ],
    );
  }
}
