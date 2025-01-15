import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';
import 'package:fl_chart/fl_chart.dart';
import '/api/auth_xpalldata.dart';
import '/api/auth_xptrenddata.dart';
import 'package:intl/intl.dart';


class TrendsChart extends StatelessWidget {
  final List<int> years;
  final List<double> values;

  TrendsChart({required this.years, required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 섹션 전체 배경을 흰색으로 설정
      child: SizedBox(
        height: 300, // 차트 높이 지정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "트렌드",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
                reverse: true,
                child: Container(
                  width: years.length * 80.0, // 막대그래프 간격 설정
                  color: Colors.white, // 스크롤 컨테이너 배경도 흰색으로 설정
                  child: BarChart(
                    BarChartData(
                      backgroundColor: Colors.white, // 차트 배경 흰색
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false, // 세로축 숨김
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false, // 세로축 숨김
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final index = value.toInt();
                              return Text(
                                years[index].toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: values.asMap().entries.map((entry) {
                        final index = entry.key;
                        final value = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              color: Color(0xFFFFAA95), // 막대 색상
                              width: 46,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class XpScreen extends StatefulWidget {
  @override
  _XpScreenState createState() => _XpScreenState();
}

class _XpScreenState extends State<XpScreen> {
  late Future<XpInfo?> xpInfo;
  late Future<XpTrendInfo?> xpTrendInfo;

  @override
  void initState() {
    super.initState();
    xpInfo = AuthXpAllData().fetchXpData(); // XP 데이터 가져오기
    xpTrendInfo = AuthXpTrendData().fetchXpTrendData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Container(
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
            preferredSize: Size.fromHeight(2.0),
            child: Container(
              color: Color(0xFFEAEAEA),
              height: 1.0,
            ),
          ),
        ),
      ),
    body: FutureBuilder<XpInfo?>(
      future: xpInfo,
      builder: (context, xpInfoSnapshot) {
        if (xpInfoSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // xpInfo 로딩 중
          } else if (xpInfoSnapshot.hasError) {
          return Center(child: Text('Error: ${xpInfoSnapshot.error}'));
        } else if (!xpInfoSnapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          final xpData = xpInfoSnapshot.data;

    // xpTrendInfo를 위해 두 번째 FutureBuilder
          return FutureBuilder<XpTrendInfo?>(
            future: xpTrendInfo,
            builder: (context, xpTrendSnapshot) {
              if (xpTrendSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // xpTrendInfo 로딩 중
                } else if (xpTrendSnapshot.hasError) {
                return Center(child: Text('Error: ${xpTrendSnapshot.error}'));
              } else if (!xpTrendSnapshot.hasData) {
                return Center(child: Text('No trend data available'));
              } else {
                final xpTrendData = xpTrendSnapshot.data;

                // 필요한 데이터가 있을 때 렌더링
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      _buildTrendsSection(
                        context: context,
                        title: "경험치 현황",
                        progressRows: [
                          _buildProgressRow(
                            context,
                            '올해 획득한 경험치',
                            (xpData?.currentPercent ?? 0) /100,
                            "${NumberFormat('#,###').format(xpData?.currExp)} / ${NumberFormat('#,###').format(xpData?.currlimit)}",
                          ),
                          SizedBox(height: 16),
                          _buildProgressRow(
                            context,
                            "다음 레벨 달성까지",
                            (xpData?.presentPercent ?? 0) / 100,
                            "${NumberFormat('#,###').format(xpData?.accumExp)} / ${NumberFormat('#,###').format(xpData?.necessaryExp)}",
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 20, // 두께를 설정
                        color: Colors.grey.shade200, // 구분선 색상 설정
                        ),

                      // 트렌드 차트 섹션
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TrendsChart(
                      years: xpTrendData?.years ?? [],
                      values: xpTrendData?.values ?? [],
                    ),
                  ),
                    ],
                  ),
                );
              }
              },
          );
        }},
    ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
    );
  }

// 공통 섹션 빌더
  Widget _buildTrendsSection({required BuildContext context,required String title, required List<Widget> progressRows}) {
    return Container(
      width: double.infinity, // 부모 너비에 맞추도록 설정
      padding: EdgeInsets.all(17.0),
      decoration: BoxDecoration(
        color: Colors.white, // 배경 흰색
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
        children: [
          // 제목과 버튼을 나란히 배치
          // 제목과 버튼을 나란히 배치
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // 수직 정렬 조정
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/totalxppage');
                },
                child: Container(
                  padding: EdgeInsets.only(top: 30, right: 6), // 버튼을 더 아래로 내림
                  color: Colors.transparent,
                  child: Text(
                    '전체 경험치 보기 →',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF565656),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),
          ...progressRows, // 전달된 progressRows 위젯 리스트 추가
        ],
      ),
    );
  }
}

// 공통 막대 차트 빌더
Widget _buildProgressRow(BuildContext context, String label, double progress, String value) {

  List<String> levels = [
    "F1-Ⅰ", "F1-Ⅱ", "F2-Ⅰ", "F2-Ⅱ", "F2-Ⅲ", "F3-Ⅰ", "F3-Ⅱ", "F3-Ⅲ", "F4-Ⅰ", "F4-Ⅱ", "F4-Ⅲ", "F5",
  ];

  List<String> experiencePoints = [
    "0", "13,500", "27,000", "39,000", "51,000", "63,000", "78,000", "93,000", "108,000", "126,000", "144,000", "162,000"
  ];


  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF565656),
            ),
          ),
          // 아이콘 버튼 추가
          if (label == "다음 레벨 달성까지")
            Container(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height/1.5,
                          width: 350.0,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 28),
                              Text(
                                "레벨별 경험치",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),

                              // 표 추가
                              Table(
                                border: TableBorder.all(
                                  color: Color(0xFFEAEAEA), // 테이블 선 색상
                                  width: 1.0, // 선 두께 1px
                                  ),
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        color: Color(0xFFF95E39),
                                        child: TableCell(
                                          child: Center( // 중앙 정렬
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text("레벨", style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Color(0xFFF95E39),
                                        child: TableCell(
                                          child: Center( // 중앙 정렬
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text("총 필요한 경험치", style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 12개의 행에 각기 다른 텍스트 넣기
                                  for (int i = 0; i < 12; i++)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Center( // 중앙 정렬
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text(levels[i], style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 14.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Center( // 중앙 정렬
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text(experiencePoints[i],
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ), // 각기 다른 경험치
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(280.0, 52.0),
                                      backgroundColor: Color(0xFFF95E39),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "확인",
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xFF565656),
                ),
              ),
            ),
        ],
      ),
      SizedBox(height: 8),
      // 진행 바
      Stack(
        children: [
          // 배경 바
          Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          // 진행 바
          FractionallySizedBox(
            widthFactor: progress,
            child: Stack(
              children: [
                // 진행 바 색상
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color(0xFFF95E39),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                // 이미지와 텍스트를 진행 바 끝에 배치
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 이미지
                          Image.asset(
                            'assets/icons/group.png', // 이미지 경로
                            width: 50, // 이미지 너비
                            height: 50, // 이미지 높이
                          ),
                          // 텍스트
                          Text(
                            "${(progress * 100).toInt()}%", // 진행률 텍스트
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF95E39), // 텍스트 색상
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      // 값 텍스트
      Row(
        mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    ],
  );
}