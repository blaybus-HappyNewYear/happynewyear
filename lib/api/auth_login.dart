import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthLogin {
  final String baseUrl = 'http://52.78.9.87:8080'; // 서버 주소

  Future<String?> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sign-in'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return data['accessToken'];
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