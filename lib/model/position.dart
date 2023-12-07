import 'package:classic_snake/view_model/game_size.dart';

class Position {
  final int index;
  int? rowNum;
  int? colNum;
  final int _maxColNum = GameSize().cellInRow();

  Position(this.index) {
    rowNum = index ~/ _maxColNum;
    colNum = index - (_maxColNum * rowNum!);
  }
}
