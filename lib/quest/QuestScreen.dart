import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';

class QuestScreen extends StatelessWidget {
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
              "퀘스트",
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "Quest Screen",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      bottomNavigationBar:
      // Theme(
      //     data: ThemeData(
      //     splashColor: Colors.transparent,
      //     // highlightColor: Colors.transparent,
      //   ),
      //   child: BottomNavigationBar(
      //     items: items, // 위에서 정의한 items 리스트를 전달
      //     currentIndex: _selectedIndex, // 선택된 인덱스 표시
      //     onTap: _onItemTapped, // 탭 시 호출될 함수
      //     type: BottomNavigationBarType.fixed,
      //   ),
      // ),
      BottomNavigation(selectedIndex : 1),
    );
  }
}
