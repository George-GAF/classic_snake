import 'package:classic_snake/view_model/sound_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    GameSound.musicON = true;
  });

  test('pause and resume run without throwing', () {
    GameSound.pauseBackgroundMusic();
    GameSound.resumeBackgroundMusic();
    expect(GameSound.musicON, isTrue);
  });

  test('resume does not bring music back when disabled', () {
    GameSound.musicON = false;
    GameSound.pauseBackgroundMusic();
    GameSound.resumeBackgroundMusic();
    expect(GameSound.musicON, isFalse);
  });
}