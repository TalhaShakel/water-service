import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';

class AppTheme
{
  static Color lightBG = Color(0xffa7dbd8);

  static Map<int, Color> myCursorColor =
  {
    50:Color.fromRGBO(167,219,216, .1),
    100:Color.fromRGBO(167,219,216, .2),
    200:Color.fromRGBO(167,219,216, .3),
    300:Color.fromRGBO(167,219,216, .4),
    400:Color.fromRGBO(167,219,216, .5),
    500:Color.fromRGBO(167,219,216, .6),
    600:Color.fromRGBO(167,219,216, .7),
    700:Color.fromRGBO(167,219,216, .8),
    800:Color.fromRGBO(167,219,216, .9),
    900:Color.fromRGBO(167,219,216, 1),
  };

  static MaterialColor colorCustom = MaterialColor(0xFFa7dbd8, myCursorColor);

  static ThemeData lightTheme = ThemeData(
    fontFamily: "AppRegular",
    backgroundColor: lightBG,
    primaryColor: colorCustom,
    primarySwatch: colorCustom,
    accentColor:  colorCustom,
    cursorColor: AppColor.appDarkSkyBlue,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: "AppRegular",
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

}