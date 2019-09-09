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
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: 'jm1@example.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: 'jay@123',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.blue)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          print('mame');
          Navigator.of(context).pushNamed(LandingScreen.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.amber,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    /*final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );*/

    return Scaffold(
      backgroundColor: Colors.white,
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
            loginButton
          ],
        ),
      ),
    );
  }
/*BuildContext _ctx;
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
            width: 320.0,
            height: 60.0,
            alignment: FractionalOffset.center,
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
  }*/
}
