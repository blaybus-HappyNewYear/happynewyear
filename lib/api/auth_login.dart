import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthLogin {
  final String baseUrl = 'https://da5e-118-39-93-133.ngrok-free.app'; // 서버 주소

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

  Future<bool> sendFcmToken(String fcmToken, String accessToken) async {
    final url = Uri.parse('$baseUrl/fcm-token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Bearer 토큰 인증
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        print('성공');
        return true; // 성공
      } else {
        print("Failed to send FCM token: ${response.statusCode}");
        return false; // 실패
      }
    } catch (e) {
      print("Error sending FCM token: $e");
      return false;
    }
  }
}
