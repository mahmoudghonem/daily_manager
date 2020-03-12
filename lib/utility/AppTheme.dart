import 'package:flutter/material.dart';

class AppTheme {
  static String appName = "Daily Manager";
  static Color darkPrimary = Colors.black;
  static Color darkAccent = Colors.orange;
  static Color lightPrimary = Colors.white;
  static Color lightAccent = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightPrimary,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightPrimary,
    primaryColorBrightness: Brightness.light,
    primaryIconTheme: IconThemeData(color: lightPrimary),
    appBarTheme: AppBarTheme(
      color: lightAccent,
      actionsIconTheme: IconThemeData(color: lightPrimary),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: lightPrimary,
      shape: CircularNotchedRectangle(),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    backgroundColor: darkPrimary,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    cursorColor: darkAccent,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkPrimary,
    primaryColorBrightness: Brightness.dark,
    primaryIconTheme: IconThemeData(color: darkAccent),
    appBarTheme: AppBarTheme(
      color: darkPrimary,
      actionsIconTheme: IconThemeData(color: darkAccent),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: darkPrimary,
      shape: CircularNotchedRectangle(),
    ),
  );
}
