import 'package:flutter/material.dart';

/// Wraps a widget with press feedback: scale-down + caller-drawn glow.
class NeonPressable extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, bool pressed) builder;

  const NeonPressable({super.key, required this.onTap, required this.builder});

  @override
  _NeonPressableState createState() => _NeonPressableState();
}

class _NeonPressableState extends State<NeonPressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? .97 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.builder(context, _down),
      ),
    );
  }
}