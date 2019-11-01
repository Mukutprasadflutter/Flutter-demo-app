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
  _LandingDetailState createState() => new _LandingDetailState(feedId);
}

class _LandingDetailState extends State<LandingDetailScreen> {
  int feedId = 0;
  bool apiCall = false;
  String imageUrl = 'https://platerate.com/images/tempfoodnotext.png';
  FeedDetail feedDetail = new FeedDetail();

  _LandingDetailState(int id) {
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
    return Container(
        child: Column(
      children: <Widget>[
        ...feedDetail.ingredients.map((item) {
          return _getItemUI(context, item);
        })
      ],
    ));
  }

  getScrollViewInstruction(BuildContext context) {
    return Container(
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
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Container(
                  color: Colors.black12,
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 1, 1),
                            child: Row(
                              children: <Widget>[
                                Bullet(""),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(ingredient.ingredient.toUpperCase(),
                                    style: new TextStyle(fontSize: 18.0))
                              ],
                            ),
                          ),
                        ),
                      ]),
                )),
          ),
        ],
      ),
    );
  }

  Widget _getItemUIInstruction(BuildContext context, Instruction ingredient) {
    return new GestureDetector(
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Container(
                  color: Colors.black12,
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 1, 1),
                          child: Row(
                            children: <Widget>[
                              Bullet(""),
                              SizedBox(
                                width: 10,
                              ),
                              Text(ingredient.instruction.toUpperCase(),
                                  style: new TextStyle(fontSize: 18.0))
                            ],
                          ),
                        ),
                      ]),
                )),
          ),
        ],
      ),
    );
  }

  Widget _getItemUIComplexityType(
      BuildContext context, String complex, String time, String serves) {
    return new Container(
      color: Colors.black12,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Center(
                child: Container(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(1, 5, 1, 1),
                        child: Center(
                          child: Text("Complexity",
                              style: new TextStyle(fontSize: 15.0)),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(1, 2, 1, 5),
                        child: Center(
                          child: Text(complex,
                              style: new TextStyle(fontSize: 18.0)),
                        ),
                      ),
                    )
                  ]),
            )),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Center(
                child: Container(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(1, 5, 1, 1),
                        child: Center(
                          child: Text("Time",
                              style: new TextStyle(fontSize: 15.0)),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(1, 2, 1, 5),
                        child: Center(
                          child:
                              Text(time, style: new TextStyle(fontSize: 18.0)),
                        ),
                      ),
                    )
                  ]),
            )),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Center(
                child: Container(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(1, 5, 1, 1),
                        child: Center(
                          child: Text("Serves",
                              style: new TextStyle(fontSize: 15.0)),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(1, 2, 1, 5),
                        child: Center(
                          child: Text(serves,
                              style: new TextStyle(fontSize: 18.0)),
                        ),
                      ),
                    )
                  ]),
            )),
          ),
        ],
      ),
    );
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
            ? SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                      Center(
                        child: Container(
                          height: 40,
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              feedDetail.name,
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      _getItemUIComplexityType(context, feedDetail.complexity,
                          feedDetail.preparationTime, feedDetail.serves),
                      Container(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 40,
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              'Ingredient',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      feedDetail.ingredients != null &&
                              feedDetail.ingredients.isNotEmpty
                          ? getScrollView(context)
                          : Container(),
                      Container(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      Center(
                        child: Container(
                            height: 40,
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                'Instruction',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                      feedDetail.instructions != null &&
                              feedDetail.instructions.isNotEmpty
                          ? getScrollViewInstruction(context)
                          : Container(),
                      Container(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 180,
                          color: Colors.black12,
                          child: Center(
                            child: Text(
                                'Created By ' +
                                    feedDetail.firstName +
                                    ' ' +
                                    feedDetail.lastName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        ),
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

class Bullet extends Text {
  const Bullet(
    String data, {
    Key key,
    TextStyle style,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
  }) : super(
          '•',
          key: key,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        );
}
