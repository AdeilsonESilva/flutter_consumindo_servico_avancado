import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _baseURL = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get('$_baseURL/posts');
    var dadosJson = json.decode(response.body);

    List<Post> postagens = List();

    for (var post in dadosJson) {
      Post newPost =
          Post(post['userId'], post['id'], post['title'], post['body']);
      postagens.add(newPost);
    }

    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de serviço avançado'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Post post = snapshot.data[index];

                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  },
                );
              }
              break;
          }
          return Text('Error');
        },
      ),
    );
  }
}
