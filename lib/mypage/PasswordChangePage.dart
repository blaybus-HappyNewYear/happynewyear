import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';

class PasswordChangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Stack(
              children: [
                // 왼쪽에 아이콘을 배치
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/mypage');
                    },
                  ),
                ),
                // 가운데 텍스트
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      "비밀번호 변경",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
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
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "PasswordChange Screen",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
