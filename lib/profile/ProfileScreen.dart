import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileView createState() => new ProfileView();
}

class ProfileView extends State<ProfileScreen> {
  var firstName ="";
  var lastName ="";


  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? "";
      lastName = prefs.getString('lastName') ?? "";
    });
  }

  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.black.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            image: DecorationImage(
                                image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/768px-Circle-icons-profile.svg.png'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black.withOpacity(0.8))])),
                    SizedBox(height: 30.0),
                    Text(
                     firstName+" "+ lastName,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    /*SizedBox(height: 15.0),
                    Text(
                      'Subscribe guys',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),*/
                    /*SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),*/
                    /*SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 200.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.amber,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ))*/
                  ],
                ))
          ],
        ));
  }

  getName() async {

  }
}
class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}