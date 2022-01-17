import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']
    );
  }
}

void main() {
  runApp(const MyApp());
}
// конвертация http.Response в Post
Future<Post> fetchPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Не удалось загрузить посты');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Post number one'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: FutureBuilder<Post>(
              future: futurePost,
              builder: (context, post) {
                if (post.hasData) {
                  return Text(post.data!.title, style: const TextStyle(fontSize: 17));
                } else if (post.hasError) {
                  return Text('${post.error}');
                }

                // по умолчанию показывать счётчик загрузки (прогресс)
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}

