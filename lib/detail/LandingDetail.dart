import 'dart:convert';

import 'package:TeamDebug/Constant/Constant.dart';
import 'package:TeamDebug/detail/FeedDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool apiCall = false;
  FeedDetail feedDetail = new FeedDetail();

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
        feedDetail = FeedDetail.fromJson(json.decode(response.body));
        apiCall = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: double.infinity,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/images/ic_background.jpg"),
                    fit: BoxFit.cover),
              )),
          Container(
            child: apiCall ? _getItemUI(context) : Text(""),
          ),
        ],
      ),
    );
  }

  Widget _getItemUI(BuildContext context) {
    return new Card(
        child: SingleChildScrollView(
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
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          new Text(
              feedDetail.firstName == null
                  ? ""
                  : feedDetail.firstName + " " + feedDetail.lastName == null
                      ? ""
                      : feedDetail.lastName,
              style:
                  new TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
          new Text(feedDetail.complexity == null ? "" : feedDetail.complexity,
              style:
                  new TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
          Container(
              child: Column(
            children: <Widget>[
              ...feedDetail.ingredients.map((item) {
                return Text(item.ingredient);
              })
            ],
          )),
          Container(
            height: 200,
            child: feedDetail.instructions != null
                ? new ListView.builder(
                    itemCount: feedDetail.instructions.length,
                    itemBuilder: (context, index) {
                      return Text(feedDetail.instructions[index].instruction);
                    })
                : Text(""),
          )
        ],
      ),
    ));
  }
}
