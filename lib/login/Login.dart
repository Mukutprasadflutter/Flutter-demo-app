import 'dart:convert';
import 'dart:ui';

import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/landing/Landing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  var _password = TextEditingController(text: "jay@123");
  var _username = TextEditingController(text: "jm1@example.com");
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/images/logo.png'),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _username,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.blue)),
      ),
    );

    final loginButton = SizedBox(
      height: 70,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            _submit(context);
          },
          color: Colors.amber,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final progress = Center(
      child:SizedBox(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ))
      ),
    );


    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            _isLoading ? progress : loginButton
          ],
        ),
      ),
    );
  }

  Future _submit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonReq = "{\"email\": \"" +
        _username.text +
        "\", \"password\": \"" +
        _password.text +
        "\"}";
    Response response = await post(LOGIN_API, headers: headers, body: jsonReq);
    String body = response.body;
    Map data = json.decode(body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token'].toString());
      _isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(context, data['error'].toString());
    }
  }

  _showSnackBar(BuildContext context, String message) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("$message"),
      backgroundColor: Colors.black,
    );
    scaffoldKey.currentState.showSnackBar(objSnackbar);
  }
}
