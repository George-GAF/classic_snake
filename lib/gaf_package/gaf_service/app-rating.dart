import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gaf_widget/app_rating_dialog.dart';
import 'open_google_play.dart';

const String _KLaunchTime = 'count_app_run';
const String _KIsRateDone = 'is_rate_done';

class AppRating {
  late bool isRateDone;
  late int launchTime;

  AppRating(BuildContext context) {
    _handleAppRating(context);
  }

  void _handleAppRating(BuildContext context) async {
    isRateDone = await _isRateDone();
    if (isRateDone) return;

    launchTime = await _getLaunchTime();
    if (launchTime >= 20) {
      _showRateDialog(context);
    } else {
      _setLaunchTime(launchTime);
    }
  }

  Future<int> _getLaunchTime() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(_KLaunchTime) ?? 0;
  }

  void _setLaunchTime(int prevNum) async {
    prevNum++;
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_KLaunchTime, prevNum);
  }

  Future<bool> _isRateDone() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_KIsRateDone) ?? false;
  }

  void _setRateDone() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_KIsRateDone, true);
  }

  void _showRateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (cont) {
          return AppRatingDialog(
            onPressed: () {
              OpenGooglePlay().openGooglePlay();
              _setRateDone();
              Navigator.pop(context);
            },
          );
        });
  }
}
