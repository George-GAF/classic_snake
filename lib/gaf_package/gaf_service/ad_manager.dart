class AdManager {
  static const String bannerAdUnitIdAndroid =
      'ca-app-pub-3877304040688947/7763210458';

  static const String rewardedAdUnitIdAndroid =
      'ca-app-pub-3877304040688947/9920616656';

  static bool _adRun = false;

  static Future<void> initAdMob() async {
    if (!_adRun) {
      //_adRun =
      // await FirebaseAdMob.instance.initialize(appId: AdManager.appId);

    } else {
      _adRun = true;
    }
  }
//-------------------------------------------------------------------
  /*
  Item

  app ID          ad unit ID

  AdMob app ID    ca-app-pub-3940256099942544~3347511713
  Banner          ca-app-pub-3940256099942544/6300978111
  Native          ca-app-pub-3940256099942544/2247696110
*/
//-------------------------------------------------------------------

/*
  static String get appId {
    if (Platform.isAndroid) {
      return _appIdAndroid;
    } else if (Platform.isIOS) {
      return _appIdIOS;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _bannerAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return _bannerAdUnitIdIOS;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _interstitialAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return _interstitialAdUnitIdIOS;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _rewardedAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return _rewardedAdUnitIdIOS;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

 */
}
