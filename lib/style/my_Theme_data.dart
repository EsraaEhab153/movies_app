import 'package:flutter/material.dart';
import 'package:movies_app/style/app_colors.dart';

class MyThemeData {
  static final ThemeData appTheme = ThemeData(
    primaryColor: MyAppColors.primaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyAppColors.grayColor,
      selectedItemColor: MyAppColors.goldColor,
      showUnselectedLabels: true,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}
