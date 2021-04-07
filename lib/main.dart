import 'package:flutter/material.dart';
import 'package:flutter_favorites_youtube/screens/home_screen.dart';
import 'api.dart';

void main() {

  Api api = Api();
  api.search("Twenty One Pilots");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFavTube',
      home: Home(),
    );
  }
}
