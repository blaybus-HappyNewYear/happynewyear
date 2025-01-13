import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';
import 'notice/NoticeScreen.dart';
import 'package:speech_balloon/speech_balloon.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9F9),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoticePage(),
                  ),
                );
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(0), // padding을 없애면 컨테이너가 전체 화면을 채움
          color: Color(0xFFFFF9F9),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 38.0, left: 135.0, right: 135.0),
                child: Text(
                  "올해 획득한 경험치",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF565656),
                  ),
                ),
              ),
              SizedBox(height: 8), // 텍스트와 말풍선 사이 간격
              SpeechBalloon(
                nipLocation: NipLocation.bottom,  // 말풍선의 꼬리 위치
                borderColor: Color(0xFFFA603B),         // 테두리 색상
                height: 60,                        // 말풍선 높이
                width: 204,                        // 말풍선 너비
                borderRadius: 8,                  // 말풍선 둥근 모서리
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('경험치 수',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Color(0xFFF95E39)
                    ),),
                    SizedBox(width: 8),
                    Text(
                      'do',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Container(width: 120,
              height: 120,
                child: Image.asset('assets/images/woman-01.png'),
              ),
              SizedBox(height: 16,),
              DynamicTextContainer(
                dataList: [{
                  'questName': '직무퀘스트',
                  'questValue': '100',
                  'questDate': '24/01/05',
                },
                {
                  'questName': '직무퀘스트',
                  'questValue': '500',
                  'questDate': '24/01/05',
                },
                {
                  'questName': '직무퀘스트',
                  'questValue': '500',
                  'questDate': '24/01/05',
                },
                {
                  'questName': '직무퀘스트',
                  'questValue': '500',
                  'questDate': '24/01/05',
                },
                  {
                    'questName': '직무퀘스트',
                    'questValue': '500',
                    'questDate': '24/01/05',
                  },
                ],
              ),
            ],
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
      BottomNavigation(selectedIndex: 0),
    );
  }
}

class DynamicTextContainer extends StatelessWidget {
  final List<Map<String, String>> dataList;

  DynamicTextContainer({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dataList.asMap().entries.map((entry) {
        int index = entry.key;
        var data = entry.value;

        String questName = data['questName'] ?? '';
        String questValue = data['questValue'] ?? '';
        String questDate = data['questDate'] ?? '';

        // 홀수/짝수 스타일 정의
        TextStyle questNameStyle = (index % 2 == 0)
            ? TextStyle(fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, color: Colors.white)
            : TextStyle(fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, color: Color(0xFF565656));

        TextStyle questValueStyle = (index % 2 == 0)
            ? TextStyle(fontSize: 24, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, color: Color(0xFFFFF6DF))
            : TextStyle(fontSize: 24, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, color: Color(0xFFFF5329));

        TextStyle questDateStyle = (index % 2 == 0)
            ? TextStyle(fontSize: 12, color: Color(0xFFF6F6F6))
            : TextStyle(fontSize: 12, color: Color(0xFF565656));

        Color containerColor = (index % 2 == 0) ? Color(0xFFFA603B) : Color(0xFFFFC5B8);
        Border containerBorder = (index % 2 == 0)
            ? Border.all(color: Color(0xFFFA603B), width: 1)
            : Border.all(color: Color(0xFFFFC5B8), width: 1);

        return Transform.translate(
          offset: (index % 2 == 0) ? Offset(10, 0) : Offset(-10, 0),
          child: Container(
            width: 338,
            height: 68,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8),
              border: containerBorder,
            ),
            child: Stack(
              children: [
                // 왼쪽 상단 텍스트들 (퀘스트 이름 + 값 데이터 + "do" 단위)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        questName,
                        style: questNameStyle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '+',
                        style: questValueStyle.copyWith(fontSize: questValueStyle.fontSize! - 2),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        questValue,
                        style: questValueStyle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'do',
                        style: questValueStyle.copyWith(fontSize: questValueStyle.fontSize! - 2),
                      ),
                    ),
                  ],
                ),
                // 오른쪽 하단 텍스트 (날짜 데이터)
                Positioned(
                  bottom: 8,
                  right: 0,
                  child: Text(
                    questDate,
                    style: questDateStyle,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
