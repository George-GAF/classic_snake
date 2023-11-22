import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'manager.dart';
import 'snake.dart';

class AssManager {
  final BuildContext context;
  AssManager(this.context);

  void changeGameSpeed(int newSpeed) {
    Manager.isChangeGameSpeed = true;
    Duration d = Duration(milliseconds: Manager.gameSpeed);
    Manager.gameSpeed = newSpeed;
    Future.delayed(d, () {
      Manager.isChangeGameSpeed = false;
      Provider.of<Snake>(context, listen: false).moveSnake();
    });
  }
}
