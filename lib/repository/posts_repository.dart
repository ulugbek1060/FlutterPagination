import 'package:pagination_app/models/post.dart';
import 'package:pagination_app/sources/posts_source.dart';

class PostsRepository {
  final PostsSource postsSource;

  PostsRepository({
    required this.postsSource,
  });

  Future<List<Post>> fetchPosts({
    required int page,
    required int limit,
  }) {
    try {
      return postsSource.getPosts(
        page: page,
        limit: limit,
      );
    } on PostException catch (e) {
      throw e;
    }
  }
}
