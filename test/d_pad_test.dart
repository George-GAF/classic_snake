import 'package:classic_snake/constant/enum_file.dart';
import 'package:classic_snake/providers/stagePlay.dart';
import 'package:classic_snake/view_model/app_color.dart';
import 'package:classic_snake/view_model/game_size.dart';
import 'package:classic_snake/view_model/manager.dart';
import 'package:classic_snake/widget/play_screen_widget/d_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Manager.startGame();
    Manager.dPadEnabled = true;
  });

  Future<void> pumpDPad(WidgetTester tester) async {
    GameSize().calcGameSize(400, 800);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StagePlay()..start(0)),
          ChangeNotifierProvider(create: (_) => AppColorController()),
        ],
        child: const MaterialApp(home: Scaffold(body: Center(child: DPad()))),
      ),
    );
  }

  testWidgets('D-pad Right press queues a Right turn that moves the head right',
      (tester) async {
    await pumpDPad(tester);
    final stagePlay = Provider.of<StagePlay>(
        tester.element(find.byType(DPad)),
        listen: false);
    expect(stagePlay.getDirect(), Direct.Down);
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    stagePlay.snake!.moving();
    expect(stagePlay.getDirect(), Direct.Right);
    expect(stagePlay.snake!.getBody().last, 91);
  });

  testWidgets('D-pad is inert when the game is over', (tester) async {
    await pumpDPad(tester);
    Manager.gameOver = true;
    final stagePlay = Provider.of<StagePlay>(
        tester.element(find.byType(DPad)),
        listen: false);
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    expect(stagePlay.getDirect(), Direct.Down);
  });
}