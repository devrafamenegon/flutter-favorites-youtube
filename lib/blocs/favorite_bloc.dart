import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_favorites_youtube/models/video_model.dart';

class FavoriteBloc implements BlocBase {

  Map<String, Video> _favorites = {};

  final StreamController<Map<String, Video>> _favController = StreamController<Map<String, Video>>.broadcast();
  Stream<Map<String, Video>> get outFav => _favController.stream;

  void toggleFavorite(Video video){
    //se o video ja esta no mapa, eu removo do mapa
    if(_favorites.containsKey(video.id)) _favorites.remove(video.id);
    //caso contrario eu o adiciono ao mapa
    else _favorites[video.id] = video;

    //adicionei a lista de favoritos atualizada, assim todos os locais que tiver um streamBuilder desta lista, irá se reconstruir
    _favController.sink.add(_favorites);
  }

  @override
  void dispose() {
    _favController.close();
  }
}