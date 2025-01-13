import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProfile {
  final String baseUrl = 'http://52.78.9.87:8080'; // 서버 주소

  // 서버에서 프로필 정보를 받아오는 함수
  // Future<int?> getProfileFromServer(int selectedProfileIndex) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final accessToken = prefs.getString('accessToken');
  //
  //     if (accessToken == null) {
  //       print('AccessToken is null');
  //       return null;
  //     }
  //
  //     // imgNumber를 쿼리 파라미터로 전달
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/mypage/character?imgNumber=$selectedProfileIndex'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=utf-8',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // 서버가 JSON이 아닌 텍스트를 반환하므로 response.body를 직접 사용
  //       print('Server Response: ${response.body}');
  //       final responseBody = response.body;  // 응답을 그대로 문자열로 받아옵니다.
  //
  //       // 응답을 텍스트로 확인
  //       if (responseBody.contains('캐릭터가 성공적으로 변경되었습니다')) {
  //         print('Profile updated successfully on server');
  //         return selectedProfileIndex; // 성공적인 업데이트 후, imgNumber를 반환
  //       } else {
  //         print('Unexpected response: $responseBody');
  //         return null;
  //       }
  //     } else {
  //       print('Failed to retrieve profile: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //     return null;
  //   }
  // }

  // Future<Map<String, dynamic>?> getProfileFromServer(num imgNumber, String accessToken) async {
  //   try {
  //     print('AccessToken: $accessToken'); // 디버깅 출력
  //     print('Requesting server with imgNumber: $imgNumber'); // 요청 내용 출력
  //
  //     // 서버에 POST 요청 보내기
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/mypage/character'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=utf-8',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //       body: jsonEncode({'imgNumber': imgNumber}),
  //     );
  //
  //     // 응답 처리
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('Server Response: $data');
  //
  //       if (data != null) {
  //         return data;
  //       } else {
  //         print('No data received from server');
  //         return null;
  //       }
  //     } else {
  //       print('Failed to retrieve profile: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //     return null;
  //   }
  // }

  Future<int?> getProfileFromServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('AccessToken is null');
        return null;
      }

      // 서버 요청
      final response = await http.get(
        Uri.parse('$baseUrl/character-list'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // JSON 파싱
        final data = jsonDecode(response.body);

        if (data['imgNumber'] != null) {
          print('Profile image number from server: ${data['imgNumber']}');
          return data['imgNumber'];
        } else {
          print('imgNumber not found in response');
          return null;
        }
      } else {
        print('Failed to retrieve profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // 프로필을 서버에 업데이트하는 함수
  Future<bool> updateProfileOnServer(int selectedProfileIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('AccessToken is null');
        return false;
      }

      // imgNumber를 쿼리 파라미터로 전달
      final response = await http.post(
        Uri.parse('$baseUrl/mypage/character?imgNumber=$selectedProfileIndex'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Request to update profile sent with imgNumber: $selectedProfileIndex');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // 서버가 정상적으로 응답을 반환했을 경우
        print('Server response: ${response.body}');
        return true;
      } else {
        // 실패한 경우
        print('Failed to update profile on server: ${response.statusCode}');
        print('Error response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception while updating profile on server: $e');
      return false;
    }
  }
}