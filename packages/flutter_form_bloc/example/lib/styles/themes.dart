import 'package:flutter/material.dart';

class Themes {
  Themes._();

  static ThemeData formTheme = ThemeData.light().copyWith(
    brightness: Brightness.dark,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    errorColor: Colors.red[100],
    cardColor: Colors.white,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.indigo,
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
    ),
    textTheme: TextTheme(
      button: TextStyle(
        color: Colors.grey[800],
        fontSize: 14,
      ),
      body1: TextStyle(color: Colors.white70),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    hintColor: Color(0x80FFFFFF),
    disabledColor: Color(0x80FFFFFF),
    accentColor: Colors.greenAccent,
    dividerColor: Colors.white30,
    toggleableActiveColor: Colors.greenAccent,
    unselectedWidgetColor: Colors.white,
  );
}
