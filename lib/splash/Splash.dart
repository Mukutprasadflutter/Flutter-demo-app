import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:TeamDebug/landing/Landing.dart';
import 'package:TeamDebug/login/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart';

class SplashScreen extends StatefulWidget {
  static String tag = 'spash-page';

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = Duration(seconds: 5);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    if (token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );
    }
  }

  Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 10, 0.0, 0.0);
  }

  @override
  void initState() {
    super.initState();
    startTime();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        /*  decoration:  BoxDecoration(
          image:  DecorationImage(
              image:  AssetImage("assets/images/ic_background.jpg"),
              fit: BoxFit.cover),
        ),*/
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0)),
        child: Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Transform(
                    transform: Matrix4.translation(_shake()),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
