import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade400,
      primary: Colors.grey.shade300,
      secondary: Colors.grey.shade300,
      onSecondary: Colors.grey.shade200,
    ));


    ThemeData darktMode = ThemeData( 
      scaffoldBackgroundColor: Colormanager.blackIcon,
     
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface:Colormanager.blackIcon,
      primary:Colormanager.blackIcon,
      secondary: Colormanager.blackIcon,
      onSecondary: Colormanager.blackIcon,
    ));

class ColorToggle{
  static bool themeCOlors =true;
} 