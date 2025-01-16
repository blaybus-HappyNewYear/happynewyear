import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyQuestItem {
  final String questName;
  final String comments;
  final String achievement;
  final int exp;

  WeeklyQuestItem({
    required this.questName,
    required this.comments,
    required this.achievement,
    required this.exp,
  });

  // Factory method to create WeeklyQuestItem from JSON
  factory WeeklyQuestItem.fromJson(Map<String, dynamic> json) {
    return WeeklyQuestItem(
      questName: json['questName'] as String,
      comments: json['comments'] as String,
      achievement: json['achievement'] as String,
      exp: json['exp'] as int,
    );
  }
}

class WeeklyCalendarItem {
  final int id;
  final int year;
  final int month;
  final int date;
  final String achievement;
  final int questCount;
  final List<WeeklyQuestItem> questList;

  WeeklyCalendarItem({
    required this.id,
    required this.year,
    required this.month,
    required this.date,
    required this.achievement,
    required this.questCount,
    required this.questList,
  });

  // Factory method to create WeeklyCalendarItem from JSON
  factory WeeklyCalendarItem.fromJson(Map<String, dynamic> json) {
    var questListFromJson = (json['questList'] as List)
        .map((item) => WeeklyQuestItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return WeeklyCalendarItem(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as int,
      date: json['date'] as int,
      achievement: json['achievement'] as String,
      questCount: json['questCount'] as int,
      questList: questListFromJson,
    );
  }
}
List<WeeklyCalendarItem> weeklyCalendarData = [];

Future<void> fetchWeeklyCalendarData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is missing');
      return;
    }

    final response = await http.get(
      Uri.parse('http://52.78.9.87:8080/calendar/weekly'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 서버에서 응답받은 JSON을 WeeklyCalendarItem 리스트로 변환
      final List<dynamic> jsonResponse = json.decode(response.body);
      weeklyCalendarData = jsonResponse
          .map((item) => WeeklyCalendarItem.fromJson(item as Map<String, dynamic>))
          .toList();

      print("Weekly Calendar Data fetched successfully");
    } else {
      print('Failed to load weekly data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching weekly data: $e');
  }
}