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
        });
      } else {
        print("게시글 목록 조회 실패: ${response.statusCode}");
        print("응답 본문: ${response.body}");
      }
    } catch (e) {
      print("오류 발생: $e");
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
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
      body: ListView.builder(
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
<<<<<<< HEAD
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          post = {
            'id': data['id'] ?? 0,
            'title': data['title'] ?? '제목 없음',
            'author': data['author'] ?? '작성자 없음',
            'createdAt': data['createdAt'] ?? '날짜 없음',
            'content': data['content'] ?? '내용이 없습니다.',
          };
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load post details');
      }
    } catch (e) {
      print("Error fetching post details: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글을 불러오지 못했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.only(top: 5.0),
          icon: Image.asset(
            'assets/icons/back.png',
          ),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
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
          preferredSize: Size.fromHeight(2.0), // 보더의 높이를 설정
          child: Container(
            color: Color(0xFFEAEAEA), // 보더 색상
            height: 2.0, // 보더 두께
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : post == null
          ? Center(
        child: Text(
          '게시글 정보를 불러올 수 없습니다.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Pretendard',
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목, 작성자, 날짜 영역
          Container(
            color: Colors.white, // 배경색 흰색 유지
            child: Padding(
              padding: const EdgeInsets.all(25.0), // 텍스트에 패딩 추가
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post!['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${post!['author']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${post!['createdAt']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.shade300,
            height: 1.0,
          ),
          // 본문 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post!['content'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6, // 줄 간격 추가
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),

                    Text(
                      "목록 스크롤 확인을 위한 텍스트",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6, // 줄 간격 추가
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Phasellus lacinia velit a feugiat placerat. Nulla facilisi.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Curabitur eget eros vitae magna vehicula sodales non vel purus.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Praesent nec justo euismod, viverra metus at, facilisis augue.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Fusce feugiat dolor ac libero interdum, sit amet lacinia nisl tristique.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Donec dictum lectus a ipsum lacinia, ac dictum metus volutpat.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Etiam quis sapien id risus convallis feugiat ut at velit.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Pellentesque id orci in sapien pretium convallis.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Nunc vulputate augue et justo tempus, ut vehicula nisl mollis.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sed tristique tortor in libero fermentum, sit amet accumsan odio efficitur.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
=======
>>>>>>> b75651cb0fc850b6b892d6418fbdde080b147212
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
    );
  }
}
