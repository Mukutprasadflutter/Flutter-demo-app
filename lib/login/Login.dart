import 'dart:convert';
import 'dart:ui';

import 'package:TeamDebug/Constant/Constant.dart';
import 'package:TeamDebug/Landing/Landing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  var _password = TextEditingController(text: "jay@123");
  var _username = TextEditingController(text: "jm1@example.com");
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new SizedBox(
        width: double.infinity,
        child: new Container(
            child: new RaisedButton(
          onPressed: () => _submit(context),
          textColor: Colors.white,
          child: new Text("LOGIN"),
          color: Colors.black54,
        )));
    var loginForm = new Column(
      children: <Widget>[
        new Container(
          child: new Text(
            "Welcome To My Recipes!!",
            textScaleFactor: 2.0,
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.all(10),
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  controller: _username,
                  validator: (val) {
                    return val.length < 10
                        ? "Username must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  controller: _password,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.all(10),
          child: _isLoading
              ? new SizedBox(
                  child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.blue),
                      strokeWidth: 3.0),
                  height: 20.0,
                  width: 20.0,
                )
              : loginBtn,
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
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
                child: loginForm,
                height: 320.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
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
    int statusCode = response.statusCode;
    String body = response.body;
    Map data = json.decode(body);
    if (statusCode == 200) {
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
