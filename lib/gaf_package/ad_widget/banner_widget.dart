import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../gaf_service/ad_manager.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> with AutomaticKeepAliveClientMixin {
  BannerAd? _ad;
  DateTime? lastAdRequestTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    if (_isLoading || _ad != null) return;

    final now = DateTime.now();
    if (lastAdRequestTime != null &&
        now.difference(lastAdRequestTime!).inSeconds < 30) {
      return;
    }

    _isLoading = true;
    lastAdRequestTime = now;

    final ad = BannerAd(
      adUnitId: AdManager.bannerAdUnitIdAndroid,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _ad = ad as BannerAd;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isLoading = false;
          print('Ad load failed (code=${error.code} message=${error.message})');
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), _loadAd);
        },
      ),
    );

    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context); // Needed for AutomaticKeepAlive
    if (_ad != null) {
      log("ad run");
      return SizedBox(
        width: _ad!.size.width.toDouble(),
        height: 60,
        child: AdWidget(ad: _ad!),
      );
    }
    return const SizedBox(height: 60);
  }

  @override
  bool get wantKeepAlive => true; // Preserve state
}