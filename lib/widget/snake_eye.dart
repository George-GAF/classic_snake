import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/app_color.dart';
import '../view_model/game_size.dart';

class SnakeEye extends StatelessWidget {
  final double? w;
  final double? h;

  const SnakeEye({this.w, this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<AppColorController>(context).getColors().fontColor,
        borderRadius: BorderRadius.circular(50),
      ),
      width: GameSize().width() * w!,
      height: GameSize().width() * h!,
    );
  }
}
