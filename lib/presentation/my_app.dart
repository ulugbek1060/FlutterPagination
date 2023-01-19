import 'package:flutter/material.dart';
import 'package:pagination_app/presentation/paging_bloc_screen.dart';
import 'package:pagination_app/presentation/posts_paging_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostPagingScreen(),
    );
  }
}
