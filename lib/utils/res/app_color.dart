import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor {

  static dynamic theme_Color = 0xFF165dA7;
  static dynamic theme_LightColor = 0xFF3688DD;

  AppColor({required dynamic themeColor, required dynamic themeLightColor}){
    theme_Color =  themeColor;
    theme_LightColor =  themeLightColor;
  }

  static get themeColor => Color(theme_Color);
  static get themeLightColor => Color(theme_LightColor);

  static get grey => Colors.grey;
  static get lightGrey => Colors.black12;
  static get black => Colors.black;
  static get white => Colors.white;
  static get red => Colors.red;
  static get cardBlue => const Color(0xFF48A9F8);
  static get cardGreen => const Color(0xFF1BD084);
  static get cardLightGreen => const Color(0xFF8BC740);

  static get themeSecondary => const Color(0xFFea8e11);
}