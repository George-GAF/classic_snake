class Position {
  final int index;
  int? rowNum;
  int? colNum;
  final int _maxColNum = 20;

  Position(this.index) {
    rowNum = index ~/ _maxColNum;
    colNum = index - (_maxColNum * rowNum!);
  }
}
