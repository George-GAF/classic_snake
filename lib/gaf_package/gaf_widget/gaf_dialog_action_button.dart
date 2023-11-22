import 'package:flutter/material.dart';

import '../../viewmodel/game_size.dart';
import '../../widget/gaf_text.dart';

class GAFActionButton extends StatelessWidget {
  final Function()? action;
  final String actionButtonTitle;

  const GAFActionButton(
      {required this.action, required this.actionButtonTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: (){action!();},
          child: GAFText(
            actionButtonTitle,
            fontWeight: FontWeight.bold,
            fontSize: GameSize().width() * .05,
          ),
        ),
        SizedBox(
          width: GameSize().width() * .12,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: GAFText(
            'Cancel',
            fontSize: GameSize().width() * .05,
          ),
        ),
      ],
    );
  }
}
