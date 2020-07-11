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
      Post newPost = Post.fromJson(json.encode(post));

      postagens.add(newPost);
    }

    return postagens;
  }

  void _post() async {
    Post post = Post(120, null, 'title', 'body');

    http.Response response = await http.post(
      '$_baseURL/posts',
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: post.toJson(),
    );

    print(response.statusCode);
    print(response.body);
  }

  _put() async {
    Post post = Post(120, null, 'title', 'body');

    http.Response response = await http.put(
      '$_baseURL/posts/2',
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: post.toJson(),
    );

    print(response.statusCode);
    print(response.body);
  }

  _patch() async {
    Post post = Post(null, null, 'title', null);

    http.Response response = await http.patch(
      '$_baseURL/posts/2',
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: post.toJson(),
    );

    print(response.statusCode);
    print(response.body);
  }

  _delete() async {
    http.Response response = await http.delete('$_baseURL/posts/2');

    print(response.statusCode);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de serviço avançado'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      child: Text('Salvar'),
                      onPressed: _post,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      child: Text('Atualizar'),
                      onPressed: _put,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      child: Text('Atualizar parte'),
                      onPressed: _patch,
                    ),
                  ),
                  RaisedButton(
                    child: Text('Remover'),
                    onPressed: _delete,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
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
            ),
          ],
        ),
      ),
    );
  }
}
