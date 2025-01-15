import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class XpInfo {
  final int id;
  final int accumExp;
  final int currExp;
  final int necessaryExp;
  final int presentPercent;
  final int currentPercent;
  final int currlimit;

  XpInfo({
    required this.id,
    required this.accumExp,
    required this.currExp,
    required this.necessaryExp,
    required this.presentPercent,
    required this.currentPercent,
    required this.currlimit
  });

  // JSON 데이터를 XpInfo 객체로 변환하는 팩토리 메서드
  factory XpInfo.fromJson(Map<String, dynamic> json) {
    return XpInfo(
      id: json['id'] ?? 0,
      accumExp: json['accumExp'] ?? 0,
      currExp: json['currExp'] ?? 0,
      necessaryExp: json['necessaryExp'] ?? 0,
      presentPercent: json['presentPercent'] ?? 0,
      currentPercent: json['currentPercent'] ?? 0,
      currlimit: json['currlimit'] ?? 0,
    );
  }
}

class AuthXpAllData {
  // XP 데이터를 가져오는 메서드
  Future<XpInfo?> fetchXpData() async {
    try {
      // SharedPreferences에서 accessToken 가져오기
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token is missing');
        return null;
      }

      final response = await http.get(
        Uri.parse('http://52.78.9.87:8080/get-exp'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(decodedBody);

        // 로그 출력 (디버깅 용도)
        print('Response body: $decodedBody');

        // JSON 데이터를 XpInfo 객체로 변환하여 반환
        return XpInfo.fromJson(data);
      } else {
        print('Failed to fetch XP data. Status code: ${response.statusCode}');
        print('Error body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception while fetching XP data: $e');
      return null;
    }
  }
}
