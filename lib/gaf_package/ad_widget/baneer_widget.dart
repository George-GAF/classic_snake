import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../gaf_service/ad_manager.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    log("init from banner run");
    BannerAd(
      adUnitId: AdManager.bannerAdUnitIdAndroid,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ad != null) {
      return Container(
        width: _ad!.size.width.toDouble(),
        height: 60,
        alignment: Alignment.center,
        child: AdWidget(
          ad: _ad!,
        ),
      );
    } else {
      return Container(
        height: 60,
        width: double.infinity,
      );
    }
  }
}
