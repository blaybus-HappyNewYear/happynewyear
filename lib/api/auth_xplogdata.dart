import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class XplogItem {
  final String type;
  final int exp;
  final DateTime earnedDate;
  final String comments;

  XplogItem({
    required this.type,
    required this.exp,
    required this.earnedDate,
    required this.comments,
  });

  // factory 메서드를 이용해 JSON 데이터를 객체로 변환
  factory XplogItem.fromJson(Map<String, dynamic> json) {
    return XplogItem(
      type: json['type'] as String,
      exp: json['exp'] as int,
      earnedDate: DateTime.parse(json['earnedDate'] as String),
      comments: json['comments'] as String,
    );
  }
}

class AuthXplogdata {

Future<List<XplogItem>> FetchXplogCount() async {
  List<XplogItem> xplogItems = [];
  int page = 0;
  bool hasNext = true;

  try {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('AccessToken is null');
      return xplogItems;
    }

    final Authorization = 'Bearer $accessToken';

    while (hasNext) {
      final response = await http.post(
        Uri.parse('http://52.78.9.87:8080/main/all-exp'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': Authorization,
        },
        body: jsonEncode({'page': page}),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(responseBody);
        final expList = (responseJson['expList'] as List<dynamic>)
            .map((item) => XplogItem.fromJson(item as Map<String, dynamic>))
            .toList();

        xplogItems.addAll(expList);

        // 서버 응답에서 hasNext 값 확인
        hasNext = responseJson['hasNext'] ?? false;
        page++;
      } else {
        print('Error: $responseBody');
        hasNext = false; // 에러 발생 시 종료
      }
    }
    return xplogItems;
  } catch (e) {
    print('Exception: $e');
    return xplogItems;
  }
}

  // Xplog 항목들을 실제 데이터로 가져오는 메서드
Future<List<XplogItem>> FetchXplogData() async {
  List<XplogItem> xplogItems = [];
  int page = 0;

  try {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('AccessToken is null');
      return xplogItems;
    }

    final Authorization = 'Bearer $accessToken';

    while (true) {
      final response = await http.post(
        Uri.parse('http://52.78.9.87:8080/main/all-exp'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': Authorization,
        },
        body: jsonEncode({'page': page}),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(responseBody);
        final expList = (responseJson['expList'] as List<dynamic>)
            .map((item) => XplogItem.fromJson(item as Map<String, dynamic>))
            .toList();

        xplogItems.addAll(expList);

        final hasNext = responseJson['hasNext'] as bool;
        if (!hasNext) {
          break;
        } else {
          page++;
        }
      } else {
        print('Error: $responseBody');
        break;
      }
    }
    return xplogItems;
  } catch (e) {
    print('Exception: $e');
    return xplogItems;
  }
}
}