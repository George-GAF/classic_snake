import 'dart:async';

import 'package:flutter/material.dart';

import '../viewmodel/level_controller.dart';
import '../viewmodel/manager.dart';
import 'menu_screen.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/LandingScreen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with WidgetsBindingObserver {
  String _gaf = 'GAF';
  int charInd = -1;
  String _programing = '- Programing';
  int charIndS = -1;
  String _curPOne = '';
  String _curPTwo = '';
  Color w = Colors.white;
  Color b = Color.fromRGBO(12, 12, 12, 1);
  double padding = 0;
  double corner = 0;

  void _writeTitle() {
    Duration duration = Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      if (_gaf.length == _curPOne.length) {
        if (_programing.length == _curPTwo.length) {
          if (w == Colors.white) {
            setState(() {
              w = Color.fromRGBO(12, 12, 12, 1);
              b = Colors.white;
            });
          } else {
            if (padding == 0) {
              setState(() {
                padding = 6;
              });
            } else {
              if (corner == 0) {
                setState(() {
                  corner = 10;
                });
              } else {
                timer.cancel();
                Future.delayed(Duration(milliseconds: 500), () {
                  //GameSize.width = MediaQuery.of(context).size.width;
                  //GameSize.height = MediaQuery.of(context).size.height;
                  //GameSize.calcWideScreen();
                  Navigator.pushReplacementNamed(context, MenuScreen.routeName);
                });
              }
            }
          }
        } else {
          setState(() {
            if (charIndS != -1) _curPTwo += _programing[charIndS];
          });
          charIndS++;
        }
      } else {
        setState(() {
          if (charInd != -1) _curPOne += _gaf[charInd];
        });
        charInd++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _writeTitle();
    LevelController(0).setLevelState();
  }

  @override
  Widget build(BuildContext context) {
    Manager.screenAdjust();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: b,
                borderRadius: BorderRadius.circular(corner),
              ),
              child: Text(
                _curPOne,
                style: TextStyle(
                  color: w,
                  fontWeight: FontWeight.bold,
                  fontSize: width * .07,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              child: Text(
                _curPTwo,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * .07,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
