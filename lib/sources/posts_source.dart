import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pagination_app/models/post.dart';
import 'package:pagination_app/sources/posts_api.dart';

class PostsSource implements PostsApi {
  static const BASE_URL = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Future<List<Post>> getPosts({required int page, required int limit}) {
    return HttpClient()
        .getUrl(Uri.parse('$BASE_URL?_limit=$limit&_page=$page'))
        .then((req) => req.close())
        .then((res) => res.transform(utf8.decoder).join())
        .then((str) => json.decode(str) as List<dynamic>)
        .then((list) => list.map((element) => Post.fromJson(element)).toList());
  }
}

@immutable
abstract class AppException implements Exception {
  const AppException(String message);
}

class PostException extends AppException {
  const PostException(super.message);
}
