class GameSize {
  GameSize._();

  static final GameSize _instance = GameSize._();

  factory GameSize() {
    return _instance;
  }

  static bool isGameBuild = false;
  static bool isWideScreen = false;
  static late double _width;
  static late double _height;

  static const int _cellInRow = 20;
  static const int _rowNum = 30; //= (height / cellSize).round();
  static const int _boxCount = _rowNum * _cellInRow;

  static int _cellSize = 0; //= (width / cellInRow).round();

  static List<int> blockIndex = [];

  static double _sideMargin = 0;
  //static const double _per = .5625;

  void calcGameSize(double width, double height) {
    _width = width > height ? height : width;
    _height = height > width ? height : width;
    _cellSize = _width ~/ _cellInRow;
    _sideMargin = _width - (_cellSize * _cellInRow);

    //log("width : $_width\nheight : $_height\nCell Size : $_cellSize");
    //log("Side Space : $_sideMargin");
    //log("stage H ${getStageHeight()}");
  }

  double width() {
    return _width;
  }

  double height() {
    return _height;
  }

  int cellSize() {
    return _cellSize;
  }

  double rowHeight() {
    return GameSize().height() - (GameSize().getStageHeight());
  }

  /*
  static void calcWideScreen() {

    if (width / height != _per) {
      isWideScreen = true;
      _sideMargin = width - (height * _per);
    }

  }

  static int cellSize() {
    if (_cellSize == 0) _cellSize = ((width - _sideMargin) / cellInRow).round();
    return _cellSize;
  }
*/
  double avaWidth() {
    return _width - _sideMargin;
  }

  int netHeight() {
    return _boxCount - _cellInRow;
  }

  int cellInRow() {
    return _cellInRow;
  }

  int getStageHeight() {
    return _cellSize * _rowNum;
  }

  int rowNum() {
    return _rowNum;
  }

  static int boxCount() {
    return _boxCount;
  }
/*
  static void getWellIndex(
      {bool top = false,
      bool right = false,
      bool left = false,
      bool bottom = false,
      required List<int> block}) {
    blockIndex = [];
    List<int> well = [];
    if (top) well = List<int>.generate(_cellInRow, (i) => i);
    if (left) {
      List<int> side = List<int>.generate(_rowNum, (i) => i * _cellInRow);
      well.addAll(side);
    }
    if (right) {
      List<int> side = List<int>.generate(
          _rowNum, (i) => (i * _cellInRow) + (_cellInRow - 1));
      well.addAll(side);
    }
    if (bottom) {
      List<int> side = List<int>.generate(
          _cellInRow, (i) => ((_rowNum - 1) * _cellInRow) + i);
      well.addAll(side);
    }
    blockIndex.addAll(well);
    blockIndex.addAll(block);
  }*/
}
