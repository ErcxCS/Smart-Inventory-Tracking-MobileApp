import 'package:flutter/material.dart';
import 'package:shoprlist/stateFulAlbum.dart';
import 'WordList.dart';
import 'stateFulAlbum.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ShopingList(),
    );
  }
}


