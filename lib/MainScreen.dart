import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';
import 'notice/NoticeScreen.dart';
import 'package:speech_balloon/speech_balloon.dart';
import '/api/auth_mypage.dart';
import '/mypage/ProfilePic.dart';
import '/api/auth_xprecentdata.dart';
import '/api/auth_currentxp.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserInfo? userInfo;
  bool _isLoading = true;
  List<Map<String, String>> xpData = [];
  int? currentExp;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    _loadUserData();
    _loadXpData();
    _loadCurrentExp();
  }

  void _initializeFirebaseMessaging() async {
    // Initialize Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Create a notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Set the foreground notification options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print("Firebase Token: $token");
    if (token != null) {
      _registerDeviceToken(token);
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  Future<void> _registerDeviceToken(String token) async {
    final url = Uri.parse('https://232b-118-39-93-133.ngrok-free.app');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: '{"token": "$token"}',
      );

      if (response.statusCode == 200) {
        print("Token successfully registered with backend");
      } else {
        print("Failed to register token: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending token to backend: $e");
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Background message: ${message.notification?.body}");
  }

  Future<void> _loadXpData() async {
    AuthRecentXpdata authXpdata = AuthRecentXpdata();
    List<Map<String, String>> fetchedData = await authXpdata.fetchxpData();
    setState(() {
      xpData = fetchedData;
      _isLoading = false;
    });
  }

  Future<void> _loadCurrentExp() async {
    AuthCurrentxp authCurrentxp = AuthCurrentxp();
    int? fetchedExp = await authCurrentxp.fetchCurrentxpData();
    setState(() {
      currentExp = fetchedExp;
      _isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    UserInfo? fetchedData = await fetchUserData();
    setState(() {
      userInfo = fetchedData;
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9F9),
      appBar: _buildAppBar(context),
      body: Container(
        padding: EdgeInsets.all(0),
        color: Color(0xFFFFF9F9),
        child: Column(
          children: [
            // 경험치 관련 텍스트
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 135.0, right: 135.0),
              child: Text(
                "올해 획득한 경험치",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF565656),
                ),
              ),
            ),
            SizedBox(height: 8),
            _buildSpeechBalloon(),
            _isLoading
                ? SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0C8CE9),
                ),
              ),
            )
                : Container(
              width: 120,
              height: 120,
              child: userInfo != null
                  ? Image.asset(profileImages[int.parse(userInfo!.imgNumber)])
                  : Container(
                color: Colors.grey, // 이미지가 없을 경우 기본 색상
              ),
            ),
            Expanded(
              child: DynamicTextContainer(dataList: xpData,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 0),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        scrolledUnderElevation: 0,
        title: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10.0),
          child: Text.rich(
            TextSpan(
              text: '두손꼭',
              style: TextStyle(
                fontFamily: 'RixInooAriDuri',
                fontSize: 22,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Do',
                  style: TextStyle(
                    color: Color(0xFFF95E39),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '전!',
                  style: TextStyle(
                    fontFamily: 'RixInooAriDuri',
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(top: 10.0, right: 10.0),
            icon: Image.asset("assets/icons/alarm_default.png"),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/noticepage');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFFEAEAEA),
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로가기 화살표 제거
      ),
    );
  }

  Widget _buildSpeechBalloon() {
    return SpeechBalloon(
      nipLocation: NipLocation.bottom,
      borderColor: Color(0xFFFA603B),
      height: 60,
      width: 204,
      borderRadius: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentExp != null
                ? NumberFormat('#,###').format(currentExp)
                : '로딩 중...',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'do',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicTextContainer extends StatelessWidget {
  final List<Map<String, String>> dataList;

  DynamicTextContainer({required this.dataList});

  @override
  Widget build(BuildContext context) {

    List<Map<String, String>> limitedDataList = dataList.take(5).toList();  // 5개 항목만 선택

    return Column(
      children: limitedDataList.asMap().entries.map((entry) {
        int index = entry.key;
        var data = entry.value;

        String questName = data['questName'] ?? '';
        String questValue = data['questValue'] ?? '';
        String questDate = data['questDate'] ?? '';

        // 홀수/짝수 스타일 정의
        TextStyle questNameStyle = (index % 2 == 0)
            ? TextStyle(fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, color: Colors.white)
            : TextStyle(fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, color: Color(0xFF565656));

        TextStyle questValueStyle = (index % 2 == 0)
            ? TextStyle(fontSize: 24, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, color: Color(0xFFFFF6DF))
            : TextStyle(fontSize: 24, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, color: Color(0xFFFF5329));

        TextStyle questDateStyle = (index % 2 == 0)
            ? TextStyle(fontSize: 12, color: Color(0xFFF6F6F6))
            : TextStyle(fontSize: 12, color: Color(0xFF565656));

        Color containerColor = (index % 2 == 0) ? Color(0xFFFA603B) : Color(0xFFFFC5B8);
        Border containerBorder = (index % 2 == 0)
            ? Border.all(color: Color(0xFFFA603B), width: 1)
            : Border.all(color: Color(0xFFFFC5B8), width: 1);

        return Transform.translate(
          offset: (index % 2 == 0) ? Offset(10, 0) : Offset(-10, 0),
          child: GestureDetector(
            onTap: () {
              AuthRecentXpdata().fetchxpData();  // AuthXpdata의 fetchxpData 메서드 호출
          Navigator.pushNamed(context, '/totalxppage');
        },
            child: Container(
              width: 338,
              height: 68,
              margin: EdgeInsets.symmetric(vertical: 4.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(8),
                border: containerBorder,
              ),
              child: Stack(
                children: [
                  // 왼쪽 상단 텍스트들 (퀘스트 이름 + 값 데이터 + "do" 단위)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // questName 텍스트가 너무 길 경우 "..."으로 표시
                      Flexible(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            questName,
                            style: questNameStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '+ ${NumberFormat('#,###').format(int.tryParse(questValue))}',
                          style: questValueStyle,
                        ),
                      ),
                      SizedBox(width: 4),

                      // "do" 단위 텍스트
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'do',
                          style: questValueStyle.copyWith(fontSize: questValueStyle.fontSize! - 2),
                        ),
                      ),
                    ],
                  ),
                  // 오른쪽 하단 텍스트 (날짜 데이터)
                  Positioned(
                    bottom: 2,
                    right: 0,
                    child: Text(
                      questDate,
                      style: questDateStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}