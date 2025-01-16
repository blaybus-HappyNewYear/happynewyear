import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> fetchTeamName() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is missing');
      return null;
    }

    final response = await http.get(
      Uri.parse('http://52.78.9.87:8080/calendar/team'),
      headers: {
        'Authorization': 'Bearer $accessToken', // Bearer 토큰으로 인증
      },
    );

    if (response.statusCode == 200) {
      final decodedResponseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponseBody);

      String teamName = data['teamName'];

      print("Team Name fetched successfully: $teamName");
      return teamName.toString();
    } else if (response.statusCode == 404) {
      print("Team Name not found.");
      return null;
    } else {
      print('Failed to load team name: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching team name: $e');
    return null;
  }
}