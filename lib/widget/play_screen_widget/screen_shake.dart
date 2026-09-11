import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stagePlay.dart';
import '../../view_model/manager.dart';

/// Shakes the board briefly when the game-over state fires.
class ScreenShake extends StatefulWidget {
  final Widget child;

  const ScreenShake({super.key, required this.child});

  @override
  _ScreenShakeState createState() => _ScreenShakeState();
}

class _ScreenShakeState extends State<ScreenShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _wasOver = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<StagePlay>();
    final over = Manager.gameOver;
    if (over && !_wasOver) {
      _controller.forward(from: 0);
    }
    _wasOver = over;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final amp = t < 1 ? sin(t * pi * 14) * (1 - t) * 9 : 0.0;
        return Transform.translate(
          offset: Offset(amp * .7, amp),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}