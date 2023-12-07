import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/widget/gaf_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../view_model/app_color.dart';
import '../view_model/sound_controller.dart';
import '../widget/gaf_item.dart';
import 'converted_icon.dart';


double _height = GameSize().height();
double _width = GameSize().width();

class OptionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorController>(
      builder: (context, color, child) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_width * .06),
          ),
          actionsPadding: EdgeInsets.all(_width * .02),
          buttonPadding: EdgeInsets.all(0),
          backgroundColor: color.getColors().basicColor,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GAFText(
                    'Game Option',
                    textAlign: TextAlign.center,
                    fontSize: _width * .06,
                    fontWeight: FontWeight.w900,
                  ),
                  InkWell(
                    onTap: () {
                      GameSound.playSoundEffect(KButtonClick);
                      Navigator.pop(context);

                    },
                    child: Icon(
                      Icons.close,
                      color: Provider.of<AppColorController>(context)
                          .getColors()
                          .fontColor,
                      size: GameSize().avaWidth() * .09,
                    ),
                  )
                ],
              ),
              Divider(
                color: color.getColors().lightShadow,
                thickness: _height * .001,
              ),
            ],
          ),
          actions: [
            GAFItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GAFText(
                    GameSound.soundState,
                    fontSize: _width * .05,
                  ),
                  ConvertIcon(
                    onPressed: () {
                      Provider.of<GameSound>(context, listen: false)
                          .switchSoundState();
                    },
                    milliseconds: 200,
                    switchValue:
                        Provider.of<GameSound>(context).getSoundState(),
                    onIcon: Icons.volume_up_rounded,
                    offIcon: Icons.volume_mute_rounded,
                  ),
                ],
              ),
              paddingH: _width * .06,
              radius: _width * .02,
            ),
            GAFItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GAFText(
                    GameSound.musicState,
                    fontSize: _width * .05,
                  ),
                  ConvertIcon(
                    onPressed: () {
                      Provider.of<GameSound>(context, listen: false)
                          .switchMusicState();
                    },
                    milliseconds: 200,
                    switchValue:
                        Provider.of<GameSound>(context).getMusicState(),
                    onIcon: Icons.music_note_rounded,
                    offIcon: Icons.music_off_rounded,
                  ),
                ],
              ),
              paddingH: _width * .06,
              radius: _width * .02,
            ),
            GAFItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GAFText(
                    'Choose Color :',
                    fontSize: _width * .05,
                  ),
                  DropdownButton<String>(
                    style: TextStyle(
                      color: color.getColors().fontColor,
                    ),
                    dropdownColor: color.getColors().basicColor,
                    value: color.getSelectedColor(),
                    onChanged: (value) {
                      int i = color.colorList().indexOf(value!);
                      color.setSelectedColor(i);
                    },
                    items: color
                        .colorList()
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: GAFText(
                                    e,
                                    fontSize: _width * .05,
                                  ),
                                ))
                        .toList(),
                  ),
                ],
              ),
              paddingH: _width * .06,
              radius: _width * .02,
            ),
            SizedBox(
              height: _height * .015,
            )
          ],
        );
      },
    );
  }
}
