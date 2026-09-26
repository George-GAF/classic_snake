import 'package:classic_snake/constant/game_values.dart';
import 'package:classic_snake/model/level_model.dart';
import 'package:classic_snake/providers/stagePlay.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:classic_snake/view_model/sound_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StagePlay stagePlay;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GameSound.soundON = false;
    GameSound.musicON = false;
    GameSize().calcGameSize(400, 800);
    Manager.startGame();
    stagePlay = StagePlay();
  });

  test('start initializes a clean run on level 0', () {
    stagePlay.start(0);
    expect(stagePlay.snake, isNotNull);
    expect(stagePlay.stage, isNotNull);
    expect(stagePlay.level!.rank, 0);
    expect(Manager.gameOver, isFalse);
    expect(Manager.isPause, isFalse);
    expect(Manager.gameScore, 0);
  });

  test('start populates the board grid with snake and food cells', () {
    stagePlay.start(0);
    expect(stagePlay.frame, greaterThan(0));
    for (final cell in stagePlay.snake!.getBody()) {
      expect(stagePlay.grid[cell], 2);
    }
    expect(stagePlay.grid[Manager.food], 3);
  });

  test('breaking the target persists the unlocked level state', () async {
    stagePlay.start(1);
    Manager.gameScore = 310;
    stagePlay.testingScoreAndHScore();
    await Future<void>.delayed(Duration.zero);
    expect(await stagePlay.controller!.getLevelState(), isTrue);
  });

  test('high score is written when it is beaten', () async {
    stagePlay.start(0);
    Manager.gameScore = 500;
    stagePlay.testingScoreAndHScore();
    await Future<void>.delayed(Duration.zero);
    expect(stagePlay.highScore, 500);
    expect(await stagePlay.controller!.getLevelHighScore(), 500);
  });

  test('a tie with the best score does not celebrate', () async {
    SharedPreferences.setMockInitialValues({'stage_high_score0': 500});
    stagePlay.start(0);
    await Future<void>.delayed(Duration.zero);
    Manager.gameScore = 500;
    stagePlay.testingScoreAndHScore();
    await Future<void>.delayed(Duration.zero);
    expect(stagePlay.isHScoreBroken(), isFalse);
    expect(stagePlay.fxHScorePulse, 0);
    expect(await stagePlay.controller!.getLevelHighScore(), 500);
  });

  test('beating the best score celebrates exactly once', () async {
    SharedPreferences.setMockInitialValues({'stage_high_score0': 500});
    stagePlay.start(0);
    await Future<void>.delayed(Duration.zero);
    Manager.gameScore = 600;
    stagePlay.testingScoreAndHScore();
    await Future<void>.delayed(Duration.zero);
    expect(stagePlay.isHScoreBroken(), isTrue);
    expect(stagePlay.fxHScorePulse, 1);
    expect(stagePlay.highScore, 600);
    expect(await stagePlay.controller!.getLevelHighScore(), 600);
    Manager.gameScore = 700;
    stagePlay.testingScoreAndHScore();
    await Future<void>.delayed(Duration.zero);
    expect(stagePlay.fxHScorePulse, 1);
    expect(await stagePlay.controller!.getLevelHighScore(), 700);
  });

  test('endGame parks the game loop and its spawn timer', () {
    stagePlay.start(0);
    stagePlay.gamePlay();
    expect(stagePlay.gameTimer!.isActive, isTrue);
    stagePlay.endGame();
    expect(Manager.gameOver, isTrue);
  });

  test('start(31) restores the saved custom level without touching levelList',
      () async {
    SharedPreferences.setMockInitialValues({
      'blocks_list999': ['10', '42', '77'],
      'level_target999': 1200,
    });
    stagePlay.start(levelList.length - 1);
    await Future<void>.delayed(Duration.zero);
    expect(stagePlay.level!.rank, 999);
    expect(stagePlay.level!.targetScore, 1200);
    expect(stagePlay.level!.blocks, [10, 42, 77]);
    expect(levelList[levelList.length - 1].blocks, isEmpty);
  });

  test('levels scale base speed from 300ms down to 180ms', () {
    stagePlay.start(1);
    expect(stagePlay.level!.speed, KDefaultGameSpeed);
    expect(Manager.gameSpeed, KDefaultGameSpeed);
    expect(Manager.levelBaseSpeed, KDefaultGameSpeed);
    stagePlay.start(30);
    expect(stagePlay.level!.speed, 180);
    expect(Manager.gameSpeed, 180);
    expect(Manager.levelBaseSpeed, 180);
  });

  test('survival keeps the default speed and no star par', () {
    stagePlay.start(0);
    expect(stagePlay.level!.speed, KDefaultGameSpeed);
    expect(stagePlay.level!.targetTime, 0);
  });

  test('levels expose a par time derived from target, speed and blocks', () {
    expect(levelList[1].targetTime, 159);
    expect(levelList[10].targetTime, 259);
    expect(levelList[30].targetTime, 274);
  });

  test('starsFor awards 3/2/1 stars by par-time bands', () {
    const par = 120;
    expect(StagePlay.starsFor(60, par), 3);
    expect(StagePlay.starsFor(61, par), 2);
    expect(StagePlay.starsFor(120, par), 2);
    expect(StagePlay.starsFor(121, par), 1);
    expect(StagePlay.starsFor(1, 0), 0);
  });

  test('currentStars reflects the live par-time progress', () {
    stagePlay.start(1);
    expect(stagePlay.currentStars, 3);
  });

  test('formatTime renders m:ss', () {
    expect(StagePlay.formatTime(0), '0:00');
    expect(StagePlay.formatTime(93), '1:33');
    expect(StagePlay.formatTime(3600), '60:00');
    expect(StagePlay.formatTime(-5), '0:00');
  });

  test('paceLabel counts down the window to keep the current stars', () {
    expect(StagePlay.paceLabelFor(0, 93), '\u26053 in 0:46');
    expect(StagePlay.paceLabelFor(46, 93), '\u26053 in 0:00');
    expect(StagePlay.paceLabelFor(47, 93), '\u26052 in 0:46');
    expect(StagePlay.paceLabelFor(93, 93), '\u26052 in 0:00');
    expect(StagePlay.paceLabelFor(94, 93), '\u26051');
    expect(StagePlay.paceLabelFor(0, 0), '');
  });
}
