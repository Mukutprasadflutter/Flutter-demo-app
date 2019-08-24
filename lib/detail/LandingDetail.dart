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
  String feedId = "";

  LandingDetailScreen(String id) {
    feedId = id;
  }

  @override
  LandingDetail createState() => new LandingDetail(feedId);
}

class LandingDetail extends State<LandingDetailScreen> {
  String feedId = "";
  FeedDetail feedDetail;

  LandingDetail(String id) {
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
        await get(FEED_DETAIL_API + feedId + "/detailS", headers: headers);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      setState(() {
        feedDetail = json.decode(response.body) as FeedDetail;
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
        child: _getItemUI(context),
      ),
    );
  }

  Widget _getItemUI(BuildContext context) {
    return new Card(
        child: new Column(
      children: <Widget>[
        new CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.cover,
          height: 220,
          imageUrl: feedDetail.photo,
          placeholder: (context, url) =>
              new Image.asset('assets/images/image.png'),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
        new ListTile(
          leading: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(feedDetail.name,
                  style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
              new Text(feedDetail.firstName + " " + feedDetail.lastName,
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.normal))
            ],
          ),
          onTap: () {},
        ),
      ],
    ));
  }
}
