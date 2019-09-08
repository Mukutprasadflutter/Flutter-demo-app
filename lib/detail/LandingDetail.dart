import 'dart:convert';
import 'package:TeamDebug/Landing/FeedModel.dart';
import 'package:TeamDebug/detail/FeedDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TeamDebug/Constant/Constant.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingDetailScreen extends StatefulWidget {
  int feedId = 0;

  LandingDetailScreen(int id) {
    feedId = id;
  }

  @override
  LandingDetail createState() => new LandingDetail(feedId);
}

class LandingDetail extends State<LandingDetailScreen> {
  int feedId = 0;
  bool apiCall = false;
  FeedDetail feedDetail = new FeedDetail();

  LandingDetail(int id) {
    feedId = id;
  }

  @override
  void initState() {
    _makeGetRequest();
    super.initState();
  }

  _makeGetRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    Response response =
        await get(FEED_DETAIL_API + feedId.toString() + "/detailS", headers: headers);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      setState(() {
        feedDetail = FeedDetail.fromJson(json.decode(response.body));
        apiCall = true;
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
                itemCount: feedDetail.instructions.length,
                itemBuilder: (context, index) {
                  return ListTile(title: _getItemUI(context, index));
                })));
  }

  Widget _getItemUI(BuildContext context, int index) {
    return new Card(
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading:new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(feedDetail.instructions[index].instruction,
                      style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                ],
              )
            ),
          ],
        ));
  }

  Widget _getItemUIMM(BuildContext context) {
    return new Card(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.cover,
          height: 400,
          imageUrl: feedDetail.photo == null ? "" : feedDetail.photo,
          placeholder: (context, url) =>
              new Image.asset('assets/images/image.png'),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
        new Text(feedDetail.name != null ? feedDetail.name : "",
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        new Text(
            feedDetail.firstName == null
                ? ""
                : feedDetail.firstName + " " + feedDetail.lastName == null
                    ? ""
                    : feedDetail.lastName,
            style:
                new TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
        new Text(feedDetail.complexity == null ? "" : feedDetail.complexity,
            style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal))
        /*feedDetail.ingredients != null
            ? new ListView.builder(
                itemCount: feedDetail.ingredients.length,
                itemBuilder: (context, index) {
                  return Text(feedDetail.ingredients[index].ingredient);
                })
            : new Text(""),*/
        /*feedDetail.instructions != null
            ? new ListView.builder(
                itemCount: feedDetail.instructions.length,
                itemBuilder: (context, index) {
                  return Text(feedDetail.instructions[index].instruction);
                })
            : Text("")*/
      ],
    ));
  }
}
