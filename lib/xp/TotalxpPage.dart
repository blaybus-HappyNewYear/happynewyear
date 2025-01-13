import 'package:flutter/material.dart';

// 위젯에 표시할 데이터 모델
class ExperienceData {
  final String xpAmount;
  final String date;
  final String xpContent; // 경험치 내용 필드 추가

  ExperienceData({
    required this.xpAmount,
    required this.date,
    required this.xpContent,
  });
}

class Totalxppage extends StatefulWidget {
  @override
  _TotalxppageState createState() => _TotalxppageState();
}

class _TotalxppageState extends State<Totalxppage> {
  // 예시 데이터
  List<ExperienceData> experienceDataList = [
    ExperienceData(xpAmount: '150', date: '24/01/05', xpContent: '퀘스트 완료'),
    ExperienceData(xpAmount: '200', date: '24/01/05', xpContent: '일일 미션'),
    ExperienceData(xpAmount: '100', date: '24/01/05', xpContent: '보너스 경험치'),
    ExperienceData(xpAmount: '100', date: '24/01/05', xpContent: '업적 달성'),
    ExperienceData(xpAmount: '100', date: '24/01/05', xpContent: '업적 달성'),
    ExperienceData(xpAmount: '100', date: '24/01/05', xpContent: '업적 달성'),
    ExperienceData(xpAmount: '100', date: '24/01/05', xpContent: '업적 달성'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/mainpage');
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      "전체 경험치",
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
            preferredSize: Size.fromHeight(2.0),
            child: Container(
              color: Color(0xFFEAEAEA),
              height: 1.0,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 106,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "올해 획득한 경험치",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.0),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '경험치 수',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF95E39),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'do',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Color(0xFFEAEAEA),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: experienceDataList.length,
              itemBuilder: (context, index) {
                // 각 항목을 ExperienceItem 위젯으로 표시
                return ExperienceItem(experienceData: experienceDataList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final ExperienceData experienceData;

  ExperienceItem({required this.experienceData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFEAEAEA), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 부분: 경험치 내용과 날짜
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 경험치 내용
                Text(
                  '+${experienceData.xpAmount}',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                // 첫 번째 날짜 (왼쪽 상단)
                Text(
                  experienceData.xpContent,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽 하단: 경험치 획득 내용
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              experienceData.date,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8A8A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
