import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  final String name;
  final String level;
  final String imgNumber; // 이 부분을 String으로 처리
  final String startDate;
  final String empId;
  final String team;

  UserInfo({
    required this.name,
    required this.level,
    required this.imgNumber,
    required this.startDate,
    required this.empId,
    required this.team,
  });

  // 서버로부터 받은 데이터를 적절하게 변환하는 팩토리 메서드
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? '이름 없음',
      level: json['level']?.toString() ?? '레벨 없음', // level은 String으로 처리
      imgNumber: json['imgNumber']?.toString() ?? '', // imgNumber를 String으로 변환
      startDate: json['startDate'] ?? '정보 없음',
      empId: json['id']?.toString() ?? '정보 없음', // id는 String으로 변환
      team: json['team'] ?? '정보 없음',
    );
  }
}

Future<UserInfo?> fetchUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is missing');
      return null;
    }

    final response = await http.get(
      Uri.parse('http://52.78.9.87:8080/mypage'),
      headers: {
        'Authorization': 'Bearer $accessToken', // Bearer 토큰으로 인증
      },
    );

    if (response.statusCode == 200) {
      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes); // bodyBytes로 디코딩 처리
      final Map<String, dynamic> data = jsonDecode(decodedBody);

      print('Response body: ${response.body}');
      print('Name: ${data['name']}');
      print('Level: ${data['level']}');
      print('ImageNumber: ${data['imgNumber']}');
      print('Start Date: ${data['startDate']}');
      print('EmpId: ${data['id']}');
      print('Team: ${data['team']}');

      // UserInfo.fromJson을 사용하여 데이터를 변환
      final userInfo = UserInfo.fromJson(data);

      return userInfo;
    } else {
      print('Failed to fetch user data. Status code: ${response.statusCode}');
      print('Error body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception while fetching user data: $e');
    return null;
  }
}
