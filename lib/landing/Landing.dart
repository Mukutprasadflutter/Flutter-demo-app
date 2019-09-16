import 'dart:convert';
import 'dart:io';

import 'package:TeamDebug/constant/Constant.dart';
import 'package:TeamDebug/createRecipes/CreateRecipeScreen.dart';
import 'package:TeamDebug/detail/LandingDetail.dart';
import 'package:TeamDebug/login/Login.dart';
import 'package:TeamDebug/profile/ProfileScreen.dart';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:path/path.dart';
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
  bool _isLoading = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _makeGetRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        actions: getActions(context),
        title: getTitle(),
        centerTitle: false,
        backgroundColor: Colors.amber,
        elevation: 5.0,
      ),
      body: _currentIndex == 0 ? getScrollView(context) : getProfileView(),
      bottomNavigationBar: getBottomNavigation(),
      floatingActionButton:
          _currentIndex == 0 ? getFloatingActionButton(context) : null,
    );
  }

  Widget _getItemUI(BuildContext context, FeedModel feedModel) {
    return new GestureDetector(
        onTap: () {
          openDetailScreen(feedModel, context);
        },
        child: new Card(
            child: new Column(
          children: <Widget>[
            FlatButton(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: Stack(children: <Widget>[
                    SizedBox(
                      child: CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        height: 200,
                        imageUrl: feedModel.photo,
                        placeholder: (context, url) => new Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      width: double.infinity,
                    ),
                    GestureDetector(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onTap: () {
                            getImage(feedModel.recipeId, feedModel);
                          },
                        ),
                      ),
                      onTap: () {},
                    ),
                  ]),
                ),
                onPressed: () {}),
            new ListTile(
              leading: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                    child: Text(feedModel.name,
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                    child: Text(feedModel.firstName + " " + feedModel.lastName,
                        style: new TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.normal)),
                  )
                ],
              ),
              trailing: GestureDetector(
                  child: feedModel.inCookingList == 1
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite,
                          color: Colors.black,
                        ),
                  onTap: () {
                    if ((feedModel.inCookingList == 0)) {
                      setState(() {
                        feedModel.inCookingList = 1;
                      });
                      postLike(feedModel, context);
                    } else {
                      setState(() {
                        feedModel.inCookingList = 0;
                      });
                      postUnlike(feedModel, context);
                    }
                  }),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LandingDetailScreen(feedModel.recipeId)),
                );
              },
            ),
          ],
        )));
  }

  getBottomNavigation() {
    return BottomNavigationBar(
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

  getActions(BuildContext context) {
    return <Widget>[
      FlatButton(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Text("Logout",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center),
        ),
        onPressed: () {
          _logOut(context);
        },
      )
    ];
  }

  getFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        floatingButtonClicked(context);
      },
      child: Icon(
        Icons.add,
      ),
      backgroundColor: Colors.amber,
    );
  }

  //=========================================API CALL============================================
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

  void postLike(FeedModel feedModel, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };
    String jsonReq =
        "{\"recipeId\": \"" + feedModel.recipeId.toString() + "\"}";
    Response response = await post(LIKE_API, headers: headers, body: jsonReq);
    String body = response.body;
    Map data = json.decode(body);
    if (response.statusCode == 200) {
      _isLoading = false;
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    _showStringSnackBar(data['msg'].toString());
  }

  void postUnlike(FeedModel feedModel, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };
    String jsonReq =
        "{\"recipeId\": \"" + feedModel.recipeId.toString() + "\"}";
    Response response = await post(UNLIKE_API, headers: headers, body: jsonReq);
    String body = response.body;
    Map data = json.decode(body);
    if (response.statusCode == 200) {
      _isLoading = false;
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    _showStringSnackBar(data['msg'].toString());
  }

  //=========================================SNACK BAR===========================================
  _showSnackBar(BuildContext context, FeedModel item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item.name}"),
      backgroundColor: Colors.black,
    );
    scaffoldKey.currentState.showSnackBar(objSnackbar);
  }

  _showStringSnackBar(String item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item}"),
      backgroundColor: Colors.black,
    );
    scaffoldKey.currentState.showSnackBar(objSnackbar);
  }

  //=========================================Click Events========================================
  void openDetailScreen(FeedModel feedModel, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LandingDetailScreen(feedModel.recipeId)),
    );
  }

  void floatingButtonClicked(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateRecipeScreen()));
  }

  void _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //=================================================Main Views===================================
  getScrollView(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child: Column(
      children: <Widget>[
        ...feeds.map((item) {
          return _getItemUI(context, item);
        })
      ],
    )));
  }

  getProfileView() {
    return ProfileScreen();
  }

  void getImage(int recipeId, FeedModel feedModel) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    uploadImage(image, recipeId, feedModel);
  }

  uploadImage(File imageFile, int recipeId, FeedModel feedModel) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(ADD_RECIPE_IMAGE_API);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('photo', stream, length,
        filename: basename(imageFile.path),
        contentType: new MediaType('image', 'png'));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    request.fields['recipeId'] = recipeId.toString();
    var response = await request.send();
    print("VALUE==>$response.statusCode");
    response.stream.transform(utf8.decoder).listen((value) {
      Map data = json.decode(value);
      if (response.statusCode == 200) {
        setState(() {
          feedModel.photo = data['photo'].toString();
        });
      }
      _showStringSnackBar(data['msg'].toString());
      print("VALUE==>" + value);
    });

    /*  var postUri = uri;
    var _request = new http.MultipartRequest("POST", postUri);
    _request.headers.addAll(headers);
    _request.fields['recipeId'] = recipeId.toString();
    var filePart = new http.MultipartFile.fromBytes('photo', await File.fromUri(Uri.parse(imageFile.path)).readAsBytes());
    filePart.contentType=(new MediaType('image', 'png'));
    _request.files.add();

    _request.send().then((response) {
      if (response.statusCode == 200) {
        print("Uploaded!");
      }else{
        print(response.reasonPhrase);
      }
    });*/
  }
}
