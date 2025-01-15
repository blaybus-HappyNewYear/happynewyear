// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';  // DateFormat을 사용하기 위해 추가
//
// class AuthTotalXpdata {
//   Future<List<Map<String, String>>> fetchtotalxpData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final accessToken = prefs.getString('accessToken');
//
//     if (accessToken == null) {
//       print('Access token is missing');
//       return [];
//     }
//
//     final response = await http.post(
//       Uri.parse('http://52.78.9.87:8080/main/all-exp'),
//       headers: {
//         'Authorization': 'Bearer $accessToken',  // Bearer 토큰으로 인증
//       },
//     );
//
//     if (response.statusCode == 200) {
//       String decodedResponseBody = utf8.decode(response.bodyBytes);
//       var jsonResponse = jsonDecode(decodedResponseBody);
//
//       // 서버에서 받은 데이터 구조 출력 확인
//       print("JSON Response: $jsonResponse");
//
//         return;
//       } else {
//         print('Error: JSON response is not a List');
//         return [];
//       }
//     } else {
//       print('Error: ${response.statusCode}');
//       return [];
//     }
//   }