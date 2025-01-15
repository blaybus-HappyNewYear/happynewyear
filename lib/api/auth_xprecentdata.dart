import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';  // DateFormat을 사용하기 위해 추가

class AuthRecentXpdata {
  Future<List<Map<String, String>>> fetchxpData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is missing');
      return [];
    }

    final response = await http.get(
      Uri.parse('http://52.78.9.87:8080/main/recent-exp'),
      headers: {
        'Authorization': 'Bearer $accessToken',  // Bearer 토큰으로 인증
      },
    );

    if (response.statusCode == 200) {
      String decodedResponseBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(decodedResponseBody);

      // 서버에서 받은 데이터 구조 출력 확인
      print("JSON Response: $jsonResponse");

      // 데이터가 List로 반환되는지 확인
      if (jsonResponse is List) {
        List<Map<String, String>> dataList = [];
        DateFormat dateFormat = DateFormat('yy/MM/dd');  // 날짜 포맷 지정

        // 각 항목을 순회하면서 데이터를 변환
        for (var item in jsonResponse) {
          // 타입을 명확히 지정하고, 데이터가 올바르게 처리되도록 체크
          if (item is Map<String, dynamic>) {
            // earnedDate를 DateTime 객체로 변환하고 포맷팅
            DateTime earnedDate = DateTime.parse(item['earnedDate']);
            String formattedDate = dateFormat.format(earnedDate);  // 포맷된 날짜

            // 데이터를 데이터 리스트에 추가
            dataList.add({
              'questName': item['type'],  // type은 그대로 String
              'questValue': item['exp'].toString(),  // exp는 숫자형이므로 String으로 변환
              'questDate': formattedDate,  // earnedDate를 포맷팅한 String
            });
          }
        }

        return dataList;
      } else {
        print('Error: JSON response is not a List');
        return [];
      }
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  }
}
