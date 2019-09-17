import 'dart:convert';

import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/detail/FeedDetail.dart';
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
        imageUrl = (feedDetail.photo == null||feedDetail.photo=="") ? imageUrl : feedDetail.photo ;
        print(imageUrl);
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
      body: apiCall?SafeArea(child: Column(
        children: <Widget>[
          Image.network(imageUrl,
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          ListTile(
            title: Text(
                'Created By '+ feedDetail.firstName + ' ' +  feedDetail.lastName,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('Ingredient which are used for ' + feedDetail.name,
              style: TextStyle(fontStyle: FontStyle.italic),),
          ),
          ListTile(
            title: Text('Complexity: '+ feedDetail.complexity, style: TextStyle(fontWeight: FontWeight.normal)),
          ),
          ListTile(
            title: Text('Type: '+ feedDetail.complexity, style: TextStyle(fontWeight: FontWeight.normal)),
          ),
        ],
      ),
      ):Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
