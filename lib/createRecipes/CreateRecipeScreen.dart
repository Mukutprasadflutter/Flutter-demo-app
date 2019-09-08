import 'dart:convert';
import 'package:TeamDebug/constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRecipeScreen extends StatefulWidget {
  @override
  CreateRecipe createState() => new CreateRecipe();
}

class CreateRecipe extends State<CreateRecipeScreen> {
  var _name = TextEditingController(text: "");
  var _preparationTime = TextEditingController(text: "");
  var _serves = TextEditingController(text: "");
  var _complexity = TextEditingController(text: "");
  bool _isLoading = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  _createRecipeRequest(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };
    String jsonReq = "{\"name\": \"" +
        _name.text +
        "\", \"preparationTime\": \"" +
        _preparationTime.text +
        "\",\"serves\": \"" +
        _preparationTime.text +
        "\",\"complexity\": \"" +
        _complexity.text +
        "\"}";
    Response response =
        await post(ADD_RECIPE_API, headers: headers, body: jsonReq);
    int statusCode = response.statusCode;
    String body = response.body;
    Map data = json.decode(body);
    if (statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token'].toString());
      _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    var createRecepe = new SizedBox(
        width: double.infinity,
        child: new Container(
            child: new RaisedButton(
          onPressed: () => _createRecipeRequest(context),
          textColor: Colors.white,
          child: new Text("CREATE"),
          color: Colors.black54,
        )));
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          'Create Recipes',
          style: new TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: new Form(
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                controller: _name,
                decoration: new InputDecoration(labelText: "Name"),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                obscureText: true,
                controller: _preparationTime,
                decoration: new InputDecoration(labelText: "Preparation Time"),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                obscureText: true,
                controller: _serves,
                decoration: new InputDecoration(labelText: "Serves"),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                obscureText: true,
                controller: _complexity,
                decoration: new InputDecoration(labelText: "Complexity"),
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
                    : createRecepe)
          ],
        ),
      ),
    );
  }
}
