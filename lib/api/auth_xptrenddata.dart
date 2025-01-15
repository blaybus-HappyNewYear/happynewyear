import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class XpTrendInfo {
  final List<int> years;
  final List<double> values;

  XpTrendInfo({required this.years, required this.values});

  factory XpTrendInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> expData = json['expData'] ?? {};

    // expData를 'year' 기준으로 정렬
    var sortedEntries = expData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));  // 연도순으로 정렬

    // 정렬된 엔트리에서 연도와 값을 각각 List로 변환
    List<int> years = sortedEntries.map((entry) => int.parse(entry.key)).toList();
    List<double> values = sortedEntries.map((entry) {
      // 모든 값을 double로 변환
      return entry.value is int ? entry.value.toDouble() : entry.value.toDouble();
    }).toList().cast<double>();  // List<double>로 강제 캐스팅

    return XpTrendInfo(years: years, values: values);
  }
}

class AuthXpTrendData {
  // XP 데이터를 가져오는 메서드
  Future<XpTrendInfo?> fetchXpTrendData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token is missing');
        return null;
      }

      final response = await http.get(
        Uri.parse('http://52.78.9.87:8080/trend'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);
        return XpTrendInfo.fromJson(
            data); // Use the factory to convert the JSON
      } else {
        // Handle non-200 responses
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Handle any network or parsing errors
      print('Error fetching XP trend data: $error');
      return null;
    }
  }
}