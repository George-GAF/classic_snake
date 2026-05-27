import 'package:flutter/material.dart';

import '../view_model/game_size.dart';

class SnakeEye extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var size = GameSize().cellSize() * .2;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
      width: size,
      height: size,
    );
  }
}
