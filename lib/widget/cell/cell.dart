import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stagePlay.dart';
import '../../view_model/app_color.dart';
import '../../constant/enum_file.dart';
import '../../view_model/game_size.dart';
import '../../view_model/manager.dart';
import '../snake_corner.dart';
import '../snake_eye.dart';

int _cellSize = GameSize().cellSize();
double _height = GameSize().height();
int _cellInRow = GameSize().cellInRow();
int _netHeight = GameSize().netHeight();

class Cell extends StatelessWidget {
  final int id;
  final CellType cellType;

  Cell(
    this.cellType,
    this.id,
  );
  @override
  Widget build(BuildContext context) {
    CellProp cellProp = CellProp(context, cellType, id);
    return RotatedBox(
      quarterTurns: cellProp.angle,
      child: AnimatedContainer(
        alignment: AlignmentDirectional.center,
        child: cellProp.child,
        padding: cellProp.padding,
        margin: cellProp.margin,
        duration: Duration(milliseconds: Manager.gameSpeed),
        decoration: cellProp.decoration,
      ),
    );
  }
}

//------------------- helper part --------------------------

List<BoxShadow> _shadowList(double space) {
  return [
    BoxShadow(
      color: Color.fromRGBO(71, 120, 254, 1),
      offset: Offset(space, space),
    ),
    BoxShadow(
      color: Color.fromRGBO(50, 50, 50, .7),
      offset: Offset(-space, -space),
    )
  ];
}

class CellProp {
  BorderRadius? borderRadius;
  BoxDecoration? decoration;
  EdgeInsets margin = EdgeInsets.all(0);
  EdgeInsets padding = EdgeInsets.all(0);
  Widget child = SizedBox();
  int angle = 0;

  CellProp(BuildContext context, CellType cellType, int id) {
    // var colors = context.watch<AppColorController>();
    double? _space;
    double? _radius;
    // -------------------------------- blocks
    if (CellType.Block == cellType) {
      _space = _cellSize * .12;
      child = Container(
        width: _cellSize / 2,
        height: _cellSize / 2,
        decoration: BoxDecoration(
          color: Color.fromRGBO(71, 120, 254, 1),
          borderRadius: BorderRadius.circular(_cellSize * .5),
        ),
      );

      decoration = BoxDecoration(
        color: Color.fromRGBO(67, 67, 67, 1),
        borderRadius: BorderRadius.circular(0),
        boxShadow: _shadowList(_space),
      );
      //------------------------------- snake
    } else if (CellType.Snake == cellType) {
      var snake = context.watch<StagePlay>().snake!.getBody();
      Color color =
          Manager.isMustChangeSnakeColor ? Colors.blue : Colors.white70;
      int index = snake.indexOf(id);
      angle = 0;
      if (snake.last == id) {
        _space = _cellSize * .12;
        double headM = _cellSize * .08;

        var dir = context.watch<StagePlay>().getDirect();
        if (dir == Direct.Right)
          angle = 1;
        else if (dir == Direct.Down)
          angle = 2;
        else if (dir == Direct.Left) angle = 3;
        child = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SnakeEye(),
            SnakeEye(),
          ],
        );
        padding = EdgeInsets.only(top: _height * .005);
        margin = EdgeInsets.symmetric(horizontal: headM);
        decoration = BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(_cellSize / 2),
          boxShadow: _shadowList(_space),
        );
      } else if (snake[0] != id &&
          isCorner(snake[index - 1], snake[index + 1])) {
        // add corner shape
        angle = getCornerAngle(snake[index - 1], id, snake[index + 1]);
        var cellMargin = _cellSize * .2;
        var cornerRadius = Radius.circular(_cellSize * .4);
        borderRadius = BorderRadius.circular(_cellSize / 6);
        child = SnakeCorner(
          colorSnake: color,
          backMargin:
              EdgeInsets.only(left: cellMargin * 4, bottom: cellMargin * 4),
          corner: BorderRadius.only(bottomLeft: cornerRadius),
          snakeMargin: EdgeInsets.only(left: cellMargin, bottom: cellMargin),
        );
      } else {
        _space = _cellSize * .12;
        int step = snake[index] == snake[index + 1] ? 2 : 1;
        var isHors = rowNum(GameSize().cellInRow(), snake[index + step]) ==
            rowNum(GameSize().cellInRow(), snake[index]);
        angle = isHors ? 1 : 0;
        margin = EdgeInsets.symmetric(horizontal: _cellSize * .2);
        decoration = BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(_cellSize / 6),
          boxShadow: _shadowList(_space),
        );
      }
    } else if (CellType.Food == cellType) {
      _space = _cellSize * .07;
      _radius = _cellSize / 6;
      margin = EdgeInsets.all(_cellSize / 4);
      decoration = BoxDecoration(
        color: Color.fromRGBO(0, 255, 0, 1),
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: _shadowList(_space),
      );
    } else if (CellType.SpecialFood == cellType) {
      _radius = _cellSize / 2;
      child = Icon(
        Icons.question_mark_outlined,
        size: _cellSize.toDouble(),
        color: Colors.white,
      );
      decoration = BoxDecoration(
        color: Color.fromRGBO(0, 255, 0, 1),
        borderRadius: BorderRadius.circular(_radius),
      );
      //----------------- Ground
    }
  }

  int rowNum(int colNum, int index) {
    return index ~/ colNum;
  }

  int columnNum(int colNum, int index) {
    return index % colNum;
  }

  bool isCorner(int prev, int next) {
    int columnsNum = GameSize().cellInRow();
    return rowNum(columnsNum, prev) != rowNum(columnsNum, next) &&
        columnNum(columnsNum, prev) != columnNum(columnsNum, next);
  }

  int getCornerAngle(int prevIndex, int cur, int nextIndex) {
    //int cN = GameSize().cellInRow(); // columns num
    int prev = prevIndex - cur;
    int next = cur - nextIndex;

    if (_isLeftBottom(next, prev))
      return 0;
    else if (_isLeftTop(next, prev))
      return 1;
    else if (_isRightTop(next, prev))
      return 2;
    else
      return 3;
  }

  bool _isLeftTop(int next, int prev) {
    //1
    return (prev == 1 && next == -_cellInRow) ||
        (prev == _cellInRow && next == -1) ||
        (next - prev) == -1 ||
        (next - prev) == _netHeight - 1;
  }

  bool _isRightTop(int next, int prev) {
    // 2
    return (prev == -1 && next == -_cellInRow) ||
        (prev == _cellInRow && next == 1) ||
        (next - prev) == -(_cellInRow * 2) + 1 ||
        (next - prev) == _netHeight + 1;
  }

  bool _isLeftBottom(int next, int prev) {
    // 4
    return (prev == 1 && next == _cellInRow) ||
        (prev == -_cellInRow && next == -1) ||
        (next - prev) == (_cellInRow * 2) - 1 ||
        (next - prev) == -(_netHeight + 1);
  }
}
