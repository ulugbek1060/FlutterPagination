import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_app/models/post.dart';
import 'package:pagination_app/repository/posts_repository.dart';

class PageCubit extends Cubit<PagingState> {
  final PostsRepository repository;
  final int limit;
  PageCubit({
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

@immutable
abstract class PagingState {
  const PagingState();
}

class PagingLoad extends PagingState {
  final int page;
  final List<Post> posts;
  final bool isLoading;
  final bool reachedEnd;
  const PagingLoad({
    required this.page,
    required this.posts,
    required this.isLoading,
    required this.reachedEnd,
  });

  const PagingLoad.initialState()
      : page = 1,
        posts = const [],
        isLoading = false,
        reachedEnd = false;
}

class PagingFail extends PagingState {
  final Object? error;
  const PagingFail({
    required this.error,
  });
}
