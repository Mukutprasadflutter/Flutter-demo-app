import 'package:flutter/material.dart';
import 'package:start_flutter_app/services/authentication.dart';
import 'package:start_flutter_app/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud operation with firebase',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: new RootPage(auth: new Auth())
    );
  }
}