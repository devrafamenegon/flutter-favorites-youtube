import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_favorites_youtube/blocs/favorite_bloc.dart';
import 'package:flutter_favorites_youtube/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        initialData: {},
        builder: (context, snapshot){
          return ListView(
            children: snapshot.data.values.map((v){
              return InkWell(
                onTap: (){
                  //O PLUGIN NÃO ESTÁ FUNCIONANDO!!!!!!
                  YoutubePlayerController _controller = YoutubePlayerController(
                    initialVideoId: v.id,
                    flags: YoutubePlayerFlags(
                      autoPlay: true,
                      mute: true,
                    ),
                  );

                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  );
                },
                onLongPress: (){
                  bloc.toggleFavorite(v);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 50,
                      child: Image.network(v.thumb),
                    ),
                    Expanded(
                        child: Text(
                          v.title,
                          style: TextStyle(color: Colors.white70),
                          maxLines: 2,
                        )
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
