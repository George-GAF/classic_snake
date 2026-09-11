import 'package:classic_snake/view_model/app_color.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GAFItem extends StatelessWidget {
  GAFItem({this.child, this.paddingV, this.paddingH, this.radius});

  final Widget? child;
  final double? paddingV;
  final double? paddingH;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    var colors = Provider.of<AppColorController>(context).getColors();
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(vertical: paddingV ?? 10),
      margin: EdgeInsets.symmetric(
          horizontal: paddingH ?? 10, vertical: GameSize().width() * .01),
      child: child,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colors.menuColor.withOpacity(.5),
        borderRadius: BorderRadius.circular(radius ?? 50),
        border: Border.all(color: colors.glowColor.withOpacity(.25)),
        boxShadow: [
          BoxShadow(
            color: colors.glowColor.withOpacity(.12),
            blurRadius: GameSize().width() * .02,
          ),
        ],
      ),
    );
  }
}