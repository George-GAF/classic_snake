
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../view_model/sound_controller.dart';
import '../widget/gaf_text.dart';
import '../widget/main_menu_button.dart';
import 'stages_screen.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/MenuScreen';

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool showLoadCircle = false;

  @override
  void initState() {
    super.initState();
    GameSound().backgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    Manager.screenAdjust();
    double width = GameSize().width();
    return showLoadCircle
        ? LoadingContainer()
        : Consumer<AppColorController>(builder: (cont, data, wid) {
          return Scaffold(
            backgroundColor: data.getColors().basicColor,
            body: Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GAFText(
                        'SNAKE',
                        fontSize: width * .16,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.center,
                        glowColor: data.getColors().glowColor,
                        shadows: [],
                      ),
                      SizedBox(height: width * .01),
                      GAFText(
                        'CYBER  CRAWL',
                        fontSize: width * .045,
                        colorOpacity: .6,
                        textAlign: TextAlign.center,
                        shadows: [],
                      ),
                      SizedBox(height: width * .08),
                      MainMenuButton(
                        onPressed: ()  {
                          setState(() {
                            showLoadCircle = true;
                          });
                           Navigator.of(context).pushReplacementNamed( StageScreen.routeName);
                        },
                        label: 'START',
                        fontSize: width * .1,
                        showImage: true,
                      ),
                      MainMenuButton(
                        onPressed: () {
                          Manager.showOptionMenu(context);
                        },
                        label: 'Option',
                        padding: 90,
                        fontSize: width * .07,
                      ),
                      MainMenuButton(
                        onPressed: () {
                          GameSound.stopAllSoundOnExit();
                          WakelockPlus.disable();
                          SystemNavigator.pop();
                        },
                        label: 'Exit',
                        padding: 130,
                        fontSize: width * .05,
                      ),
                    ],
                  ),
                  Positioned(
                    child: Row(
                      children: [
                        GAFText(
                          '\t\t\tMade By GAF-Programing 2023',
                          fontSize:width * .035,
                        ),
                      ],
                    ),
                    bottom: 0,
                    left: 0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Provider.of<AppColorController>(context).getColors().basicColor,
      padding: EdgeInsets.symmetric(
          vertical: (MediaQuery.of(context).size.height - 100) / 2,
          horizontal: (MediaQuery.of(context).size.width - 100) / 2),
      child: CircularProgressIndicator(
        strokeWidth: 10,
        backgroundColor:
            Provider.of<AppColorController>(context).getColors().loadingColor,
      ),
    );
  }
}
