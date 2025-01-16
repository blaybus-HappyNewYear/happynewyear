import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>?> fetchLeaderQuest() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is missing');
      return null;
    }

    final response = await http.get(
      Uri.parse('http://52.78.9.87:8080/calendar/quest-type'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final decodedResponseBody = utf8.decode(response.bodyBytes);

    print("Raw Response: $decodedResponseBody");

    if (response.statusCode == 200) {
      final decodedResponseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponseBody);

      List<dynamic> leaderQuestList = data;

      print("Leader Quest fetched successfully: $leaderQuestList");
      return leaderQuestList;
    } else if (response.statusCode == 404) {
      print("Leader Quest not found.");
      return null;
    } else {
      print('Failed to load leader quest: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching leader quest: $e');
    return null;
  }
}