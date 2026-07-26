import 'package:flutter/material.dart';

import '../network/local/shared_pref_helper.dart';

class AppColors {
  static Color appPrimaryColor = SharedPrefHelper.getData('isPurple') ?? true
      ? appPurblePrimaryColor
      : appBluePrimaryColor;
  static Color appSecondaryColor = SharedPrefHelper.getData('isPurple') ?? true
      ? appPurbleSecondaryColor
      : appBlueSecondaryColor;

  static const Color appBluePrimaryColor = Color(0xff2F6FB6);
  static const Color appBlueSecondaryColor = Color(0xff2F6FB6);

  static const Color appPurblePrimaryColor = Color(0xff123A6B);
  static const Color appPurbleSecondaryColor = Color(0xff123A6B);

  //  Colors.indigo;  or=> (0xff335ef7 ==>  #335ef7)

  static const darkBorder = Color(0xff303030);
  static const lightBborder = Color(0xffdddddd);

  static const darkBgColor = Color(0xff131313);
  static const lightBgColor = Color(0xffeeeeee);
}
