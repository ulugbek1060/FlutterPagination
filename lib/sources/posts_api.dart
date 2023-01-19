import 'package:flutter/foundation.dart';
import 'package:pagination_app/models/post.dart';

@immutable
abstract class PostsApi {
  Future<List<Post>> getPosts({required int page, required int limit});
}
