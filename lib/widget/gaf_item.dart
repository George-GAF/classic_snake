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

  final offSh = GameSize().width() * .009;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(vertical: paddingV ?? 10),
      margin: EdgeInsets.symmetric(
          horizontal: paddingH ?? 10, vertical: GameSize().width() * .01),
      child: child,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color:
              Provider.of<AppColorController>(context).getColors().basicColor,
          boxShadow: [
            BoxShadow(
              color: Provider.of<AppColorController>(context)
                  .getColors()
                  .darkShadow,
              offset: Offset(offSh, offSh),
              blurRadius: GameSize().width() * .01,
            ),
            BoxShadow(
              color: Provider.of<AppColorController>(context)
                  .getColors()
                  .lightShadow,
              offset: Offset(-offSh, -offSh),
              blurRadius: GameSize().width() * .01,
            ),
          ],
          borderRadius: BorderRadius.circular(radius ?? 50)),
    );
  }
}
