import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthCurrentxp {
  Future<int?> fetchCurrentxpData() async {
    try {
      // SharedPreferences에서 accessToken 가져오기
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      // accessToken이 null이면 오류 처리
      if (accessToken == null) {
        print('AccessToken is null');
        return null; // null 반환 (혹은 오류 처리할 수 있음)
      }

      final response = await http.get(
        Uri.parse('http://52.78.9.87:8080/main/curr-exp'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseBody = utf8.decode(response.bodyBytes);

      // Check if the response status is 200 (success)
      if (response.statusCode == 200) {
        // JSON을 디코딩하여 currExp 값을 가져오기
        final jsonData = jsonDecode(responseBody);
        final currentExp = jsonData['currExp'];

        // currExp 값을 반환
        return currentExp; // 성공적으로 받은 currExp 값 반환
      } else {
        // Handle the case where the server didn't return a success status
        print('Error: $responseBody');
        print('Error: ${response.statusCode}');
        return null; // 실패 시 null 반환
      }
    } catch (e) {
      print('Exception: $e');
      return null; // 예외 발생 시 null 반환
    }
  }
}