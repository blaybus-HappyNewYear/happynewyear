import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happynewyear/quest/QuestScreen.dart';
import 'login/LoginScreen.dart';
import 'mypage/MyPage.dart';
import 'board/BoardScreen.dart';
import 'MainScreen.dart';
import 'xp/XpScreen.dart';
import 'xp/TotalxpPage.dart';
import 'mypage/PasswordChangePage.dart';
import 'notice/NoticeScreen.dart';
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification?.body}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
    const AndroidNotificationChannel(
      'high_importance_channel',
      'high_importance_notification',
      importance: Importance.max,
    ),
  );

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ),
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await initializeNotification();

  // FCM 토큰 가져오기
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: ${fcmToken ?? "No token available"}");

  runApp(MyApp(fcmToken: fcmToken ?? ""));
}

class MyApp extends StatelessWidget {
  final String fcmToken;
  MyApp({required this.fcmToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "두손꼭Do전!",
      initialRoute: '/',
      routes: {
        '/': (context) => Login(fcmToken: fcmToken),
        '/mainpage': (context) => MainScreen(),
        '/questpage': (context) => QuestScreen(),
        '/xppage': (context) => XpScreen(),
        '/boardpage': (context) => BoardPage(),
        '/noticepage': (context) => NoticePage(),
        '/mypage': (context) => MyPage(),
        '/passwordchangepage': (context) => PasswordChangePage(),
        '/totalxppage': (context) => Totalxppage(),
      },
    );
  }
}

