import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';

class MainScreen extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Container(
              alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10.0),
              child: Text.rich(
                TextSpan(
                  text: '두손꼭',
                  style: TextStyle(
                    fontFamily: 'RixInooAriDuri',
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Do',
                      style: TextStyle(
                        color: Color(0xFFF95E39),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '전!',
                      style: TextStyle(
                        fontFamily: 'RixInooAriDuri',
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(top: 10.0),
              icon: Image.asset("assets/icons/alarm_default.png"),
              onPressed: () {
                print("Icon pressed");
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2.0), // 보더의 높이를 설정
            child: Container(
              color: Color(0xFFEAEAEA), // 보더 색상
              height: 1.0, // 보더 두께
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: Center(
        child: Text(
          "Main Screen",
          style: TextStyle(fontSize: 24),
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
      BottomNavigation(selectedIndex: 0),
    );
  }
}
