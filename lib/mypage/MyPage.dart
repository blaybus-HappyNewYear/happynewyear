import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';
import '/mypage/ProfilePic.dart';
import '/api/auth_mypage.dart';  // auth_mypage.dart 파일을 import 합니다.

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  UserInfo? userInfo; // null로 초기화하여, 데이터가 로드되기 전까지 null 상태로 유지합니다.
  bool isLoading = true; // 데이터 로딩 상태를 추적합니다.

  // 사용자 정보를 API에서 가져오는 함수 호출
  Future<void> getUserData() async {
    UserInfo? fetchedUserInfo = await fetchUserData();
    setState(() {
      userInfo = fetchedUserInfo; // 데이터를 가져오면 userInfo에 할당
      isLoading = false; // 로딩이 끝났음을 알립니다.
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "내 정보",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Color(0xFFEAEAEA),
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중이면 로딩 인디케이터 표시
          : Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 28),
          child: Column(
            children: [
              ProfilePic(), // null 안전 연산자 사용
              SizedBox(height: 12),
              // 사용자 이름과 레벨 표시
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userInfo?.name ?? "이름 없음", // null 안전 연산자 사용
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    userInfo?.level ?? "레벨 없음", // null 안전 연산자 사용
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF565656),
                    ),
                  ),
                ],
              ),
              Container(
                height: 28,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFF6F6F6),
              ),
              SizedBox(height: 28),
              Column(
                children: [
                  _buildInfoField("입사일", userInfo?.startDate ?? "정보 없음"),
                  _buildInfoField("사번", userInfo?.empId ?? "정보 없음"),
                  _buildInfoField("소속", userInfo?.team ?? "정보 없음"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/passwordchangepage');
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "비밀번호 변경",
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Color(0xFF8A8A8A),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "로그아웃",
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8A8A8A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 4),
    );
  }

  // 개인 정보를 표시하는 텍스트 필드 위젯
  Widget _buildInfoField(String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF565656),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Color(0xFFEAEAEA),
                width: 1.0,
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF8A8A8A),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
