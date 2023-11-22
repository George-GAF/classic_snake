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
  late List<Color> playStageColor;

  AppColor(
      {this.title="",
      this.basicColor=Colors.black,
      this.fontColor=Colors.black,
      this.darkShadow=Colors.black,
      this.lightShadow=Colors.black,
      this.snakeColor=Colors.black,
      this.loadingColor=Colors.black,
      this.foodColor=Colors.black,
      this.menuColor=Colors.black,
      this.fontShadow=Colors.black,
      this.blockColor=Colors.black}) {

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
  title: 'Blue',
  basicColor: Color.fromRGBO(71, 148, 254, .7),
  menuColor: Color.fromRGBO(71, 148, 254, 1),
  darkShadow: Color.fromRGBO(71, 120, 254, 1),
  fontColor: Colors.white,
  lightShadow: Color.fromRGBO(50, 50, 50, .7),
  snakeColor: Colors.white70,
  loadingColor: Colors.redAccent,
  foodColor: Color.fromRGBO(0, 255, 0, 1),
  fontShadow: Colors.blue,
  blockColor: Color.fromRGBO(67, 67, 67, 1),
);

AppColor redColor = AppColor(
  title: 'Red',
  basicColor: Color.fromRGBO(254, 71, 148, .7),
  menuColor: Color.fromRGBO(254, 71, 148, 1),
  darkShadow: Color.fromRGBO(254, 71, 120, 1),
  fontColor: Colors.white,
  lightShadow: Color.fromRGBO(50, 50, 50, .7),
  snakeColor: Colors.white70,
  loadingColor: Colors.lightBlueAccent,
  foodColor: Colors.teal,
  fontShadow: Colors.red,
  blockColor: Color.fromRGBO(67, 67, 67, 1),
);

AppColor greenColor = AppColor(
  title: 'Green',
  basicColor: Color.fromRGBO(86, 215, 187, .7), //rgb(86, 215, 187)
  menuColor: Color.fromRGBO(86, 215, 187, 1),
  darkShadow: Color.fromRGBO(75, 188, 162, 1), //rgb(75, 188, 162)
  fontColor: Colors.white,
  lightShadow: Color.fromRGBO(50, 50, 50, .7),
  snakeColor: Colors.white70,
  loadingColor: Colors.lightBlueAccent,
  foodColor: Colors.teal,
  fontShadow: Colors.green,
  blockColor: Color.fromRGBO(67, 67, 67, 1),
);

AppColor lightColor = AppColor(
  title: 'light',
  basicColor: Colors.white70,
  menuColor: Colors.white,
  darkShadow: Color.fromRGBO(200, 200, 200, .7),
  fontColor: Color.fromRGBO(12, 12, 12, 1),
  lightShadow: Color.fromRGBO(67, 67, 67, .7),
  snakeColor: Colors.black54,
  loadingColor: Colors.purpleAccent,
  foodColor: Colors.purple,
  fontShadow: Colors.grey,
  blockColor: Color.fromRGBO(67, 67, 67, 1),
);

AppColor darkColor = AppColor(
  title: 'Dark',
  basicColor: Color.fromRGBO(67, 67, 67, .7),
  menuColor: Color.fromRGBO(40, 40, 40, 1),
  darkShadow: Color.fromRGBO(90, 90, 90, 1),
  fontColor: Colors.white,
  lightShadow: Color.fromRGBO(12, 12, 12, 1),
  snakeColor: Colors.white70,
  loadingColor: Colors.red,
  foodColor: Colors.blue,
  fontShadow: Colors.black87,
  blockColor: Color.fromRGBO(225, 225, 225, 1),
);

List<AppColor> appColorList = [
  blueColor,
  redColor,
  greenColor,
  lightColor,
  darkColor
];
