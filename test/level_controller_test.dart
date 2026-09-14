import 'package:classic_snake/view_model/level_controller.dart';
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
  });
}