import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination_app/models/post.dart';

class PostPagingScreen extends StatefulWidget {
  const PostPagingScreen({super.key});

  @override
  State<PostPagingScreen> createState() => _PostPagingScreenState();
}

class _PostPagingScreenState extends State<PostPagingScreen> {
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getPosts(page: pageKey, limit: _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: _postList(context: context),
    );
  }

  Widget _postList({required BuildContext context}) {
    return PagedListView<int, Post>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: (context, item, index) => ListTile(
          title: Text(item.title),
          subtitle: Text(item.body),
        ),
      ),
    );
  }
}

const POSTS_LIMIT = 15;
const BASE_URL = 'https://jsonplaceholder.typicode.com/posts';

@override
Future<List<Post>> getPosts({required int page, required int limit}) {
  return HttpClient()
      .getUrl(Uri.parse('$BASE_URL?_limit=$limit&_page=$page'))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((str) {
    return json.decode(str) as List<dynamic>;
  }).then(
    (list) {
      print(list);
      return list
          .map(
            (element) => Post.fromJson(element),
          )
          .toList();
    },
  );
}
