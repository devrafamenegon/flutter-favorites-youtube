import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_favorites_youtube/blocs/favorite_bloc.dart';
import 'package:flutter_favorites_youtube/blocs/video_bloc.dart';
import 'package:flutter_favorites_youtube/delegates/data_search.dart';
import 'package:flutter_favorites_youtube/models/video_model.dart';
import 'package:flutter_favorites_youtube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<VideosBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("assets/yt_logo_dark.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.of<FavoriteBloc>(context).outFav,
              initialData: {},
              builder: (context, snapshot){
                if(snapshot.hasData) return Text("${snapshot.data.length}");
                else return Container();
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.star),
              onPressed: (){

              }
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String result = await showSearch(context: context, delegate: DataSearch());
                if(result != null) bloc.inSearch.add(result);
              }
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
        stream: BlocProvider.of<VideosBloc>(context).outVideos,
        builder: (context, snapshot){
          if(snapshot.hasData)
            return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  } else if (index > 1) {
                    bloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),
                    );
                  } else {
                    return Container();
                  }
                },
              //passo 1 item a mais do que realmente existe, enquanto estiver nos videos normais,
              // ele retorna apenas o vídeo, quando chegar no último, ele mostra o CircularProgressIndicator e carrega + 10 vídeos,
              //assim, no videos_bloc, como foi passado um search(null), ele passa um api.nextPage, e por fim manda um sink para o videoController
              //desta forma, atualizando o streamBuilder e montando os proximos 10 videos
              itemCount: snapshot.data.length + 1,
            );
          else
            return Container();
        },
      ),
    );
  }
}
