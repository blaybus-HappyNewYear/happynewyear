import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';
import 'package:fl_chart/fl_chart.dart';

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



class XpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 테스트 데이터
    final years = [2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025];
    final values = [31.0, 22.0, 27.0, 29.0, 24.0, 20.0, 32.0, 30.0, 25.0, 22.0, 21.0, 19.0, 26.0];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(

        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
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
            preferredSize: Size.fromHeight(2.0), // 보더의 높이를 설정
            child: Container(
              color: Color(0xFFEAEAEA), // 보더 색상
              height: 1.0, // 보더 두께
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            // 경험치 현황 섹션
            _buildTrendsSection(
              title: "경험치 현황",
              progressRows: [
                _buildProgressRow(
                  '올해 획득한 경험치',
                  0.5,
                  "3,600 / 9000",
                ),
                SizedBox(height: 16),
                _buildProgressRow(
                  "다음 레벨 달성까지",
                  0.2,
                  "30,000 / 150,000",
                ),
              ],
            ),

            // 두꺼운 구분선 추가
            Container(
              width: double.infinity,
              height: 20, // 두께를 설정
              color: Colors.grey.shade200, // 구분선 색상 설정
            ),

            // 트렌드 차트 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TrendsChart(
                years: years,
                values: values,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
    );
  }

  // 공통 섹션 빌더
  Widget _buildTrendsSection({required String title, required List<Widget> progressRows}) {
    return Container(
      width: double.infinity, // 부모 너비에 맞추도록 설정
      padding: EdgeInsets.all(17.0),
      decoration: BoxDecoration(
        color: Colors.white, // 배경 흰색
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ...progressRows, // 전달된 progressRows 위젯 리스트 추가
        ],
      ),
    );
  }
}

// 공통 막대 차트 빌더
Widget _buildProgressRow(String label, double progress, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 레이블
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF565656),
        ),
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
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Color(0xFFF95E39),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          // 이미지와 텍스트를 포함한 스택
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Stack(
                  alignment: Alignment.center, // 텍스트를 이미지 중앙에 정렬
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
                        color: Color(0xFFF95E39), // 텍스트 색상 (이미지와 대비되도록)
                      ),
                    ),
                  ],
                ),
              ),
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