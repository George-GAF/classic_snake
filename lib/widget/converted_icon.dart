import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/app_color.dart';
import '../viewmodel/game_size.dart';

class ConvertIcon extends StatefulWidget {
  final int? milliseconds;
  final bool? switchValue;
  final IconData? onIcon;
  final IconData? offIcon;
  final Function? onPressed;

  const ConvertIcon(
      {this.milliseconds,
      this.switchValue,
      this.onIcon,
      this.offIcon,
      this.onPressed});
  @override
  _ConvertIconState createState() => _ConvertIconState();
}

class _ConvertIconState extends State<ConvertIcon> {
  bool _isDone = false;
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: widget.milliseconds ?? 300),
          onEnd: () {
            setState(() {
              if (!_isDone) {
                _opacity = _opacity == 1 ? 0 : 1;
                widget.onPressed!();
                _isDone = true;
              }
            });
          },
          opacity: _opacity,
          child: Icon(
            widget.switchValue! ? widget.onIcon : widget.offIcon,
            size: GameSize().width() * .07,
            color:
                Provider.of<AppColorController>(context).getColors().fontColor,
          ),
        ),
        onTap: () {
          setState(() {
            _opacity = _opacity == 1 ? 0 : 1;
            _isDone = false;
          });
        });
  }
}
