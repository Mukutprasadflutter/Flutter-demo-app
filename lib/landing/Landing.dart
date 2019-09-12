import 'dart:convert';

import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/createRecipes/CreateRecipeScreen.dart';
import 'package:TeamDebug/detail/LandingDetail.dart';
import 'package:TeamDebug/login/Login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FeedModel.dart';

class LandingScreen extends StatefulWidget {
  static String tag = 'landing-page';

  @override
  Landing createState() => new Landing();
}

class Landing extends State<LandingScreen> {
  var feeds = new List<FeedModel>();
  int _currentIndex = 0;

  @override
  void initState() {
    _makeGetRequest();
    super.initState();
  }

  _makeGetRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    Response response = await get(FEED_API, headers: headers);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      setState(() {
        Iterable list = json.decode(response.body);
        feeds = list.map((model) => FeedModel.fromJson(model)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: getActions(),
        title: getTitle(),
        centerTitle: false,
        backgroundColor: Colors.amber,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
          child: Container(
              child: Column(
                children: <Widget>[
                ...feeds.map((item) {
                  return _getItemUI(context, item);
          })
        ],
      ))),
      bottomNavigationBar: getBottomNavigation(),
      floatingActionButton: getFloatingActionButton(),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getItemUI(BuildContext context, FeedModel feedModel) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LandingDetailScreen(feedModel.recipeId)),
          );
        },
        child: new Card(
            child: new Column(
          children: <Widget>[
            Container(
              height: 250,
              child: CachedNetworkImage(
                width: double.infinity,
                fit: BoxFit.cover,
                height: 250,
                imageUrl: feedModel.photo,
                placeholder: (context, url) =>
                    new Image.asset('assets/images/image.png'),
                /*errorWidget: (context, url, error) => new Icon(Icons.error)*/
              ),
            ),
            new ListTile(
              leading: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(feedModel.name,
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  new Text(feedModel.firstName + " " + feedModel.lastName,
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.normal))
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LandingDetailScreen(feedModel.recipeId)),
                );
                //_showSnackBar(context, feeds[index]);
              },
            ),
          ],
        )));
  }

  _showSnackBar(BuildContext context, FeedModel item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item.name}"),
      backgroundColor: Colors.black,
    );
    Scaffold.of(context).showSnackBar(objSnackbar);
  }

  void _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  getBottomNavigation() {
    return  BottomNavigationBar(
      onTap: onTabTapped, // new
      currentIndex: _currentIndex, // new
      items: [
        new BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        new BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text('Profile'))
      ],
    );
  }

  getTitle() {
    return Text(
      'Home',
      style: new TextStyle(
        color: Colors.white,
      ),
    );
  }

  getActions() {
   return <Widget>[
      FlatButton(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Text("Logout",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center),
        ),
        onPressed: () {
          _logOut();
        },
      )
    ];
  }

  getFloatingActionButton() {
   return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateRecipeScreen()));
      },
      child: Icon(
        Icons.add,
      ),
      backgroundColor: Colors.amber,
    );
  }
}
