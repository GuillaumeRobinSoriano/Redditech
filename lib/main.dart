import 'package:flutter/material.dart';
import 'package:redditech/auth/authentification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Redditech',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: MyLoginPage());
  }
}
