import 'package:classic_snake/model/level_model.dart';
import 'package:classic_snake/viewmodel/game_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screen/design_level.dart';
import 'screen/landing_screen.dart';
import 'screen/loading_screen.dart';
import 'screen/menu_screen.dart';
import 'screen/play_screen.dart';
import 'screen/stages_screen.dart';
import 'viewmodel/app_color.dart';
import 'viewmodel/snake.dart';
import 'viewmodel/sound_controller.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized(); // Needed for SystemChrome.setPreferredOrientations()
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Snake()),
          ChangeNotifierProvider(create: (_) => AppColorController()),
          ChangeNotifierProvider(create: (_) => GameSound()),
        ],
        child: MyApp(),
      ),
    );
}
class MyApp extends StatelessWidget {

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {

    Wakelock.enable();
    GameSize().calcGameSize(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    Provider.of<AppColorController>(context, listen: false).applyColors();
    GameSound().getSoundSetting();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Mail',
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
        buttonBarTheme: ButtonBarThemeData(
          alignment: MainAxisAlignment.center,
        ),
      ),
      home: LandingScreen(),
      routes: {
        MenuScreen.routeName: (context) => MenuScreen(),
        PlayScreen.routeName: (context) => PlayScreen(stage:
          new LevelModel(rank: 0,
            targetScore: 0,
            enable: true,
            buildWell: GameSize.blockIndex = [])
        ),
        LoadingScreen.routeName: (context) => LoadingScreen(),
        StageScreen.routeName: (context) => StageScreen(),
        LandingScreen.routeName: (context) => LandingScreen(),
        DesignLevel.routeName: (context) => DesignLevel(),
      },
    );
  }
}
