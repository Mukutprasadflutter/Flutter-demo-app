import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/login/Login.dart';

class SplashScreen extends StatefulWidget {
  static String tag = 'spash-page';
  @override
  Splash createState() =>  Splash();
}

class Splash extends State<SplashScreen> {
  startTime() async {
    var _duration =  Duration(seconds: 3);
    return  Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: null,
      body:  Container(
      /*  decoration:  BoxDecoration(
          image:  DecorationImage(
              image:  AssetImage("assets/images/ic_background.jpg"),
              fit: BoxFit.cover),
        ),*/
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child:  Center(
          child:  ClipRect(
            child:  BackdropFilter(
              filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child:  Container(
                child: Image.asset('assets/images/logo.png',width: 200,height: 200,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}