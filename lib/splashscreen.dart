import 'package:flutter/material.dart';
import 'dart:async';
import 'loginscreen.dart';
 
class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(
      Duration(seconds:5),
      () => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => LoginScreen())
      )
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(50),
                child: Image.asset('assets/images/allout1.png'))
            ],
          ),
        ),
    );
  }
}