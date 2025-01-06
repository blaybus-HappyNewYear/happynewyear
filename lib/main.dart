import 'package:flutter/material.dart';
import 'login/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "두손꼭Do전!",
      home: Login(),
    );
  }
}