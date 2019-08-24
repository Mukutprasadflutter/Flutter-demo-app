import 'dart:convert';
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
        body: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("assets/images/ic_background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: new ListView.builder(
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  return ListTile(title: _getItemUI(context, index));
                })));
  }

  Widget _getItemUI(BuildContext context, int index) {
    return new Card(
        child: new Column(
          children: <Widget>[
        new CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.cover,
          height: 220,
          imageUrl: feeds[index].photo,
          placeholder: (context, url) =>
              new Image.asset('assets/images/image.png'),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
        new ListTile(
          leading:new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(feeds[index].name,
                  style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              new Text(feeds[index].firstName + " " + feeds[index].lastName,
                  style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal))

            ],
          )
          ,
          onTap: () {
            _showSnackBar(context, feeds[index]);
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
