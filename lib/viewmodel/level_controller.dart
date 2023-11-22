//import 'dart:developer';

import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/level_model.dart';
//TODO : need to test : because some error note i get
class LevelController {
  final int rank;
  final String _levelState = 'stage_state';
  final String _levelHighScore = 'stage_high_score';

  final String _levelBlocksIndex = 'blocks_list';
  final String _levelTarget = 'level_target';

  static List<int> customBlocks = [];

  bool _playHighScoreSound = false;

  LevelController(this.rank);

  bool scoreLevelDone(int target, int current) {
    bool scoreDone = current >= target;
    if (scoreDone) {
      setLevelState();
    }
    return scoreDone;
  }

  Future<bool> highScoreBroken(Future<int> highScore, int current ) async {
    //log("hi score run $_playHighScoreSound");
    int h = await highScore;
    if (current >= h && current != 0) {
      setLevelHighScore(current);
      //if (!_playHighScoreSound) {
        //GameSound.playSoundEffect(KHeightScoreBreakFileSound);
        //_playHighScoreSound = true;
      //}
    }
    //log("hi score run after change $_playHighScoreSound");
    log("from level controller current : $current high score $h");
    return current > h;
  }

  void setLevelState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('$_levelState$rank', true);
  }

  Future<bool> getLevelState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('$_levelState$rank') ?? false;
  }

  void setLevelHighScore(int highScore) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('$_levelHighScore$rank', highScore);
  }

  Future<int> getLevelHighScore() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('$_levelHighScore$rank') ?? 0;
  }

  Future<bool> levelSave(int target, List<int> blocks) async {
    List<String> stringList = [];
    for (int i = 0; i < blocks.length; i++) {
      stringList.add('${blocks[i]}');
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool saved = false;
    saved = await pref.setStringList('$_levelBlocksIndex$rank', stringList);
    if (!saved) return false;
    saved = await pref.setInt('$_levelTarget$rank', target);
    return saved;
  }

  Future<LevelModel> levelRestore() async {
    customBlocks = [];
    List<String>? stringList = [];
    List<int> blocks = [];
    int target = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    stringList = (pref.getStringList('$_levelBlocksIndex$rank') ?? null)!;
    //if (stringList == null) return ;
    for (int i = 0; i < stringList.length; i++) {
      blocks.add(int.parse(stringList[i]));
    }
    target = pref.getInt('$_levelTarget$rank') ?? 0;
    customBlocks = blocks;
    return LevelModel(
      rank: 999,
      enable: true,
      targetScore: target,
    );
  }
}
