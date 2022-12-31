import 'package:flutter/material.dart';
import 'package:gallery_app_with_api/screens/album_screen.dart';
import 'package:gallery_app_with_api/screens/albums_screen.dart';
import 'package:gallery_app_with_api/screens/image_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/" : (context) => Albums(),
        "/album" : (context) => Album(),
        "/album/image" : (context) => ImageViewer(),
        // "/" : (context) => Test(),
      },
    );
  }
}
