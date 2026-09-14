import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/enum_file.dart';
import '../../model/color_app.dart';
import '../../providers/stagePlay.dart';
import '../../view_model/app_color.dart';
import '../../view_model/manager.dart';

/// Single-CustomPainter board. Replaces the 600-cell GridView of
/// AnimatedContainers: one repaint listenable drives the whole grid and the
/// head/tail slide between ticks, instead of a per-cell implicit tween.
class PlayBoard extends StatefulWidget {
  final StagePlay stagePlay;

  const PlayBoard({super.key, required this.stagePlay});

  @override
  _PlayBoardState createState() => _PlayBoardState();
}

class _PlayBoardState extends State<PlayBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slide;
  int _seenFrame = -1;
  Direct _slideDir = Direct.Down;
  List<int> _body = const [];
  Uint8List? _grid;

  @override
  void initState() {
    super.initState();
    _slide = AnimationController(vsync: this)..value = 1;
  }

  @override
  void dispose() {
    _slide.dispose();
    super.dispose();
  }

  void _beginStep(StagePlay stage) {
    _body = stage.snake!.getBody();
    _grid = stage.grid;
    _slideDir = stage.getDirect();
    if (!Manager.gameRun) return;
    _slide.duration = Duration(milliseconds: Manager.gameSpeed);
    _slide.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.stagePlay;
    if (stage.frame != _seenFrame) {
      _seenFrame = stage.frame;
      _beginStep(stage);
    }
    return CustomPaint(
      painter: BoardPainter(
        grid: _grid,
        snakeBody: _body,
        dir: _slideDir,
        slide: _slide,
        version: _seenFrame,
        colors: context.watch<AppColorController>().getColors(),
        altColor: Manager.isMustChangeSnakeColor,
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  static const int _cols = 20;

  final Uint8List? grid;
  final List<int> snakeBody;
  final Direct dir;
  final Animation<double> slide;
  final int version;
  final AppColor colors;
  final bool altColor;

  TextPainter? _question;

  BoardPainter({
    required this.grid,
    required this.snakeBody,
    required this.dir,
    required this.slide,
    required this.version,
    required this.colors,
    required this.altColor,
  }) : super(repaint: slide);

  Color get _snakeColor => altColor ? colors.foodColor : colors.snakeColor;

  int get _dIndex => switch (dir) {
        Direct.Up => -_cols,
        Direct.Down => _cols,
        Direct.Left => -1,
        Direct.Right => 1,
      };

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / _cols;
    final g = grid;
    if (g != null) {
      for (int i = 0; i < g.length; i++) {
        final t = g[i];
        if (t == 1) {
          _paintBlock(canvas, i, cell);
        } else if (t == 3 || t == 4) {
          _paintFood(canvas, i, cell);
        } else if (t == 5) {
          _paintSpecial(canvas, i, cell);
        }
      }
    }
    _paintSnake(canvas, cell);
  }

  void _paintBlock(Canvas canvas, int idx, double cell) {
    final rect = _cellRect(idx, cell);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(cell * .1)),
      Paint()..color = colors.blockColor,
    );
    canvas.drawCircle(rect.center, cell * .2, Paint()..color = colors.glowColor);
  }

  void _paintFood(Canvas canvas, int idx, double cell) {
    final c = _cellCenter(idx, cell);
    canvas.drawCircle(c, cell * .34,
        Paint()..color = colors.foodColor.withOpacity(.18));
    canvas.drawCircle(c, cell * .22, Paint()..color = colors.foodColor);
  }

  void _paintSpecial(Canvas canvas, int idx, double cell) {
    final c = _cellCenter(idx, cell);
    canvas.drawCircle(c, cell * .44,
        Paint()..color = colors.foodColor.withOpacity(.25));
    canvas.drawCircle(c, cell * .34, Paint()..color = colors.foodColor);
    final q = _question ??= TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: cell * .48,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    q.paint(canvas, c - Offset(q.width / 2, q.height / 2));
  }

  void _paintSnake(Canvas canvas, double cell) {
    final body = snakeBody;
    if (body.isEmpty) return;
    final p = slide.value;
    final paint = Paint()
      ..color = _snakeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cell * .68
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (body.length > 1) {
      final headCenter = _headCenter(cell, p);
      final path = Path()..moveTo(headCenter.dx, headCenter.dy);
      for (int i = body.length - 2; i >= 0; i--) {
        final c = _cellCenter(body[i], cell);
        if (_isAdjacent(body[i], body[i + 1])) {
          path.lineTo(c.dx, c.dy);
        } else {
          path.moveTo(c.dx, c.dy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = colors.glowColor.withOpacity(.10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * .95
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(path, paint);
    }

    final headCenter = _headCenter(cell, p);
    canvas.drawCircle(headCenter, cell * .48, Paint()..color = _snakeColor);
    _paintEyes(canvas, headCenter, cell);
  }

  void _paintEyes(Canvas canvas, Offset head, double cell) {
    final forward = switch (dir) {
      Direct.Up => const Offset(0, -1),
      Direct.Down => const Offset(0, 1),
      Direct.Left => const Offset(-1, 0),
      Direct.Right => const Offset(1, 0),
    };
    final side = Offset(forward.dy, -forward.dx);
    final eye = Paint()..color = Colors.black87;
    canvas.drawCircle(head + forward * (cell * .16) + side * (cell * .17),
        cell * .1, eye);
    canvas.drawCircle(head + forward * (cell * .16) - side * (cell * .17),
        cell * .1, eye);
  }

  Offset _headCenter(double cell, double p) {
    final pos = _cellCenter(snakeBody.last, cell);
    if (p < 1) {
      final from = snakeBody.last - _dIndex;
      if (_isAdjacent(from, snakeBody.last)) {
        return _lerp(_cellCenter(from, cell), pos, p);
      }
    }
    return pos;
  }

  Rect _cellRect(int idx, double cell) {
    final col = idx % _cols;
    final row = idx ~/ _cols;
    return Rect.fromLTWH(col * cell + 1, row * cell + 1, cell - 2, cell - 2);
  }

  Offset _cellCenter(int idx, double cell) {
    return Offset((idx % _cols + .5) * cell, (idx ~/ _cols + .5) * cell);
  }

  Offset _lerp(Offset a, Offset b, double t) {
    return Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
  }

  bool _isAdjacent(int a, int b) {
    final ca = a % _cols, cb = b % _cols;
    final ra = a ~/ _cols, rb = b ~/ _cols;
    if ((ca - cb).abs() == 1 && ra == rb) return true;
    if ((ra - rb).abs() == 1 && ca == cb) return true;
    return false;
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.version != version ||
        oldDelegate.colors != colors ||
        oldDelegate.altColor != altColor;
  }
}