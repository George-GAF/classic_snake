
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'providers/stagePlay.dart';
import 'screen/design_level.dart';
import 'screen/landing_screen.dart';
import 'screen/loading_screen.dart';
import 'screen/menu_screen.dart';
import 'screen/play_screen.dart';
import 'screen/stages_screen.dart';
import 'view_model/app_color.dart';
import 'view_model/game_size.dart';
import 'view_model/manager.dart';
import 'view_model/sound_controller.dart';
import 'view_model/timer_controller.dart';
//android.bundle.enableUncompressedNativeLibs=false
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for SystemChrome.setPreferredOrientations()
  Manager.screenAdjust();
runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> StagePlay()),
          ChangeNotifierProvider(create: (_) => AppColorController()),
          ChangeNotifierProvider(create: (_) => GameSound()),
        ],
        child: MyApp(),
      ),
    );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        GameSound.pauseBackgroundMusic();
        if (Manager.gameRun && !Manager.gameOver) {
          Manager.isPause = true;
          GameTimer.manageTimer();
          Manager.sendToBackground = true;
          if (mounted) context.read<StagePlay>().setMenuState();
        }
        break;
      case AppLifecycleState.resumed:
        GameSound.resumeBackgroundMusic();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    GameSize().calcGameSize(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    Provider.of<AppColorController>(context, listen: false).applyColors();
    GameSound().getSoundSetting();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Mali',
        fontFamilyFallback: const ['Mali'],
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: FutureBuilder(
        builder: (context , builder) {
          return LandingScreen();
        }, future: _initGoogleMobileAds(),
      ),
      routes: {
        MenuScreen.routeName: (context) => MenuScreen(),
        PlayScreen.routeName: (context) => PlayScreen(),
        LoadingScreen.routeName: (context) => LoadingScreen(),
        StageScreen.routeName: (context) => StageScreen(),
        LandingScreen.routeName: (context) => LandingScreen(),
        DesignLevel.routeName: (context) => DesignLevel(),
      },
      onGenerateRoute: (settings) {
        final builders = <String, WidgetBuilder>{
          MenuScreen.routeName: (context) => MenuScreen(),
          PlayScreen.routeName: (context) => PlayScreen(),
          LoadingScreen.routeName: (context) => LoadingScreen(),
          StageScreen.routeName: (context) => StageScreen(),
          LandingScreen.routeName: (context) => LandingScreen(),
          DesignLevel.routeName: (context) => DesignLevel(),
        };
        final builder = builders[settings.name];
        if (builder != null) {
          return NeonRoute(builder: builder, settings: settings);
        }
        return null;
      },
    );
  }
}

class NeonRoute extends PageRouteBuilder {
  NeonRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (context, animation, secondaryAnimation) =>
              Builder(builder: builder),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: CurvedAnimation(parent: curved, curve: Curves.easeOut),
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, .05), end: Offset.zero)
                    .animate(curved),
                child: child,
              ),
            );
          },
        );
}
