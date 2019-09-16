import 'dart:convert';

import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/detail/FeedDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Response response = await get(
        FEED_DETAIL_API + feedId.toString() + "/detailS",
        headers: headers);
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
      appBar: new AppBar(
        title: new Text(
          'Details',
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
        elevation: 5.0,
      ),
      body: Container(
          height: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/ic_background.jpg"),
                fit: BoxFit.cover),
          ),
          child: _getItemUIMM(context)),
    );
  }

  Widget _getItemUIMM(BuildContext context) {
    return new Container(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                child: CachedNetworkImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 150,
                    imageUrl: feedDetail.photo == null ? "" : feedDetail.photo,
                    placeholder: (context, url) =>
                        new Image.asset('assets/images/placeholder.jpg')),
              ),
              Column(
                children: <Widget>[
                  Text("Title",
                      style: new TextStyle(backgroundColor: Colors.amber,
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Row(
                    children: <Widget>[
                      Text(feedDetail.name != null ? feedDetail.name : "",
                          style: new TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              new Text(
                  feedDetail.firstName == null
                      ? ""
                      : feedDetail.firstName + " " + feedDetail.lastName == null
                          ? ""
                          : feedDetail.lastName,
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.normal)),
              new Text(
                  feedDetail.complexity == null ? "" : feedDetail.complexity,
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.normal)),
              new Container(
                  child: Column(
                children: feedDetail.ingredients != null
                    ? <Widget>[
                        ...feedDetail.ingredients.map((item) {
                          return Text(item.ingredient);
                        })
                      ]
                    : <Widget>[Text("")],
              )),
              new Container(
                  child: Column(
                children: feedDetail.instructions != null
                    ? <Widget>[
                        ...feedDetail.instructions.map((item) {
                          return Text(item.instruction);
                        })
                      ]
                    : <Widget>[Text("")],
              )),
              /*new Container(
            height: 200,
            width: double.infinity,
            child: feedDetail.ingredients != null
                ? new ListView.builder(
                itemCount: feedDetail.ingredients.length,
                itemBuilder: (context, index) {
                  return Text(feedDetail.ingredients[index].ingredient);
                })
                : Text("")),*/
              /*new Container(
                height: 200,
                width: double.infinity,
                child: feedDetail.instructions != null
                    ? new ListView.builder(
                        itemCount: feedDetail.instructions.length,
                        itemBuilder: (context, index) {
                          return Text(
                              feedDetail.instructions[index].instruction);
                        })
                    : Text(""),
              )*/
            ],
          ),
        ));
  }
}
