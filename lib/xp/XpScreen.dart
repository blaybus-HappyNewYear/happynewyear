import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';

class XpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          title:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "경험치",
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
      ),
      body: Center(
        child: Text(
          "Xp Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
    );
  }
}
