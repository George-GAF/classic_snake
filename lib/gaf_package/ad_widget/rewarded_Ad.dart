import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../view_model/app_color.dart';
import '../gaf_service/ad_manager.dart';

class RewardedHelperAd {
  RewardedHelperAd._();
  static final RewardedHelperAd _instance = RewardedHelperAd._();

  factory RewardedHelperAd() {
    return _instance;
  }

  RewardedAd? _rewardedAd;
  Completer<bool>? _loading;

  Future<bool> ensureLoaded() {
    if (_rewardedAd != null) return Future.value(true);
    final inFlight = _loading;
    if (inFlight != null) return inFlight.future;
    final completer = Completer<bool>();
    _loading = completer;
    RewardedAd.load(
      adUnitId: AdManager.rewardedAdUnitIdAndroid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },
          );
          _rewardedAd = ad;
          completer.complete(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          completer.complete(false);
        },
      ),
    );
    return completer.future.whenComplete(() => _loading = null);
  }

  Future<bool> showAd(Function reward, BuildContext context) async {
    final ready = _rewardedAd != null || await ensureLoaded();
    final ad = _rewardedAd;
    if (!ready || ad == null) {
      Toast.show('No Ad Available',
          duration: 2,
          webTexColor:
              context.read<AppColorController>().getColors().fontColor,
          backgroundColor:
              context.read<AppColorController>().getColors().darkShadow);
      return false;
    }
    _rewardedAd = null;
    ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      reward();
    });
    return true;
  }
}