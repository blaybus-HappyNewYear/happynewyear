import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // 데이터를 초기화할 때 로드
  }

  Future<void> fetchNotifications() async {
    final url = Uri.parse('http://52.78.9.87:8080/notification');
    final token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5zdWtpbSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY5NDg0Njd9.g1V8THPXqDOMdEGeZg3-maqNU4CMpEc7J3fumyMRiK4';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 데이터가 비어 있는 경우 처리
        if (data == null || (data is List && data.isEmpty)) {
          print("No notifications available.");
          setState(() {
            notifications = []; // 빈 배열로 초기화
          });
          return;
        }

        setState(() {
          notifications = data; // 데이터가 있을 경우만 업데이트
        });
        print("Notification Data fetched successfully: $notifications");
      } else {
        print('Failed to load notification data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }


  List<Map<String, dynamic>> fetchMockNotifications() {
    return [
      {
        'id': 1,
        'type': '경험치',
        'content': "\"직무퀘스트\"를 완료하여 500do 경험치를 획득하였습니다.",
        'timestamp': '1월 9일',
        'isRead': false,
      },
      {
        'id': 2,
        'type': '경험치',
        'content': "인사평가 A등급입니다. 500do 경험치를 획득하였습니다.",
        'timestamp': '1월 1일',
        'isRead': true,
      },
      {
        'id': 3,
        'type': '경험치',
        'content': "월 특근을 3회 완료하여 500do 경험치를 획득하였습니다.",
        'timestamp': '12월 31일',
        'isRead': false,
      },
      {
        'id': 4,
        'type': '게시판',
        'content': "AAA 프로젝트 신설 라는 새로운 게시글이 등록되었어요.",
        'timestamp': '12월 31일',
        'isRead': false,
      },
      {
        'id': 5,
        'type': '게시판',
        'content': "AAA 프로젝트 신설 라는 새로운 게시글이 등록되었어요.",
        'timestamp': '12월 31일',
        'isRead': false,
      },
      {
        'id': 6,
        'type': '게시판',
        'content': "AAA 프로젝트 신설 라는 새로운 게시글이 등록되었어요.",
        'timestamp': '12월 31일',
        'isRead': true,
      },
      {
        'id': 7,
        'type': '게시판',
        'content': "AAA 프로젝트 신설 라는 새로운 게시글이 등록되었어요.",
        'timestamp': '12월 31일',
        'isRead': true,
      },
      {
        'id': 8,
        'type': '게시판',
        'content': "AAA 프로젝트 신설 라는 새로운 게시글이 등록되었어요.",
        'timestamp': '12월 31일',
        'isRead': false,
      },

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10.0),
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/mainpage');
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    "알림",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Color(0xFFEAEAEA),
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // 배경색을 흰색으로 설정
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : notifications.isEmpty
            ? Center(
          child: Text(
            '알림이 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Pretendard',
            ),
          ),
        )
            : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isRead = notification['isRead'] ?? false; // 읽음 여부 확인
            return GestureDetector(
              onTap: () {
                setState(() {
                  notification['isRead'] = true; // 클릭 시 읽음 처리
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isRead ? Colors.white : Color(0xFFFBECE6),
                  // 읽지 않은 알림은 주황색
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['type'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          notification['timestamp'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification['content'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

      ),
    );
  }
}
