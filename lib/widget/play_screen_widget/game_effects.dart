import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stagePlay.dart';
import '../../view_model/app_color.dart';
import '../../view_model/game_size.dart';
import '../../model/color_app.dart';

class GameEffects extends StatefulWidget {
  const GameEffects({super.key});

  @override
  _GameEffectsState createState() => _GameEffectsState();
}

class _Burst {
  final Offset center;
  final Color color;
  final String label;
  final List<_Particle> particles;
  _Burst(this.center, this.color, this.label, this.particles);
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  _Particle(this.angle, this.speed, this.size);
}

class _GameEffectsState extends State<GameEffects>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _Burst? _burst;
  late int _seenPulse;

  @override
  void initState() {
    super.initState();
    _seenPulse = context.read<StagePlay>().fxPulse;
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawn(StagePlay stage, AppColor colors) {
    final cell = GameSize().cellSize().toDouble();
    final col = stage.eatenAt % GameSize().cellInRow();
    final row = stage.eatenAt ~/ GameSize().cellInRow();
    final center = Offset(col * cell + cell / 2, row * cell + cell / 2);
    final color = stage.fxIsSpecial ? colors.glowColor : colors.foodColor;
    final label = stage.fxIsSpecial
        ? (stage.stage?.reward ?? '')
        : '+10';
    final rng = Random();
    final particles = List.generate(18, (i) {
      return _Particle(
        rng.nextDouble() * 2 * pi,
        1.1 + rng.nextDouble() * 1.8,
        cell * (.08 + rng.nextDouble() * .1),
      );
    });
    _burst = _Burst(center, color, label, particles);
  }

  @override
  Widget build(BuildContext context) {
    final stage = context.watch<StagePlay>();
    final colors = context.watch<AppColorController>().getColors();
    if (stage.fxPulse != _seenPulse && stage.eatenAt >= 0) {
      _seenPulse = stage.fxPulse;
      _spawn(stage, colors);
      _controller.forward(from: 0);
    }
    return IgnorePointer(
      child: CustomPaint(
        painter: _FxPainter(
          _burst,
          _controller,
          GameSize().cellSize().toDouble(),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _FxPainter extends CustomPainter {
  final _Burst? burst;
  final Animation<double> animation;
  final double cell;

  _FxPainter(this.burst, this.animation, this.cell)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final b = burst;
    if (b == null) return;
    final t = animation.value;

    for (final p in b.particles) {
      final d = p.speed * cell * t;
      final pos = b.center + Offset(cos(p.angle), sin(p.angle)) * d;
      canvas.drawCircle(
        pos,
        p.size * (1 - t * .4),
        Paint()..color = b.color.withOpacity(.7 * (1 - t)),
      );
    }

    canvas.drawCircle(
      b.center,
      t * cell * 2.4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = cell * .12
        ..color = b.color.withOpacity(.9 * (1 - t)),
    );

    if (t < 1 && b.label.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: b.label,
          style: TextStyle(
            color: Colors.white.withOpacity(1 - t),
            fontSize: b.label.length > 8 ? cell * .6 : cell * .7,
            fontWeight: FontWeight.w900,
            fontFamily: 'Orbitron',
            shadows: [
              Shadow(color: b.color, blurRadius: cell * .6),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        b.center - Offset(tp.width / 2, tp.height / 2 + t * cell * 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FxPainter old) =>
      old.burst != burst || old.cell != cell;
}