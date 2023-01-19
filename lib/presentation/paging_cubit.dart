import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_app/models/post.dart';
import 'package:pagination_app/presentation/paging_state.dart';
import 'package:pagination_app/repository/posts_repository.dart';

class Paging extends Cubit<PagingState> {
  final PostsRepository repository;
  final int limit;
  Paging({
    required this.repository,
    required this.limit,
  }) : super(const PagingLoad.initialState()) {
    loadPage();
  }

  loadPage() async {
    final currentState = state;
    if (currentState is PagingLoad && !currentState.reachedEnd) {
      emit(PagingLoad(
        page: currentState.page,
        posts: currentState.posts,
        isLoading: true,
        reachedEnd: false,
      ));

      try {
        final newPosts = await repository.fetchPosts(
          page: currentState.page,
          limit: limit,
        );

        emit(PagingLoad(
          page: currentState.page + 1,
          posts: <Post>[...currentState.posts, ...newPosts],
          isLoading: false,
          reachedEnd: newPosts.length < limit,
        ));
      } catch (e) {
        emit(PagingFail(error: e));
      }
    }
  }
}
