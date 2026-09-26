import 'package:classic_snake/view_model/level_controller.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LevelController.customBlocks = [];
  });

  group('LevelController', () {
    test('scoreLevelDone persists the unlocked state', () async {
      final controller = LevelController(3);
      expect(await controller.getLevelState(), isFalse);
      expect(controller.scoreLevelDone(300, 300), isA<Future<bool>>());
      expect(await controller.scoreLevelDone(300, 300), isTrue);
      expect(await controller.getLevelState(), isTrue);
    });

    test('highScoreBroken saves the new high score', () async {
      final controller = LevelController(3);
      expect(await controller.highScoreBroken(500), isTrue);
      expect(await controller.getLevelHighScore(), 500);
      expect(await controller.highScoreBroken(200), isFalse);
      expect(await controller.getLevelHighScore(), 500);
    });

    test('levelSave/levelRestore round-trips target and blocks', () async {
      final controller = LevelController(999);
      final saved = await controller.levelSave(1200, [10, 42, 77]);
      expect(saved, isTrue);
      final restored = await controller.levelRestore();
      expect(restored.targetScore, 1200);
      expect(LevelController.customBlocks, [10, 42, 77]);
      expect(restored.rank, 999);
    });

    test('levelRestore with no saved data returns empty custom level',
        () async {
      final restored = await LevelController(999).levelRestore();
      expect(restored.targetScore, 0);
      expect(LevelController.customBlocks, isEmpty);
    });

    test('setLevelStars keeps the best star count of two completions',
        () async {
      final controller = LevelController(3);
      await controller.setLevelStars(2);
      expect(await controller.getLevelStars(), 2);
      await controller.setLevelStars(1);
      expect(await controller.getLevelStars(), 2);
      await controller.setLevelStars(3);
      expect(await controller.getLevelStars(), 3);
    });

    test('setLevelBestTime keeps only the fastest completion', () async {
      final controller = LevelController(3);
      await controller.setLevelBestTime(120);
      await controller.setLevelBestTime(200);
      expect(await controller.getLevelBestTime(), 120);
      await controller.setLevelBestTime(90);
      expect(await controller.getLevelBestTime(), 90);
      expect(await controller.getLevelBestTime(), lessThan(91));
    });
  });

  group('Manager.totalStars', () {
    test('refreshTotalStars sums every level up to the 90-star ceiling',
        () async {
      await LevelController(1).setLevelStars(3);
      await LevelController(7).setLevelStars(2);
      await LevelController(30).setLevelStars(1);
      final total = await Manager.refreshTotalStars();
      expect(total, 6);
      expect(Manager.totalStars, 6);
      expect(total, lessThanOrEqualTo(Manager.maxStars));
    });
  });
}
