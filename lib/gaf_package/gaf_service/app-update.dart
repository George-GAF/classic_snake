import 'package:flutter/material.dart'
    show BuildContext, Navigator, debugPrint, showDialog;
import 'package:http/http.dart' as http;

import '../../constant/constant.dart';
import '../gaf_widget/app-update-Dialog.dart';
import 'open_google_play.dart';

class AppUpdate {
  static final Uri _getVersion = Uri.parse(
      'https://classic-snake-3ecd5-default-rtdb.firebaseio.com/version.json');

  AppUpdate(BuildContext context) {
    _handleUpdate(context);
  }

  void _handleUpdate(BuildContext context) async {
    try {
      http.Response response = await http.get(_getVersion);
      if (response.statusCode != 200) return;
      String lastVersion = _cleanVersion(response.body);
      if (!haveLastVersion(lastVersion, KCurrentAppVersion)) {
        showDialog(
          context: context,
          builder: (cont) {
            return UpdateAppDialog(
              onPressed: () {
                OpenGooglePlay().openGooglePlay();
                Navigator.pop(context);
              },
              lastVersion: lastVersion,
            );
          },
        );
      }
    } catch (e) {
      debugPrint('AppUpdate check failed: $e');
    }
  }

  String _cleanVersion(String raw) {
    final v = raw.trim();
    if (v.length >= 2 && v.startsWith('"') && v.endsWith('"')) {
      return v.substring(1, v.length - 1);
    }
    return v;
  }

  static bool haveLastVersion(String last, String current) {
    final l = parseVersion(last);
    final c = parseVersion(current);
    final len = l.length > c.length ? l.length : c.length;
    for (int i = 0; i < len; i++) {
      final li = i < l.length ? l[i] : 0;
      final ci = i < c.length ? c[i] : 0;
      if (li > ci) return false;
      if (li < ci) return true;
    }
    return true;
  }

  static List<int> parseVersion(String ver) {
    final list = <int>[];
    for (final part in ver.trim().split('.')) {
      final n = int.tryParse(part);
      if (n == null) break;
      list.add(n);
    }
    return list;
  }
}