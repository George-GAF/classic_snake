import 'package:flutter/material.dart';

import '../view_model/manager.dart';
import 'play_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = 'LoadingScreen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> goToScreen(BuildContext context) async {
    await Navigator.pushReplacementNamed(context, PlayScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    Manager.screenAdjust();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
          strokeWidth: 10,
        ),
      ),
    );
  }
}
