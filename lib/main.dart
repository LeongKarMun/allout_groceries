import 'package:allout_groceries/themes.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: CustomTheme.lighttheme,
      title: 'Material App',
      home: SplashScreen());
  }
}