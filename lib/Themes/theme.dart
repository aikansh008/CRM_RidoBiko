import 'package:crm_app/Utils/Constants/Colors.dart';
import 'package:crm_app/themes/appbar_theme.dart';
import 'package:crm_app/themes/texttheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  //creating object of themedata class for light theme//
  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor:Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme:Texttheme.lighttheme,
    appBarTheme:Appbartheme.lightappbar,
  );
   static ThemeData darktheme = ThemeData(
     useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor:Colors.blue,
    scaffoldBackgroundColor:ColorsApp.grey,
    textTheme:Texttheme.darktheme,
    appBarTheme:Appbartheme.darkappbar,
   );
}
