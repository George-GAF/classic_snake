import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/constant.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/sound_controller.dart';
import '../widget/gaf_item.dart';
import 'converted_icon.dart';
import 'gaf_text.dart';

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
            side: BorderSide(
              color: color.getColors().glowColor.withOpacity(.4),
            ),
          ),
          backgroundColor: color.getColors().basicColor,
          scrollable: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: _width * .02, vertical: 4),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GAFText(
                      'Game Option',
                      textAlign: TextAlign.center,
                      fontSize: _width * .06,
                      fontWeight: FontWeight.w900,
                    ),
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
          actions: const [],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GAFItem(
                child: Row(
                  children: [
                    Expanded(
                      child: GAFText(
                        GameSound.soundState,
                        fontSize: _width * .05,
                        softWrap: false,
                      ),
                    ),
                    SizedBox(
                      width: _width * .02,
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
                  children: [
                    Expanded(
                      child: GAFText(
                        GameSound.musicState,
                        fontSize: _width * .05,
                        softWrap: false,
                      ),
                    ),
                    SizedBox(
                      width: _width * .02,
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
                  children: [
                    Expanded(
                      child: GAFText(
                        'Colors :',
                        fontSize: _width * .05,
                        softWrap: false,
                      ),
                    ),
                    SizedBox(
                      width: _width * .02,
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
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
                      ),
                    ),
                  ],
                ),
                paddingH: _width * .06,
                radius: _width * .02,
              ),
              GAFItem(
                child: TextButton(
                  onPressed: () {
                    _launchURL(
                        'https://sites.google.com/view/privacypolicyclassicsnake/home');
                  },
                  child: GAFText(
                    'Read Privacy Policy',
                    fontSize: _width * .05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                paddingH: _width * .06,
                radius: _width * .02,
              ),
              SizedBox(
                height: _height * .015,
              )
            ],
          ),
        );
      },
    );
  }
}

Future<void> _launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}
