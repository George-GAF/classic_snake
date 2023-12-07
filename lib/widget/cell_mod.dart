import 'package:classic_snake/providers/stagePlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/enum_file.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import 'snake_corner.dart';
import 'snake_eye.dart';

int _cellSize = GameSize().cellSize();
double _height = GameSize().height();
double _width = GameSize().width();
int _cellInRow = GameSize().cellInRow();
int _netHeight = GameSize().netHeight();

class CellMod extends StatelessWidget {
  final int id;
  final CellType cellType;

  CellMod(
    this.cellType,
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    CellProperties _cellProperties = CellProperties(cellType, context, id);
    return AnimatedContainer(
      alignment: AlignmentDirectional.center,
      child: _cellProperties.child,
      padding: _cellProperties.padding,
      margin: _cellProperties.margin,
      duration: Duration(milliseconds: Manager.gameSpeed),
      decoration: BoxDecoration(
        color: _cellProperties.color,
        borderRadius: _cellProperties.borderRadius,
        boxShadow: _cellProperties.listBoxShadow,
      ),
    );
  }
}

class CellProperties {
  final CellType cellType;
  final int i;
  final BuildContext context;
   EdgeInsets? margin;
   EdgeInsets? padding;
   BorderRadius? borderRadius;
  late  Color? color;
  late  List<BoxShadow>? listBoxShadow;
  Widget child = SizedBox();


  CellProperties(this.cellType, this.context, this.i) {
    final stage= Provider.of<StagePlay>(context);
    bool isCorner = false;
    padding = EdgeInsets.all(0);
    margin = cellType == CellType.Food || cellType == CellType.GiftFood
        ? EdgeInsets.all(_cellSize / 4)
        : EdgeInsets.all(0);
    final space = (cellType == CellType.Food ||
            cellType == CellType.GiftFood ||
            cellType == CellType.SpecialFood)
        ? _cellSize * .07
        : _cellSize * .12;
    final double _radius = cellType == CellType.Ground ||
            cellType == CellType.Block ||
            cellType == CellType.SpecialFood
        ? 0
        : _cellSize / 6;
    color = Provider.of<AppColorController>(context)
        .getColors()
        .playStageColor[cellType.index];
    borderRadius = BorderRadius.circular(_radius);
    if (cellType == CellType.Snake) {
      if (Manager.isMustChangeSnakeColor) {
        color = Provider.of<AppColorController>(context).getColors().fontShadow;
      }
      if (Provider.of<StagePlay>(context).cellType == CellType.Head) {
        borderRadius = BorderRadius.circular(_cellSize / 2);
        double headM = _cellSize * .08;
        if (Provider.of<StagePlay>(context).getDirect() == Direct.Up) {
          child = Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [SnakeEye(w: .01, h: .015), SnakeEye(w: .01, h: .015)],
          );
          padding = EdgeInsets.only(top: _height * .005);
          margin = EdgeInsets.symmetric(horizontal: headM);
        } else if (Provider.of<StagePlay>(context).getDirect() == Direct.Right) {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [SnakeEye(w: .015, h: .01), SnakeEye(w: .015, h: .01)],
          );
          padding = EdgeInsets.only(right: _width * .006);
          margin = EdgeInsets.symmetric(vertical: headM);
        } else if (Provider.of<StagePlay>(context).getDirect() == Direct.Left) {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [SnakeEye(w: .015, h: .01), SnakeEye(w: .015, h: .01)],
          );
          padding = EdgeInsets.only(left: _width * .006);
          margin = EdgeInsets.symmetric(vertical: headM);
        } else if (Provider.of<StagePlay>(context).getDirect() == Direct.Down) {
          child = Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [SnakeEye(w: .01, h: .015), SnakeEye(w: .01, h: .015)],
          );
          padding = EdgeInsets.only(bottom: _height * .005);
          margin = EdgeInsets.symmetric(horizontal: headM);
        }
      } else {
        int _index = stage.snake!.body.indexOf(i);
        final Radius _cornerRadius = Radius.circular(_cellSize * .4);
        final double _cellMargin = _cellSize * .2;

        int next =
            (stage.snake!.body[_index] - stage.snake!.body[_index + 1]);

        int prev;
        if (_index != 0)
          prev = (stage.snake!.body[_index - 1] - stage.snake!.body[_index]);
        else
          prev = 0;

        if (next.abs() == prev.abs() ||
            (next + prev).abs() == _cellInRow - 2 ||
            (next + prev).abs() ==
                GameSize.boxCount() - (_cellInRow* 2)) {
          if (_isNextCellVertical(next.abs())) {
            margin = EdgeInsets.symmetric(horizontal: _cellMargin);
          } else if (_isNextCellHorizontal(next.abs())) {
            margin = EdgeInsets.symmetric(vertical: _cellMargin);
          }
        } else if (prev == 0) {
          if (_isNextCellVertical(next)) {
            margin = EdgeInsets.symmetric(horizontal: _cellMargin);
          } else if (_isNextCellHorizontal(next)) {
            margin = EdgeInsets.symmetric(vertical: _cellMargin);
          }
        } else if (_isCorner(next, prev)) {
          if (_isRightBottom(next, prev)) {
            child = _rightBottom(color!, _cellMargin, _cornerRadius);
          } else if (_isLeftBottom(next, prev)) {
            child = _leftBottom(color!, _cellMargin, _cornerRadius);
          } else if (_isRightTop(next, prev)) {
            child = _rightTop(color!, _cellMargin, _cornerRadius);
          } else if (_isLeftTop(next, prev)) {
            child = _leftTop(color!, _cellMargin, _cornerRadius);
          }
          color = Colors.transparent;
          margin = EdgeInsets.all(0);
          isCorner = true;
        } else {}
      }
    } else if (cellType == CellType.Block) {
      child = Container(
        width: _cellSize / 2,
        height: _cellSize / 2,
        decoration: BoxDecoration(
          color:
              Provider.of<AppColorController>(context).getColors().darkShadow,
          borderRadius: BorderRadius.circular(_cellSize * .5),
        ),
      );
    } else if (cellType == CellType.SpecialFood) {
      child = MysteriousFood();
    }
    listBoxShadow = cellType == CellType.Ground ||
            isCorner ||
            cellType == CellType.SpecialFood
        ? []
        : [
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
            )
          ];
  }
}

