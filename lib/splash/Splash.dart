import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TeamDebug/Constant/Constant.dart';
import 'package:TeamDebug/login/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  Splash createState() => new Splash();
}

class Splash extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
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
    /*return new Scaffold(
      body: new Stack(
        fit: StackFit.passthrough,
        children: <Widget>[new Image.asset('assets/images/ic_background.jpg')],
      ),
    );*/
    return new Scaffold(
      appBar: null,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/images/ic_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: Text("My Recipes!!", style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold))
              ),
            ),
          ),
        ),
      ),
    );
  }
}