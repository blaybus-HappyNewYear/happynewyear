import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Bottom_Navigation.dart';
import '../services/PushNotificationService.dart';

class BoardPage extends StatefulWidget {
  final bool isAdmin; // 관리자 여부를 전달받음

  BoardPage({required this.isAdmin});

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<dynamic> posts = []; // 게시글 리스트
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool isLoading = true; // 로딩 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
    fetchPostList(); // 초기화 시 게시글 목록 조회
  }

  // 게시글 목록 조회 API
  Future<void> fetchPostList({int page = 1}) async {
    final String url = "http://52.78.9.87:8080/board?page=$page";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          posts = responseData['posts']; // 게시글 리스트 저장
          isLoading = false;
        });
      } else {
        print("게시글 목록 조회 실패: ${response.statusCode}");
        print("응답 본문: ${response.body}");
        setState(() {
          isLoading = false; // 에러가 발생해도 로딩을 끝내야 하므로
        });
      }
    } catch (e) {
      print("오류 발생: $e");
      setState(() {
        isLoading = false; // 오류가 발생하면 로딩을 끝내야 하므로
      });
    }
  }

  // 게시글 상세 조회 API
  Future<void> fetchPostDetail(int id) async {
    final String url = "http://52.78.9.87:8080/board/$id";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("게시글 상세: $responseData");
        // 상세 데이터를 다이얼로그 등으로 표시
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(responseData['title']),
            content: Text(responseData['content']),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("닫기"),
              ),
            ],
          ),
        );
      } else {
        print("게시글 상세 조회 실패: ${response.statusCode}");
        print("응답 본문: ${response.body}");
      }
    } catch (e) {
      print("오류 발생: $e");
    }
  }

  // 게시글 등록 API
  // Future<void> registerPost(String title, String content) async {
  //   final String url = "http://52.78.9.87:8080/board/write";
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"title": title, "content": content}),
  //     );
  //     if (response.statusCode == 200) {
  //       print("게시글 등록 성공");
  //       fetchPostList(); // 목록 갱신
  //       PushNotificationService.sendNotification(
  //         title: "새로운 게시글",
  //         body: "관리자가 새 게시글을 등록했습니다.",
  //       ); // 푸시 알림 전송
  //     } else {
  //       print("게시글 등록 실패");
  //     }
  //   } catch (e) {
  //     print("오류 발생: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "게시판",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Color(0xFFEAEAEA),
            height: 1.0,
          ),
        ),
        actions: [
          if (widget.isAdmin) // 관리자일 경우에만 버튼 표시
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("게시글 등록"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(labelText: "제목"),
                        ),
                        TextField(
                          controller: contentController,
                          decoration: InputDecoration(labelText: "내용"),
                          maxLines: 3,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("취소"),
                      ),
                      if (widget.isAdmin) // 관리자일 경우에만 등록 버튼 추가
                        TextButton(
                          onPressed: () {
                            final title = titleController.text;
                            final content = contentController.text;

                            // if (title.isNotEmpty && content.isNotEmpty) {
                            //   registerPost(title, content, "your_admin_token_here");
                            //   titleController.clear();
                            //   contentController.clear();
                            //   Navigator.of(context).pop();
                            // } else {
                            //   print("제목과 내용을 입력하세요.");
                            // }
                          },
                          child: Text("등록"),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시할 로딩 화면
          : Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post['title']),
              subtitle: Text("조회수: ${post['views']} / 작성일: ${post['createdAt']}"),
              onTap: () {
                fetchPostDetail(post['id']); // 상세 조회 호출
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
    );
  }
}