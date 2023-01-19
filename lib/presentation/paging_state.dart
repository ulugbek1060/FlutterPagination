import 'package:flutter/material.dart';

import '../models/post.dart';

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
