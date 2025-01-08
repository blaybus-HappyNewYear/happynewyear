import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Text(
          "Main Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: Row( // 하단
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home_outlined),
            Icon(Icons.flag_circle),
            Icon(Icons.trending_up),
            Icon(Icons.dashboard),
            Icon(Icons.person),
          ]
      ),
    );
  }
}
