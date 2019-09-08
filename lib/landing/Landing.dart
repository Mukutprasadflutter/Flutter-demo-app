import 'dart:convert';
import 'package:TeamDebug/createRecipes/CreateRecipeScreen.dart';
import 'package:TeamDebug/detail/FeedDetail.dart';
import 'package:TeamDebug/detail/LandingDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TeamDebug/Constant/Constant.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FeedModel.dart';

class LandingScreen extends StatefulWidget {
  @override
  Landing createState() => new Landing();
}

class Landing extends State<LandingScreen> {
  var feeds = new List<FeedModel>();

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
        title: new Text(
          'Recipes',
          style: new TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRecipeScreen()));
        },
        child: Icon(Icons.add,),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Widget _getItemUI(BuildContext context, FeedModel feedModel) {
    return new Card(
        child: new Column(
      children: <Widget>[
        new CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.cover,
          height: 300,
          imageUrl: feedModel.photo,
          placeholder: (context, url) => new Image.asset('assets/images/image.png'),
          /*errorWidget: (context, url, error) => new Icon(Icons.error)*/
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => LandingDetailScreen(feedModel.recipeId)),
            );
            //_showSnackBar(context, feeds[index]);
          },
        ),
      ],
    ));
  }

  _showSnackBar(BuildContext context, FeedModel item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item.name}"),
      backgroundColor: Colors.black,
    );
    Scaffold.of(context).showSnackBar(objSnackbar);
  }
}