bool _isCorner(int next, int prev) {
  return (next.abs() == _cellInRow&& prev.abs() == 1) ||
      (next.abs() == 1 && prev.abs() == _cellInRow) ||
      (next + prev).abs() == _netHeight + 1 ||
      (next + prev).abs() == _netHeight - 1 ||
      (next + prev).abs() == 1 ||
      (next + prev).abs() == (_cellInRow* 2) - 1;
}

bool _isNextCellVertical(int index) {
  return (index == _cellInRow||
      index == -_cellInRow||
      index == _netHeight ||
      index == -_netHeight);
}

bool _isNextCellHorizontal(int index) {
  return (index == 1 ||
      index == -1 ||
      Manager.isLastCellInRow(index) ||
      Manager.isFirstCellInRow(index));
}

bool _isLeftTop(int next, int prev) {
  //1
  return (prev == 1 && next == -_cellInRow) ||
      (prev == _cellInRow&& next == -1) ||
      (next - prev) == -1 ||
      (next - prev) == _netHeight - 1;
}

bool _isRightTop(int next, int prev) {
  // 2
  return (prev == -1 && next == -_cellInRow) ||
      (prev == _cellInRow&& next == 1) ||
      (next - prev) == -(_cellInRow* 2) + 1 ||
      (next - prev) == _netHeight + 1;
}

bool _isRightBottom(int next, int prev) {
  // 3
  return (prev == -1 && next == _cellInRow) ||
      (prev == -_cellInRow&& next == 1) ||
      (next - prev) == 1 ||
      (next - prev) == -_netHeight + 1;
}

bool _isLeftBottom(int next, int prev) {
  // 4
  return (prev == 1 && next == _cellInRow) ||
      (prev == -_cellInRow&& next == -1) ||
      (next - prev) == (_cellInRow* 2) - 1 ||
      (next - prev) == -(_netHeight + 1);
}

Widget _rightBottom(Color color, double cellMargin, Radius cornerRadius) {
  return SnakeCorner(
    colorSnake: color,
    backMargin: EdgeInsets.only(right: cellMargin * 4, bottom: cellMargin * 4),
    corner: BorderRadius.only(bottomRight: cornerRadius),
    snakeMargin: EdgeInsets.only(right: cellMargin, bottom: cellMargin),
  );
}

Widget _leftBottom(Color color, double cellMargin, Radius cornerRadius) {
  return SnakeCorner(
    colorSnake: color,
    backMargin: EdgeInsets.only(left: cellMargin * 4, bottom: cellMargin * 4),
    corner: BorderRadius.only(bottomLeft: cornerRadius),
    snakeMargin: EdgeInsets.only(left: cellMargin, bottom: cellMargin),
  );
}

Widget _rightTop(Color color, double cellMargin, Radius cornerRadius) {
  return SnakeCorner(
    colorSnake: color,
    backMargin: EdgeInsets.only(right: cellMargin * 4, top: cellMargin * 4),
    corner: BorderRadius.only(topRight: cornerRadius),
    snakeMargin: EdgeInsets.only(right: cellMargin, top: cellMargin),
  );
}

Widget _leftTop(Color color, double cellMargin, Radius cornerRadius) {
  return SnakeCorner(
    colorSnake: color,
    backMargin: EdgeInsets.only(left: cellMargin * 4, top: cellMargin * 4),
    corner: BorderRadius.only(topLeft: cornerRadius),
    snakeMargin: EdgeInsets.only(left: cellMargin, top: cellMargin),
  );
}

class MysteriousFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        Icons.card_giftcard_rounded,
        size: _cellSize.toDouble(),
        color: Provider.of<AppColorController>(context).getColors().foodColor,
      ),
    );
  }
}
