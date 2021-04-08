import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {

  @override
  //botão do topo na direita
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        }
      )
    ];
  }

  @override
  //widget do canto esquerdo
  Widget buildLeading(BuildContext context) {
    return
      IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation,
          ),
          onPressed: (){
            close(context, null);
          }
      );
  }

  @override
  Widget buildResults(BuildContext context) {

    //adiando o close para quando ele terminar de desenhar o widget (gambiarra pra fechar a tela passando o resultado pra tela anterior)
    Future.delayed(Duration.zero).then((_) => close(context, query));

    return Container();
  }

  //recarrega a cada mudança no search
  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty)
      return Container();
    else
      //pra cada valor digitado no campo de pesquisa, ele chama a função que gera a lista de sugestões com base no que foi digitado no campo
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(snapshot.data[index]),
                    leading: Icon(Icons.play_arrow),
                    onTap: (){
                      close(context, snapshot.data[index]);
                    },
                  );
                },
                itemCount: snapshot.data.length,
            );
          }
        }
      );
  }

  Future<List> suggestions(String search) async {
    http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
    );

    //se caso a resposta à requisição for 200(tudo ok), então eu acesso cada index de sugestão e retorno o index 0, pois contém a string da sugestão
    if(response.statusCode == 200){
        return json.decode(response.body)[1].map((v){
          return v[0];
        }).toList();
    } else {
      throw Exception("Failed to load suggestions");
    }
  }
}