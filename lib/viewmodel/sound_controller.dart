import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:classic_snake/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSound extends ChangeNotifier {
  static bool musicON = true;
  static bool soundON = true;

  static String soundState = soundON ? 'Sound On' : 'Sound Off';
  static String musicState = musicON ? 'Music On' : 'Music Off';

  static const String _soundStateKey = 'soundState';
  static const String _musicStateKey = 'musicState';

  static double _volume = .5;

  static final AudioPlayer _player = AudioPlayer();
  static final AudioPlayer _backGroundSound = AudioPlayer();

  static void playSoundEffect(String soundName) async {
    if (soundON) {
      log("playSoundEffect run $soundName");
      _volume = .3;
       await _player.play(AssetSource(soundName), volume: _volume);
      _volume = .5;
    }
  }

  void clean(AudioPlayer player) {
    player.stop();
    player.release();
  }

  void backgroundMusic() {
    if (musicON) _playBackgroundSound();
  }

  void _playBackgroundSound() async {
    log("play back ground sound ON ");
    _backGroundSound.play(AssetSource(KMusicFileSound), volume: _volume);
    _backGroundSound.setReleaseMode(ReleaseMode.loop);
    _backGroundSound.onPlayerComplete.listen((_) {
      log("on complete run");
      _backGroundSound.play(AssetSource(KMusicFileSound), volume: _volume);
    });
  }

  void _stopBackgroundSound() {
    clean(_backGroundSound);
  }

  void getSoundSetting() {
    _getSound(refresh: false);
    _getMusic(refresh: false);
  }

  void switchSoundState() async {
    soundON = !soundON;
    soundState = soundON ? 'Sound On' : 'Sound Off';
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(_soundStateKey, soundON);

    notifyListeners();
  }

  void _getSound({bool refresh = true}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    soundON = pref.getBool(_soundStateKey) ?? true;
    if (refresh) notifyListeners();
  }

  bool getSoundState() {
    _getSound();
    return soundON;
  }

  void _getMusic({bool refresh = true}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    musicON = pref.getBool(_musicStateKey) ?? true;
    log("music on $musicON");
    if (refresh) notifyListeners();
  }

  void switchMusicState() async {
    musicON = !musicON;
    musicState = musicON ? 'Music On' : 'Music Off';
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(_musicStateKey, musicON);
    if (musicON)
      _playBackgroundSound();
    else
      _stopBackgroundSound();
    notifyListeners();
  }

  static void stopAllSoundOnExit() {
    try {
      _player.stop();
      _player.release();
      _backGroundSound.stop();
      _backGroundSound.release();
    } catch (ex) {}
  }

  bool getMusicState() {
    _getMusic();
    return musicON;
  }
}
