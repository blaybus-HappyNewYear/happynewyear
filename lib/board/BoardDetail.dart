import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BoardDetail extends StatefulWidget {
  final String postId; // 게시글 id를 받아오는 변수

  BoardDetail(this.postId); // 생성자에서 id를 받음

  @override
  _BoardDetailState createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  bool isLoading = true;
  Map<String, dynamic> post = {}; // 기본값으로 빈 맵 할당

  @override
  void initState() {
    super.initState();
    _loadPostDetail();
  }
  // 게시글 상세 정보를 가져오는 함수 (API를 호출)
  Future<void> _loadPostDetail() async {
    try {
      final response = await http.post(
        Uri.parse('http://52.78.9.87:8080/board/${widget.postId}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          post = jsonDecode(utf8.decode(response.bodyBytes));  // API 응답 데이터 처리
          isLoading = false;  // 로딩 종료
        });
      } else {
        setState(() {
          isLoading = false;  // 실패 시 로딩 종료
        });
        print("게시글을 가져오는 데 실패했습니다.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;  // 예외 발생 시 로딩 종료
      });
      print("오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
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
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    "게시판",
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
          preferredSize: Size.fromHeight(2.0), // 보더의 높이를 설정
          child: Container(
            color: Color(0xFFEAEAEA), // 보더 색상
            height: 2.0, // 보더 두께
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : post.isEmpty
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
          : SingleChildScrollView(  // SingleChildScrollView로 전체 콘텐츠 감싸기
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
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
                        post['author'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        post['createdAt'],
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
            Divider(
              thickness: 1.0,
              color: Colors.grey.shade300,
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0),
              child: Text(
                post['content'],
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6, // 줄 간격 추가
                  fontFamily: 'Pretendard',
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
