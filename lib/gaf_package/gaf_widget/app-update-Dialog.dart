import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../viewmodel/game_size.dart';
import '../../widget/gaf_text.dart';
import 'gaf_dialog.dart';
import 'gaf_dialog_action_button.dart';

class UpdateAppDialog extends StatelessWidget {
  final Function()? onPressed;
  final String lastVersion;

  const UpdateAppDialog({required this.onPressed, required this.lastVersion});

  @override
  Widget build(BuildContext context) {
    double width = GameSize().width();
    return GAFDialog(
      title: 'Update App',
      height: GameSize().height() * .3,
      contentWidget: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: width * .01, right: width * .01, bottom: width * .01),
        child: GAFText(
          'New Version Of $KAppName is available version : $lastVersion you have $KCurrentAppVersion\nWould you like to update it now?',
          softWrap: true,
          fontSize: width * .05,
        ),
      ),
      actionWidget: [
        GAFActionButton(actionButtonTitle: 'Update App', action: onPressed),
      ],
    );
  }
}
