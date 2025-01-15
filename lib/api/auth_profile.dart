import 'package:http/http.dart' as http;
import 'dart:convert';
import '/api/auth_mypage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProfile {
  final String baseUrl = 'http://52.78.9.87:8080'; // 서버 주소

  Future<int?> getProfileFromServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      print('Access Token: $accessToken');

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
        final List<dynamic> data = jsonDecode(response.body);

        // UserInfo에서 받아온 imgNumber를 가져오기
        final userInfo = await fetchUserData();
        if (userInfo == null) {
          print('User info is null');
          return null;
        }

        final userImgNumber = userInfo.imgNumber;
        print('User imgNumber from mypage: $userImgNumber');

        // character-list에서 imgNumber와 일치하는 항목을 찾아 imgNumber를 반환
        for (var profile in data) {
          // imgNumber가 String인 경우 비교 시 동일한 타입으로 변환
          if (profile['imgNumber'].toString() == userImgNumber) {
            final imgNumber = profile['imgNumber'];
            if (imgNumber != null) {
              print('Profile image number from server: $imgNumber');
              return imgNumber; // 일치하는 프로필의 imgNumber 반환
            } else {
              print('imgNumber not found for this profile');
              return null;
            }
          }
        }

        print('No matching imgNumber found');
        return null;
      } else {
        print('Failed to retrieve character list. Status code: ${response.statusCode}');
        print('Error body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception while fetching profile: $e');
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