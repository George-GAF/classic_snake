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
  final TextPainter label;
  final List<_Particle> particles;
  final bool celebrate;
  _Burst(
      this.center, this.color, this.label, this.particles, this.celebrate);
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  _Particle(this.angle, this.speed, this.size);
}

class _GameEffectsState extends State<GameEffects>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _celebrate;
  _Burst? _burst;
  late int _seenPulse;
  late int _seenHScorePulse;

  @override
  void initState() {
    super.initState();
    _seenPulse = context.read<StagePlay>().fxPulse;
    _seenHScorePulse = context.read<StagePlay>().fxHScorePulse;
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _celebrate =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
  }

  @override
  void dispose() {
    _controller.dispose();
    _celebrate.dispose();
    super.dispose();
  }

  void _spawn(StagePlay stage, AppColor colors, bool celebrate) {
    final cell = GameSize().cellSize().toDouble();
    final col = stage.eatenAt % GameSize().cellInRow();
    final row = stage.eatenAt ~/ GameSize().cellInRow();
    final center = Offset(col * cell + cell / 2, row * cell + cell / 2);
    final color = celebrate ? colors.glowColor : (stage.fxIsSpecial ? colors.glowColor : colors.foodColor);
    final text = celebrate
        ? 'NEW HIGH SCORE'
        : (stage.fxIsSpecial ? (stage.stage?.reward ?? '') : '+10');
    final label = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: celebrate
              ? cell * 1.0
              : (text.length > 8 ? cell * .6 : cell * .7),
          fontWeight: FontWeight.w900,
          fontFamily: 'Orbitron',
          shadows: [
            Shadow(color: color, blurRadius: celebrate ? cell * 1.2 : cell * .6),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rng = Random();
    final particles = List.generate(celebrate ? 28 : 18, (i) {
      return _Particle(
        rng.nextDouble() * 2 * pi,
        (celebrate ? 1.4 : 1.1) + rng.nextDouble() * (celebrate ? 2.2 : 1.8),
        cell * (.08 + rng.nextDouble() * (celebrate ? .16 : .1)),
      );
    });
    _burst = _Burst(center, color, label, particles, celebrate);
  }

  @override
  Widget build(BuildContext context) {
    final stage = context.watch<StagePlay>();
    final colors = context.watch<AppColorController>().getColors();
    if (stage.eatenAt >= 0) {
      if (stage.fxPulse != _seenPulse) {
        _seenPulse = stage.fxPulse;
        _spawn(stage, colors, false);
        _controller.forward(from: 0);
      }
      if (stage.fxHScorePulse != _seenHScorePulse) {
        _seenHScorePulse = stage.fxHScorePulse;
        _spawn(stage, colors, true);
        _celebrate.forward(from: 0);
      }
    }
    return IgnorePointer(
      child: CustomPaint(
        painter: _FxPainter(
          _burst,
          _controller,
          _celebrate,
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
  final Animation<double> celebrate;
  final double cell;

  _FxPainter(this.burst, this.animation, this.celebrate, this.cell)
      : super(repaint: Listenable.merge([animation, celebrate]));

  @override
  void paint(Canvas canvas, Size size) {
    final b = burst;
    if (b == null) return;
    final t = b.celebrate ? celebrate.value : animation.value;

    if (b.celebrate) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = b.color.withOpacity(.16 * (1 - t)),
      );
      canvas.drawCircle(
        b.center,
        t * cell * 4.5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * .08
          ..color = b.color.withOpacity(.6 * (1 - t)),
      );
    }

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
      (b.celebrate ? 3.2 : 2.4) * t * cell,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = cell * .12
        ..color = b.color.withOpacity(.9 * (1 - t)),
    );

    if (t < .9) {
      final tp = b.label;
      tp.paint(
        canvas,
        b.center - Offset(tp.width / 2, tp.height / 2 + t * cell * (b.celebrate ? 3.4 : 2)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FxPainter old) =>
      old.burst != burst || old.cell != cell;
}