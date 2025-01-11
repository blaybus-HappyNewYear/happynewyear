import 'package:flutter/material.dart';
import 'package:happynewyear/quest/QuestScreen.dart';
import 'login/LoginScreen.dart';
import 'mypage/MyPage.dart';
import 'board/BoardScreen.dart';
import 'MainScreen.dart';
import 'xp/XpScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "두손꼭Do전!",
      // home: Login(),
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/mainpage' : (context) => MainScreen(),
          '/questpage' : (context) => QuestScreen(),
          '/xppage' : (context) => XpScreen(),
          '/boardpage' : (context) => BoardPage(),
        '/mypage': (context) => MyPage(),
        },
    );
  }
}