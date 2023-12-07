import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/level_model.dart';
import '../view_model/app_color.dart';
import '../view_model/manager.dart';
import '../widget/gaf_back_button.dart';
import '../widget/gaf_text.dart';
import '../widget/main_menu_button.dart';
import '../widget/stage_icon.dart';
import 'design_level.dart';
import 'menu_screen.dart';

//bool _dialogShow = false;

class StageScreen extends StatelessWidget {
  static const routeName = '/stagesScreen';

  @override
  Widget build(BuildContext context) {
    Manager.screenAdjust();
    /*
    if (!_dialogShow) {
      final up = AppUpdate(context);
      final rat = AppRating(context);
      _dialogShow = true;
    }
*/
    double width = MediaQuery.of(context).size.width;
    return Consumer<AppColorController>(
      builder: (cont, color, child) {
        return Scaffold(
          backgroundColor: color.getColors().basicColor,
          body: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    GAFBackButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, MenuScreen.routeName);
                      },
                    ),
                    Expanded(
                        child: GAFText(
                      'Levels',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w900,
                      fontSize: width * .1,
                    )),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white.withOpacity(.7),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.all(width * .05),
                        decoration: BoxDecoration(
                          color: color.getColors().basicColor.withAlpha(-30),
                          borderRadius: BorderRadius.circular(width * .05),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: width * .06),
                              child: MainMenuButton(
                                fontSize: width * .06,
                                label: 'Create your own level',
                                onPressed: () async {
                                  await Navigator.pushReplacementNamed(
                                      context, DesignLevel.routeName);
                                },
                                color: Provider.of<AppColorController>(context)
                                    .getColors()
                                    .menuColor,
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                itemBuilder: (cont, i) {
                                  return StageIcon(
                                    text: '${levelList[i].rank}',
                                    stageId: i,
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: levelList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
