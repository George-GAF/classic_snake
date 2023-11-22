import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/app_color.dart';
import '../../widget/gaf_text.dart';

class GAFDialog extends StatelessWidget {
  final String title;
  final double height;
  final Widget contentWidget;
  final List<Widget> actionWidget;

  const GAFDialog(
      {required this.title, required this.height, required this.contentWidget, required this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: AlertDialog(
        backgroundColor:
            Provider.of<AppColorController>(context).getColors().basicColor,
        title: Column(
          children: [
            GAFText(
              title,
              fontSize: height * .10,
              fontWeight: FontWeight.bold,
            ),
            Divider(
              color: Provider.of<AppColorController>(context)
                  .getColors()
                  .darkShadow,
              thickness: height * .01,
            ),
          ],
        ),
        content: contentWidget,
        actions: actionWidget,
        actionsPadding: EdgeInsets.all(0),
      ),
    );
  }
}
