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
    Manager.gameScore = 300;
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
}