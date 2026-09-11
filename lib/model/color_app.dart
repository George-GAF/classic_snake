import 'package:flutter/material.dart';

class AppColor {
  final String title;
  final Color basicColor;
  final Color fontColor;
  final Color darkShadow;
  final Color lightShadow;
  final Color snakeColor;
  final Color loadingColor;
  final Color foodColor;
  final Color menuColor;
  final Color fontShadow;
  final Color blockColor;
  final Color glowColor;
  late List<Color> playStageColor;

  AppColor(
      {this.title = "",
      this.basicColor = Colors.black,
      this.fontColor = Colors.black,
      this.darkShadow = Colors.black,
      this.lightShadow = Colors.black,
      this.snakeColor = Colors.black,
      this.loadingColor = Colors.black,
      this.foodColor = Colors.black,
      this.menuColor = Colors.black,
      this.fontShadow = Colors.black,
      this.blockColor = Colors.black,
      this.glowColor = Colors.black}) {
    playStageColor = [
      Colors.transparent,
      snakeColor,
      foodColor,
      blockColor,
      Colors.transparent,
      foodColor,
      snakeColor
    ];
  }
}

AppColor blueColor = AppColor(
  title: 'Neon Blue',
  basicColor: Color.fromRGBO(13, 16, 38, 1),
  menuColor: Color.fromRGBO(27, 33, 72, 1),
  darkShadow: Color.fromRGBO(5, 7, 18, 1),
  lightShadow: Color.fromRGBO(58, 66, 124, .55),
  fontColor: Colors.white,
  snakeColor: Color.fromRGBO(125, 232, 255, 1),
  loadingColor: Color.fromRGBO(33, 199, 255, 1),
  foodColor: Color.fromRGBO(255, 77, 109, 1),
  fontShadow: Color.fromRGBO(33, 199, 255, 1),
  blockColor: Color.fromRGBO(58, 63, 110, 1),
  glowColor: Color.fromRGBO(33, 199, 255, 1),
);

AppColor redColor = AppColor(
  title: 'Neon Red',
  basicColor: Color.fromRGBO(32, 13, 38, 1),
  menuColor: Color.fromRGBO(70, 27, 72, 1),
  darkShadow: Color.fromRGBO(18, 5, 20, 1),
  lightShadow: Color.fromRGBO(124, 58, 96, .55),
  fontColor: Colors.white,
  snakeColor: Color.fromRGBO(255, 179, 125, 1),
  loadingColor: Color.fromRGBO(255, 46, 136, 1),
  foodColor: Color.fromRGBO(0, 229, 160, 1),
  fontShadow: Color.fromRGBO(255, 46, 136, 1),
  blockColor: Color.fromRGBO(94, 58, 110, 1),
  glowColor: Color.fromRGBO(255, 46, 136, 1),
);

AppColor greenColor = AppColor(
  title: 'Neon Green',
  basicColor: Color.fromRGBO(13, 38, 26, 1),
  menuColor: Color.fromRGBO(27, 72, 51, 1),
  darkShadow: Color.fromRGBO(5, 20, 12, 1),
  lightShadow: Color.fromRGBO(58, 124, 82, .55),
  fontColor: Colors.white,
  snakeColor: Color.fromRGBO(200, 255, 125, 1),
  loadingColor: Color.fromRGBO(33, 255, 143, 1),
  foodColor: Color.fromRGBO(125, 107, 255, 1),
  fontShadow: Color.fromRGBO(33, 255, 143, 1),
  blockColor: Color.fromRGBO(58, 110, 80, 1),
  glowColor: Color.fromRGBO(33, 255, 143, 1),
);

AppColor lightColor = AppColor(
  title: 'Neon Cyan',
  basicColor: Color.fromRGBO(13, 22, 38, 1),
  menuColor: Color.fromRGBO(27, 43, 72, 1),
  darkShadow: Color.fromRGBO(5, 9, 18, 1),
  lightShadow: Color.fromRGBO(58, 78, 124, .55),
  fontColor: Colors.white,
  snakeColor: Color.fromRGBO(255, 125, 138, 1),
  loadingColor: Color.fromRGBO(33, 229, 255, 1),
  foodColor: Color.fromRGBO(255, 225, 77, 1),
  fontShadow: Color.fromRGBO(33, 229, 255, 1),
  blockColor: Color.fromRGBO(58, 74, 110, 1),
  glowColor: Color.fromRGBO(33, 229, 255, 1),
);

AppColor darkColor = AppColor(
  title: 'Neon Violet',
  basicColor: Color.fromRGBO(21, 13, 38, 1),
  menuColor: Color.fromRGBO(42, 27, 72, 1),
  darkShadow: Color.fromRGBO(10, 5, 20, 1),
  lightShadow: Color.fromRGBO(96, 58, 124, .55),
  fontColor: Colors.white,
  snakeColor: Color.fromRGBO(255, 217, 125, 1),
  loadingColor: Color.fromRGBO(176, 125, 255, 1),
  foodColor: Color.fromRGBO(77, 255, 109, 1),
  fontShadow: Color.fromRGBO(176, 125, 255, 1),
  blockColor: Color.fromRGBO(78, 58, 110, 1),
  glowColor: Color.fromRGBO(176, 125, 255, 1),
);

List<AppColor> appColorList = [
  blueColor,
  redColor,
  greenColor,
  lightColor,
  darkColor
];