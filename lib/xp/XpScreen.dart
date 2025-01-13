import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';

class XpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "경험치 현황",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Container(
            width: 390,
            height: 307,
            child: Center(
              child: Text(
                "트렌드",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
    );
  }
}