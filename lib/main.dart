import 'package:flutter/material.dart';
import 'package:happynewyear/quest/QuestScreen.dart';
import 'login/LoginScreen.dart';
import 'mypage/MyPage.dart';
import 'board/BoardScreen.dart';
import 'MainScreen.dart';
import 'xp/XpScreen.dart';
import 'xp/TotalxpPage.dart';
import 'mypage/PasswordChangePage.dart';
import 'notice/NoticeScreen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'services/PushNotificationService.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // // 알림 서비스 초기화
  // await Firebase.initializeApp();
  // PushNotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "두손꼭Do전!",
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/mainpage' : (context) => MainScreen(),
          '/questpage' : (context) => QuestScreen(),
          '/xppage' : (context) => XpScreen(),
          '/boardpage': (context) => BoardPage(),
          '/noticepage' : (context) => NoticePage(),
          '/mypage': (context) => MyPage(),
          '/passwordchangepage': (context) => PasswordChangePage(),
          '/totalxppage' : (context) => Totalxppage(),
        },
    );
  }
}