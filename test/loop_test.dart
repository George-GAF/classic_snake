import 'package:classic_snake/constant/game_values.dart';
import 'package:classic_snake/providers/stagePlay.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:classic_snake/view_model/sound_controller.dart';
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