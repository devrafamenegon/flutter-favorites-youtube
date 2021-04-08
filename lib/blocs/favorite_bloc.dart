import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_favorites_youtube/models/video_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {

  Map<String, Video> _favorites = {};

  //BehaviorSubject te manda o ultimo dado quando vc começar a observa-lo
  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});
  Stream<Map<String, Video>> get outFav => _favController.stream;

  FavoriteBloc(){
    SharedPreferences.getInstance().then((prefs) {
      if(prefs.getKeys().contains("favorites")){
        _favorites = json.decode(prefs.getString("favorites")).map((k, v){
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();

        _favController.add(_favorites);
      }
    });
  }

  void toggleFavorite(Video video){
    //se o video ja esta no mapa, eu removo do mapa
    if(_favorites.containsKey(video.id)) _favorites.remove(video.id);
    //caso contrario eu o adiciono ao mapa
    else _favorites[video.id] = video;

    //adicionei a lista de favoritos atualizada, assim todos os locais que tiver um streamBuilder desta lista, irá se reconstruir
    _favController.sink.add(_favorites);

    _saveFav();
  }

  void _saveFav(){
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favController.close();
  }
}