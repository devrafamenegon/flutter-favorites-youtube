import 'dart:async';
import 'package:flutter_favorites_youtube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_favorites_youtube/models/video_model.dart';

class VideosBloc implements BlocBase {

  Api api;

  List<Video> videos;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();

  //permite o acesso dos videos passados à stream a outros arquivos externos
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();

  //permite colocar um dado dentro do searchController
  Sink get inSearch => _searchController.sink;

  VideosBloc(){
    api = Api();

    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if(search != null){
      //passo uma lista vazia para refazer e voltar ao inicio, e depois carrega a nova lista
      _videosController.sink.add([]);
      videos = await api.search(search);
    } else {
      //juntando a lista dos proximos 10 e adicionando à minha lista
      videos += await api.nextPage();
    }
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

}