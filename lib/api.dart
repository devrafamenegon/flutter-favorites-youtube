import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/video_model.dart';

const API_KEY = "AIzaSyA9ntdY5OHNnBP2YtP8tVA3eRi02h9Capk";

class Api {

  String _search;

  Future<List<Video>> search(String search) async {

    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    return decode(response);

  }
  List<Video> decode(http.Response response) {

    if(response.statusCode == 200){

      var decoded = json.decode(response.body);

      //pega os items do json, que são uma lista de mapas, pego cada um dos mapas e transformo em um objeto video(declarado no models/video_model) e então passo para uma lista
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