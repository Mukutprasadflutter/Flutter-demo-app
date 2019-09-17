import 'dart:convert';

import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/detail/FeedDetail.dart';
import 'package:TeamDebug/detail/Ingredient.dart';
import 'package:TeamDebug/detail/Instruction.dart';
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
  String imageUrl = 'https://platerate.com/images/tempfoodnotext.png';
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
        print('$feedDetail');
        imageUrl = (feedDetail.photo == null || feedDetail.photo == "")
            ? imageUrl
            : feedDetail.photo;
        print(imageUrl);
        apiCall = true;
      });
    }
  }

  getScrollView(BuildContext context) {
    Container(
        child: Column(
      children: <Widget>[
        ...feedDetail.ingredients.map((item) {
          return _getItemUI(context, item);
        })
      ],
    ));
  }

  getScrollViewInstruction(BuildContext context) {
    Container(
        child: Column(
      children: <Widget>[
        ...feedDetail.instructions.map((item) {
          return _getItemUIInstruction(context, item);
        })
      ],
    ));
  }

  Widget _getItemUI(BuildContext context, Ingredient ingredient) {
    return new GestureDetector(
        child: new Card(
            child: new ListTile(
                leading: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
            child: Text(ingredient.ingredient,
                style:
                    new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
        ]))));
  }

  Widget _getItemUIInstruction(BuildContext context, Instruction ingredient) {
    return new GestureDetector(
        child: new Card(
            child: new ListTile(
                leading: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
            child: Text(ingredient.instruction,
                style:
                    new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
        ]))));
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
        body: apiCall
            ? SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                      ListTile(
                        title: Text(
                            'Created By ' +
                                feedDetail.firstName +
                                ' ' +
                                feedDetail.lastName,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        title: Text(
                          'Ingredient which are used for ' + feedDetail.name,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      feedDetail.instructions!=null&&feedDetail.instructions.isNotEmpty?getScrollView(context):null,
                      ListTile(
                        title: Text(
                          'Instruction which are used for ' + feedDetail.name,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      //getScrollViewInstruction(context),
                      ListTile(
                        title: Text('Complexity: ' + feedDetail.complexity,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      ListTile(
                        title: Text('Type: ' + feedDetail.complexity,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
