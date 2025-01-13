import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthLogin {
  final String baseUrl = 'http://52.78.9.87:8080'; // 서버 주소

  // 로그인 메소드
  Future<Map<String, String>?> signIn(String username, String password) async {
    try {
      // POST 요청
      final response = await http.post(
        Uri.parse('$baseUrl/sign-in'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      // 응답 본문 처리
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);

      // 요청 성공시
      if (response.statusCode == 200) {
        // 응답에서 필요한 데이터 추출
        String grantType = data['grantType'];
        String accessToken = data['accessToken'];
        String refreshToken = data['refreshToken'];

        return {
          'grantType': grantType,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        print('Error: ${data['message']}');
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
