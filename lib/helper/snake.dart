

import '../constant/enum_file.dart';
import '../constant/game_values.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';

class Snake {
  static const List<int> _snakeStarting = KSnakeStarting;

  late List<int> _body;
  late int _head;
  late Direct _currentDir;

  Snake() {
    _head = _snakeStarting.last;
    _body = _snakeStarting;
    _currentDir = Direct.Down;

  }

  String toString() {
    return '_head $_head snake $_body current Direct $_currentDir';
  }

  List<int> getBody() {
    return List<int>.from(_body);
  }

  Direct getDirect() {
    return _currentDir;
  }

  void setDirect(Direct newDirect) {
    _currentDir = newDirect;
  }

  void moving() {
    int newV;
    switch (_currentDir) {
      case Direct.Up:
        newV = _moveUp(_head);
        break;
      case Direct.Down:
        newV = _moveDown(_head);
        break;
      case Direct.Right:
        newV = _moveRight(_head);
        break;
      case Direct.Left:
        newV = _moveLeft(_head);
        break;
    }
    // _currentDir = direct;
    _update(newV);
  }

  void _update(int value, {bool isEat = false}) {
    final tBody = List<int>.from(_body);
    if (!isEat)
      tBody.add(value);
    else
      tBody.removeAt(0);
    _updateValues(tBody);
   }

  void _updateValues(List<int> tBody) {
    _body = tBody;
    _head = _body.last;
    Manager.snake = _body;
  }

  FoodType eating(int food, List<int> giftFood, int sFood) {
    if (_head == food) {
      return FoodType.Food;
    }
    if (giftFood.contains(_head)) {
      return FoodType.GiftFood;
    }
    if (_head == sFood) {
      _update(0, isEat: true);
      return FoodType.SFood;
    }
    _update(0, isEat: true);
    return FoodType.None;
  }

  bool isDie(bool isImmortal, List<int> blocks) {
    if (isImmortal) {
      return false;
    }
    if (blocks.contains(_head)) {
      return true;
    }
    int rep = _body.where((i) => _head == i).length;
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
