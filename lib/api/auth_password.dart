import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthPassword {
  final String baseUrl = 'http://52.78.9.87:8080'; // 서버 주소

  Future<bool> changePassword(String oldPassword, String newPassword,
      String accessToken) async {
    try {
      // SharedPreferences에서 accessToken 가져오기
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      // accessToken이 null이면 오류 처리
      if (accessToken == null) {
        print('AccessToken is null');
        return false;
      }

      final Authorization = 'Bearer $accessToken';

      final response = await http.post(
        Uri.parse('$baseUrl/mypage/password'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': Authorization,
          // Authorization 헤더에 Bearer accessToken 포함
        },
        body: jsonEncode({
          'oldPassword': oldPassword, // 기존 비밀번호
          'newPassword': newPassword, // 새 비밀번호
        }),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseBody = utf8.decode(response.bodyBytes);

      // Check if the response status is 200 (success)
      if (response.statusCode == 200) {
        // You don't need to decode the body as JSON if it's just a plain string
        print("Response message: $responseBody");

        // If the response is a success message, you can assume the password change was successful
        return true; // Password change was successful
      } else {
        // Handle the case where the server didn't return a success status
        print('Error: $responseBody');
        print('Error: ${response.statusCode}');
        return false; // Password change failed
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
