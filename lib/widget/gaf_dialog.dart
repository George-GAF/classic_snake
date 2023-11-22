import 'package:classic_snake/widget/gaf_text.dart';
import 'package:flutter/material.dart';

class GafButtonDialog extends StatelessWidget {
  final Function? onPressed;

  const GafButtonDialog({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          ElevatedButton(
            onPressed: ()=>onPressed,
            child: GAFText(
              'Start',
              fontSize: 50,
              fontWeight: FontWeight.bold,
              colorOpacity: .8,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(.3),
                  offset: Offset(5, 5),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
