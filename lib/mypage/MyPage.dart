import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';
import '/mypage/ProfilePic.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title:Container(
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
          preferredSize: Size.fromHeight(2.0), // 보더의 높이를 설정
          child: Container(
            color: Color(0xFFEAEAEA), // 보더 색상
            height: 1.0, // 보더 두께
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top:28),
          child: Column(
            children: [
              ProfilePic(),
              SizedBox(height: 12),
              // Row로 텍스트 두 개 배치
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "김민수",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4), // 텍스트 사이 간격
                  Text(
                    "레벨 6",
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
                height:28,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                height:8,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFF6F6F6),
              ),
              SizedBox(height: 28),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10), // 여백 추가
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.only(left:20.0, right: 20.0),
                      child: Text(
                        "개인 정보",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // 입사일 텍스트와 필드
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left:20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "입사일",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF565656)
                          ),
                        ),
                        SizedBox(height: 8), // 텍스트와 텍스트 사이 간격
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFEAEAEA),
                                width: 1.0,
                              )
                          ),
                          child: Text(
                            "20250106",  // 예시 데이터
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF8A8A8A)),
                          ),
                        ),
                        SizedBox(height: 24), // 텍스트 필드 아래 간격
                      ],
                    ),
                  ),
                  // 사번 텍스트와 필드
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left:20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "사번",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF565656)
                          ),
                        ),
                        SizedBox(height: 8), // 텍스트와 텍스트 사이 간격
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFEAEAEA),
                                width: 1.0,
                              )
                          ),
                          child: Text(
                            "202010520",  // 예시 데이터
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF8A8A8A)),
                          ),
                        ),
                        SizedBox(height: 24), // 텍스트 필드 아래 간격
                      ],
                    ),
                  ),
                  // 소속 텍스트와 필드
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left:20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "소속",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF565656)
                          ),
                        ),
                        SizedBox(height: 8), // 텍스트와 텍스트 사이 간격
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFEAEAEA),
                                width: 1.0,
                              )
                          ),
                          child: Text(
                            "음성 1센터",  // 예시 데이터
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF8A8A8A)),
                          ),
                        ),
                        SizedBox(height: 24), // 텍스트 필드 아래 간격
                      ],
                    ),
                  ),
                  Container(
                    height:8,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xFFF6F6F6),
                  ),
                  GestureDetector(
                    onTap: () {
                      // '/passwordchangepage' 경로로 이동
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
                  Container(
                    height:8,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xFFF6F6F6),
                  ),
                  GestureDetector(
                    onTap: () {
                      // '/passwordchangepage' 경로로 이동
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
                                      color: Color(0xFF8A8A8A)
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
}