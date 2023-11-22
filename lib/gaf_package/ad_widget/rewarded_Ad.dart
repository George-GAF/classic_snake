import 'dart:developer';

import 'package:classic_snake/gaf_package/gaf_service/ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedHelperAd {
  RewardedHelperAd._();
  static final RewardedHelperAd _instance = RewardedHelperAd._();

  factory RewardedHelperAd() {
    return _instance;
  }

  RewardedAd? _rewardedAd;
  void _loadAd()  {
    if (_rewardedAd != null) {
      return;
    }
     RewardedAd.load(
        adUnitId: AdManager.rewardedAdUnitIdAndroid,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
              log("onAdShowedFullScreenContent");
            },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {
              log("onAdImpression");
            },
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              log("onAdFailedToShowFullScreenContent");
              ad.dispose();
            },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              log("onAdDismissedFullScreenContent");
              ad.dispose();
            },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {
              log("onAdClicked");
            });

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void showAd(Function reward)  {
    _loadAd();
    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      reward();
    });
  }
}
