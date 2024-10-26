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
  bool _loadAd() {
    bool isLoad = false;
    /*if (_rewardedAd != null) {
      return;
    }*/
    RewardedAd.load(
        adUnitId: AdManager.rewardedAdUnitIdAndroid,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            isLoad = true;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {

            debugPrint('RewardedAd failed to load: $error');
          },
        ));
    return isLoad;
  }

  void showAd(Function reward , BuildContext context) {
    var isLoad =  _loadAd();
    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      reward();
    });
    if(!isLoad){
      Toast.show('No Ad Available',
          duration: 2,
          webTexColor: context.read<AppColorController>().getColors().fontColor,
          backgroundColor:
          context.read<AppColorController>().getColors().darkShadow);
    }
  }
}
