import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Text(
          "Main Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
