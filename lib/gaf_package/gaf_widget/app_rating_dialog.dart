import 'package:flutter/material.dart';

import '../../view_model/game_size.dart';
import '../../widget/gaf_text.dart';
import 'gaf_dialog.dart';
import 'gaf_dialog_action_button.dart';

class AppRatingDialog extends StatelessWidget {
  final Function()? onPressed;
  const AppRatingDialog({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    double width = GameSize().width();
    return GAFDialog(
      title: 'Rating App',
      height: GameSize().height() * .3,
      contentWidget: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: width * .01, right: width * .01, bottom: width * .01),
        child: GAFText(
          'Enjoy using app\nrate app',
          fontSize: width * .05,
        ),
      ),
      actionWidget: [
        GAFActionButton(actionButtonTitle: 'Rate App', action: onPressed),
      ],
    );
  }
}
