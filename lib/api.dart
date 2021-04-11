import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/video_model.dart';

//chave para minha api gerada no google.developer
const API_KEY = "AIzaSyA9ntdY5OHNnBP2YtP8tVA3eRi02h9Capk";

class Api {

  String _search;
  String _nextToken;

  //Função que retorna uma lista com 10 videos com base no que foi passado de parâmetro
  Future<List<Video>> search(String search) async {
    _search = search;
    http.Response response = await http.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");
    return decode(response);
  }

  //Função para carregar mais 10 videos quando o usuário chegar ao fim da lista dos 10 ja carregados
  Future<List<Video>> nextPage() async {
    http.Response response = await http.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken");
    return decode(response);
  }

  //Função que pega a lista de videos e então transforma em uma lista de objetos videos
  List<Video> decode(http.Response response) {
    if(response.statusCode == 200){
      var decoded = json.decode(response.body);
      _nextToken = decoded["nextPageToken"];

      //Pega os items do json, que são uma lista de mapas, pega cada um dos mapas e transforma em um objeto video(declarado no models/video_model) e então passa para uma lista
      List<Video> videos = decoded["items"].map<Video>(
        (map){
          return Video.fromJson(map);
        }
      ).toList();
      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }

}