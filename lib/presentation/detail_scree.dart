import 'package:flutter/material.dart';
import 'package:pagination_app/models/post.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail-screen';

  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Column(
        children: [
          Text(post.title),
          Text(post.body),
        ],
      ),
    );
  }
}
