import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/color_app.dart';

class AppColorController extends ChangeNotifier {
  List<String> _themeName = ['Blue', 'Red', 'Green', 'Light', 'Dark'];
  AppColor _current = blueColor;
  int index = 0;
  String _selectedColor = 'Blue';
  static const String _indexColorKey = 'colorKey';

  void applyColors() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    index = pref.getInt(_indexColorKey) ?? 0;
    _current = appColorList[index];
    _selectedColor = _themeName[index];
  }

  void setSelectedColor(int i) async {
    _selectedColor = _themeName[i];
    _current = appColorList[i];
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(_indexColorKey, i);
    notifyListeners();
  }

  String getSelectedColor() {
    return _selectedColor;
  }

  AppColor getColors() {
    return _current;
  }

  List<String> colorList() {
    return _themeName;
  }
}
