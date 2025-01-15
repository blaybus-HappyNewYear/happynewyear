import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Post {
  final int id;
  final String title;
  final String createdAt; // LocalDate로 사용
  final int views;

  Post({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      createdAt: json['createdAt'], // LocalDate 처리
      views: json['views'],
    );
  }
}

class BoardListResponse {
  final List<Post> posts;
  final int startPage;
  final int endPage;

  BoardListResponse({
    required this.posts,
    required this.startPage,
    required this.endPage,
  });

  factory BoardListResponse.fromJson(Map<String, dynamic> json) {
    var postList = json['posts'] as List<dynamic>;  // Cast the list as dynamic first
    List<Post> posts = postList.map((i) => Post.fromJson(i as Map<String, dynamic>)).toList();

    return BoardListResponse(
      posts: posts,
      startPage: json['startPage'],
      endPage: json['endPage'],
    );
  }
}

class AuthBoardlist {
  final String baseUrl = 'http://52.78.9.87:8080'; // 서버 주소

  // 게시물 목록을 가져오는 메소드
  Future<BoardListResponse?> getBoardListContent() async {
    int page = 0;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/board'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8로 응답 데이터 디코딩
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(responseBody);

        return BoardListResponse.fromJson(data);
      } else {
        print("API 호출 실패: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("게시글을 불러오는 중 오류가 발생했습니다: $error");
      return null;
    }
  }
}
