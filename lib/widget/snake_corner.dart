
import 'package:flutter/material.dart';
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
    double space = GameSize().cellSize() * .12;
    //var colors = context.watch<AppColorController>().getColors();
    return Stack(
      children: [
        Container(
          margin: snakeMargin,
          decoration: BoxDecoration(
              color: colorSnake,
              borderRadius: corner,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(71, 120, 254, 1),
                  offset: Offset(space, space),
                ),
                BoxShadow(
                  color: Color.fromRGBO(50, 50, 50, .7),
                  offset: Offset(-space, -space),
                ),
              ]),
        ),
        Container(
          margin: backMargin,
          decoration: BoxDecoration(
            color: Color.fromRGBO(71, 148, 254, .7),
            borderRadius: corner,
          ),
        ),
      ],
    );
  }
}
