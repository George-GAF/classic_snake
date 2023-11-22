import 'package:flutter/material.dart' show BuildContext, Navigator, showDialog;
import 'package:http/http.dart' as http;

import '../../constant/constant.dart';
import '../gaf_widget/app-update-Dialog.dart';
import 'open_google_play.dart';

class AppUpdate {
  static const _getVersion =
      'https://classic-snake-3ecd5-default-rtdb.firebaseio.com//version.json';

  AppUpdate(BuildContext context) {
    _handleUpdate(context);
  }

  void _handleUpdate(BuildContext context) async {
    http.Response response = await http.get(_getVersion as Uri);
    String lastVersion = response.body;
    lastVersion = lastVersion.substring(1, lastVersion.length - 1);
    bool haveLastVersion = _haveLastVersion(lastVersion);
    if (!haveLastVersion) {
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
  }

  bool _haveLastVersion(String lastVersion) {
    var last = _convertVerToListInt(lastVersion);
    var current = _convertVerToListInt(KCurrentAppVersion);
    bool haveLastV =
        last[0] <= current[0] && last[1] <= current[1] && last[2] <= current[2];
    return haveLastV;
  }

  List<int> _convertVerToListInt(String ver) {
    List<int> list = [];
    String temp = ver.substring(0, ver.indexOf('.'));
    list.add(int.parse(temp));
    temp = ver.substring(ver.indexOf('.') + 1, ver.lastIndexOf('.'));
    list.add(int.parse(temp));
    temp = ver.substring(ver.lastIndexOf('.') + 1);
    list.add(int.parse(temp));
    return list;
  }
}
