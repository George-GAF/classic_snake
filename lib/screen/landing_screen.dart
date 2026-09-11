import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/app_color.dart';
import '../view_model/level_controller.dart';
import '../view_model/manager.dart';
import '../widget/gaf_text.dart';
import 'menu_screen.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/LandingScreen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with WidgetsBindingObserver {
  String _gaf = 'SNAKE';
  int charInd = -1;
  String _programing = 'CYBER CRAWL';
  int charIndS = -1;
  String _curPOne = '';
  String _curPTwo = '';
  Timer? _titleTimer;
  bool _glow = false;
  double padding = 0;
  double corner = 0;

  void _writeTitle() {
    Duration duration = Duration(milliseconds: 100);
    _titleTimer = Timer.periodic(duration, (timer) {
      if (_gaf.length == _curPOne.length) {
        if (_programing.length == _curPTwo.length) {
          if (!_glow) {
            setState(() {
              _glow = true;
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
  void dispose() {
    _titleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Manager.screenAdjust();
    final colors = context.watch<AppColorController>().getColors();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colors.basicColor,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GAFText(
              'GAF- Programing',
              colors: colors.fontColor,
              fontSize: width * .03,
              fontFamily: 'Orbitron',
              letterSpacing: 3,
            ),
            SizedBox(
              height: height * .015,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .02),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: colors.menuColor,
                        borderRadius: BorderRadius.circular(corner),
                        border: Border.all(
                            color: colors.glowColor.withOpacity(_glow ? .9 : .35)),
                        boxShadow: [
                          BoxShadow(
                            color: colors.glowColor.withOpacity(_glow ? .55 : .2),
                            blurRadius: _glow ? 18 : 8,
                            spreadRadius: _glow ? 2 : 0,
                          ),
                        ],
                      ),
                      child: GAFText(
                        _curPOne,
                        colors: colors.fontColor,
                        glowColor: colors.glowColor,
                        fontSize: width * .07,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GAFText(
                      _curPTwo,
                      colors: colors.fontColor,
                      glowColor: colors.glowColor,
                      fontSize: width * .07,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                      letterSpacing: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}