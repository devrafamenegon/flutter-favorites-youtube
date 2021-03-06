import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_favorites_youtube/blocs/favorite_bloc.dart';
import 'package:flutter_favorites_youtube/blocs/video_bloc.dart';
import 'package:flutter_favorites_youtube/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterFavTube',
          home: Home(),
        ),
      ),
    );
  }
}
