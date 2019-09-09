import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/login/Login.dart';

class SplashScreen extends StatefulWidget {
  static String tag = 'spash-page';
  @override
  Splash createState() => new Splash();
}

class Splash extends State<SplashScreen> {
  final routes = <String, WidgetBuilder>{
    Login.tag: (context) => Login(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Recipes 1!!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Login(),
      routes: routes,
    );
  }
  /*startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("My Recipes!!",
                      style: new TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold))),
            ),
          ),
        ),
      ),
    );
  }*/
}
