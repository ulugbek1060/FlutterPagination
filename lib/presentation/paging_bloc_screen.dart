import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_app/presentation/detail_scree.dart';
import 'package:pagination_app/presentation/paging_cubit.dart';
import 'package:pagination_app/presentation/paging_state.dart';
import 'package:pagination_app/repository/posts_repository.dart';
import 'package:pagination_app/sources/posts_source.dart';

class BlogPagingScreen extends StatelessWidget {
  const BlogPagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
      ),
      body: BlocProvider(
        create: (_) => Paging(
          repository: PostsRepository(
            postsSource: PostsSource(),
          ),
          limit: 20,
        ),
        child: BlocConsumer<Paging, PagingState>(
          listener: (context, state) {},
          builder: (context, state) {
            final currentState = state;
            if (currentState is PagingLoad) {
              final posts = currentState.posts;
              return NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.atEdge) {
                    if (notification.metrics.pixels != 0) {
                      context.read<Paging>().loadPage();
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: currentState.posts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          DetailScreen.routeName,
                          arguments: posts[index],
                        );
                      },
                      child: ListTile(
                        title: Text(posts[index].title),
                        subtitle: Text(posts[index].body),
                      ),
                    );
                  },
                ),
              );
            } else if (currentState is PagingFail) {
              return Center(
                child: Text(currentState.error.toString()),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
