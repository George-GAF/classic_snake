import 'package:classic_snake/constant/game_values.dart';
import 'package:classic_snake/providers/stagePlay.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:classic_snake/view_model/sound_controller.dart';
import 'package:classic_snake/view_model/timer_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StagePlay stagePlay;
  late int boxCount;
  late int tick;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GameSound.soundON = false;
    GameSound.musicON = false;
    GameSize().calcGameSize(400, 800);
    boxCount = GameSize.boxCount();
    tick = Manager.gameSpeed;
    Manager.startGame();
    stagePlay = StagePlay();
  });

  test('each tick advances the snake and the frame counter', () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.gamePlay();
      final frameBefore = stagePlay.frame;
      async.elapse(Duration(milliseconds: tick));
      expect(stagePlay.snake!.getBody().last, 110);
      expect(stagePlay.frame, frameBefore + 1);
    });
  });

  test('eating food on the tick scores KEatScoreValue', () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.stage!.food = 110;
      Manager.food = 110;
      stagePlay.gamePlay();
      async.elapse(Duration(milliseconds: tick));
      expect(Manager.gameScore, KEatScoreValue);
    });
  });

  test('consecutive eats within the window ramp the combo score', () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.gamePlay();
      void eatNext() {
        final step = GameSize().cellInRow();
        stagePlay.stage!.food = stagePlay.snake!.getBody().last + step;
        Manager.food = stagePlay.stage!.food;
        async.elapse(Duration(milliseconds: tick));
      }

      eatNext();
      expect(stagePlay.fxScore, 10);
      expect(stagePlay.comboMultiplier, 1);
      expect(Manager.gameScore, 10);
      eatNext();
      expect(stagePlay.fxScore, 12);
      expect(stagePlay.comboMultiplier, 2);
      expect(Manager.gameScore, 22);
      eatNext();
      expect(stagePlay.fxScore, 15);
      expect(stagePlay.comboMultiplier, 3);
      expect(Manager.gameScore, 37);
      eatNext();
      expect(stagePlay.fxScore, 20);
      expect(stagePlay.comboMultiplier, 4);
      expect(Manager.gameScore, 57);
      eatNext();
      expect(stagePlay.fxScore, 20);
      expect(stagePlay.comboMultiplier, 4);
      expect(Manager.gameScore, 77);
    });
  });

  test('combo resets to the base score after KComboResetSeconds without eating',
      () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.gamePlay();
      void eatNext() {
        final step = GameSize().cellInRow();
        stagePlay.stage!.food = stagePlay.snake!.getBody().last + step;
        Manager.food = stagePlay.stage!.food;
        async.elapse(Duration(milliseconds: tick));
      }

      eatNext();
      eatNext();
      expect(stagePlay.fxScore, 12);
      async.elapse(Duration(seconds: KComboResetSeconds) +
          const Duration(milliseconds: 1));
      expect(stagePlay.comboMultiplier, 0);
      eatNext();
      expect(stagePlay.fxScore, 10);
      expect(stagePlay.comboMultiplier, 1);
      expect(Manager.gameScore, 32);
    });
  });

  test('breaking the target on time records the earned stars', () {
    fakeAsync((async) async {
      stagePlay.start(1);
      Manager.gameRun = true;
      GameTimer.manageTimer();
      async.elapse(const Duration(seconds: 1));
      Manager.gameScore = 310;
      stagePlay.testingScoreAndHScore();
      async.flushMicrotasks();
      expect(await stagePlay.controller!.getLevelStars(), 3);
      expect(stagePlay.earnedStars, 3);
      expect(stagePlay.earnedTime, 1);
      expect(stagePlay.bestTime, 1);
      expect(StagePlay.formatTime(60), '1:00');
      async.flushMicrotasks();
      Manager.gameOver = true;
      GameTimer.manageTimer();
    });
  });

  test('paused game does not tick', () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.gamePlay();
      Manager.isPause = true;
      final frameBefore = stagePlay.frame;
      async.elapse(Duration(milliseconds: tick * 3));
      expect(stagePlay.frame, frameBefore);
    });
  });

  test('game over keeps the loop idle', () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.gamePlay();
      Manager.gameOver = true;
      final frameBefore = stagePlay.frame;
      async.elapse(Duration(milliseconds: tick * 3));
      expect(stagePlay.frame, frameBefore);
    });
  });

  test('special food spawns within 60-90s and clears after 15s', () {
    fakeAsync((async) {
      stagePlay.start(0);
      stagePlay.gamePlay();
      expect(stagePlay.stage!.sFood, boxCount + 1);
      var elapsed = Duration.zero;
      while (stagePlay.stage!.sFood >= boxCount &&
          elapsed < const Duration(seconds: 95)) {
        async.elapse(const Duration(seconds: 1));
        elapsed += const Duration(seconds: 1);
      }
      expect(stagePlay.stage!.sFood, inInclusiveRange(0, boxCount - 1));
      Manager.isPause = true;
      async.elapse(const Duration(seconds: 14));
      expect(stagePlay.stage!.sFood, inInclusiveRange(0, boxCount - 1));
      async.elapse(const Duration(seconds: 1));
      expect(stagePlay.stage!.sFood, boxCount + 1);
    });
  });
}
