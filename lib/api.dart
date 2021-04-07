import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/video_model.dart';

const API_KEY = "AIzaSyA9ntdY5OHNnBP2YtP8tVA3eRi02h9Capk";

class Api {

  search(String search) async{
    http.Response response = await http.get(
        //fornece 10 objetos json com videos
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    decode(response);
  }

  decode(http.Response response) {
    if(response.statusCode == 200){
      var decoded = json.decode(response.body);

      //pega os items do json, que são uma lista de mapas, pego cada um dos mapas e transformo em um objeto video(declarado no models/video_model) e então passo para uma lista
      List<Video> videos = decoded["items"].map<Video>(
          (map){
            return Video.fromJson(map);
          }
      ).toList();

      print(videos);
    } else {
      throw Exception("Failed to load videos");
    }
  }
}