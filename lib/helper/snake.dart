import 'package:classic_snake/view_model/manager.dart';

import '../constant/enum_file.dart';
import '../constant/game_values.dart';
import '../view_model/game_size.dart';

class Snake {
  static const List<int> _snakeStarting = KSnakeStarting;
  late int head;
  late List<int> body;
  late Direct currentDir;

  Snake() {
    head = _snakeStarting.last;
    body = _snakeStarting;
    currentDir = Direct.Down;
  }

  void moving() {
    int newV;
    switch (currentDir) {
      case Direct.Up:
        newV = _moveUp(head);
        break;
      case Direct.Down:
        newV = _moveDown(head);
        break;
      case Direct.Right:
        newV = _moveRight(head);
        break;
      case Direct.Left:
        newV = _moveLeft(head);
        break;
    }
   // currentDir = direct;
    _update(newV);
  }

  void _update(int value) {
    body.add(value);
    body.removeAt(0);
    head = body.last;
    Manager.snake = body;
  }

  FoodType eating(int food, List<int> giftFood, int sFood) {
    if (head == food) {
      _update(food);
      return FoodType.Food;
    }
    if (giftFood.contains(head)) {
      _update(head);
      return FoodType.GiftFood;
    }
    if (head == sFood) {
      return FoodType.SFood;
    }
    return FoodType.None;
  }

  bool isDie(bool isImmortal, List<int> blocks) {
    if (isImmortal) {
      return false;
    }
    if (blocks.contains(head)) {
      return true;
    }
    int rep = body.where((i) => head == i).length;
    if (rep > 1) return true;

    return false;
  }

//--------------------------------------------------------------------------------------------
  //                    Helper Function
  int _moveUp(int num) {
    int newV = num;
    newV -= GameSize().cellInRow();
    if (newV < 0) newV += GameSize.boxCount();
    return newV;
  }

  int _moveDown(int num) {
    int newV = num;
    newV += GameSize().cellInRow();
    if (newV >= GameSize.boxCount()) newV -= GameSize.boxCount();
    return newV;
  }

  int _moveLeft(int num) {
    int newV = num;
    if (Manager.isFirstCellInRow(newV))
      newV += (GameSize().cellInRow() - 1);
    else
      newV -= 1;
    return newV;
  }

  int _moveRight(int num) {
    int newV = num;
    if (Manager.isLastCellInRow(newV))
      newV -= (GameSize().cellInRow() - 1);
    else
      newV += 1;
    return newV;
  }




}
