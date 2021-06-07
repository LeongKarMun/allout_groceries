
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get darktheme {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.blue[300],
        focusColor: Colors.blue,
        fontFamily: 'Georgia',
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.blue, cursorColor: Colors.blue),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
        ),
        
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
        ));
  }

  static ThemeData get lighttheme {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.blue[300],
        focusColor: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.blue, cursorColor: Colors.blue),
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
        ));
  }
}