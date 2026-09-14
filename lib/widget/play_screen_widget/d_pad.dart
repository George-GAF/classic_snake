import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:provider/provider.dart';

import '../../constant/enum_file.dart';
import '../../model/color_app.dart';
import '../../providers/stagePlay.dart';
import '../../view_model/app_color.dart';
import '../../view_model/game_size.dart';
import '../../view_model/manager.dart';

class DPad extends StatelessWidget {
  const DPad({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColor colors = context.watch<AppColorController>().getColors();
    final double cell = GameSize().cellSize().toDouble();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _padButton(context, colors, cell, Direct.Up),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _padButton(context, colors, cell, Direct.Left),
            SizedBox(width: cell * .35),
            _padButton(context, colors, cell, Direct.Right),
          ],
        ),
        _padButton(context, colors, cell, Direct.Down),
      ],
    );
  }

  Widget _padButton(
      BuildContext context, AppColor colors, double cell, Direct dir) {
    final icon = switch (dir) {
      Direct.Up => Icons.arrow_upward_rounded,
      Direct.Down => Icons.arrow_downward_rounded,
      Direct.Left => Icons.arrow_back_rounded,
      Direct.Right => Icons.arrow_forward_rounded,
    };
    return Padding(
      padding: EdgeInsets.all(cell * .1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(cell * .35),
          onTap: () {
            if (Manager.gameOver || Manager.requestLife) return;
            HapticFeedback.selectionClick();
            context.read<StagePlay>().changeDirect(dir);
          },
          child: Container(
            width: cell * 1.55,
            height: cell * 1.55,
            decoration: BoxDecoration(
              color: colors.basicColor.withOpacity(.6),
              borderRadius: BorderRadius.circular(cell * .35),
              border: Border.all(
                color: colors.glowColor.withOpacity(.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.glowColor.withOpacity(.3),
                  blurRadius: cell * .4,
                ),
              ],
            ),
            child: Icon(icon, color: colors.fontColor, size: cell * .95),
          ),
        ),
      ),
    );
  }
}