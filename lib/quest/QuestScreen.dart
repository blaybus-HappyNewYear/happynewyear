import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Bottom_Navigation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestScreen extends StatefulWidget {
  @override
  _QuestScreenState createState() => _QuestScreenState();
}


//week 캘린더 조회
Future<Map<String, dynamic>> fetchWeekCalendar(String accessToken) async {
  final url = Uri.parse('http://52.78.9.87:8080/calendar/weekly');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load week calendar');
  }
}

//month 캘린더 조회
Future<Map<String, dynamic>> fetchWeekNextCalendar(String accessToken) async {
  final url = Uri.parse('http://52.78.9.87:8080/calendar/monthly');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load month calendar');
  }
}


//리더부여퀘스트 목록
Future<List<dynamic>> fetchQuestList(String accessToken, int id) async {
  final url = Uri.parse('http://52.78.9.87:8080/calendar/quest-list');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load quest list');
  }
}

//내 소속
Future<List<dynamic>> fetchLeaderQuestList(String accessToken, int id) async {
  final url = Uri.parse('http://52.78.9.87:8080/calendar/team');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load quest list');
  }
}

void fetchAllData() async {
  String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqYW1pbmhlbyIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY4Nzc1MDF9.oIrL9FsosKC-Znh3hB8IfQrXNHrCXnutS4FFtJ5BVm4';
  try {
    // 주간 캘린더 데이터
    Map<String, dynamic> weeklyCalendar = await fetchWeekCalendar(accessToken);
    print("Weekly Calendar Data: $weeklyCalendar");

    // 월간 캘린더 데이터
    Map<String, dynamic> monthlyCalendar = await fetchWeekNextCalendar(accessToken);
    print("Monthly Calendar Data: $monthlyCalendar");

    // 퀘스트 목록
    List<dynamic> questList = await fetchQuestList(accessToken, 1); // ID는 예시로 1 사용
    print("Quest List Data: $questList");

    // 리더 부여 소속 데이터
    List<dynamic> leaderQuestList = await fetchLeaderQuestList(accessToken, 1); // ID는 예시로 1 사용
    print("Leader Quest List Data: $leaderQuestList");
  } catch (e) {
    print("Error fetching data: $e");
  }
}


// 첫번째 일요일 날짜 계산
DateTime getFirstSundayOfMonth(int year, int month) {
  DateTime firstDayOfMonth = DateTime(year, month, 1);
  int daysUntilSunday = (7 - firstDayOfMonth.weekday) % 7;
  return firstDayOfMonth.add(Duration(days: daysUntilSunday));
}

class _QuestScreenState extends State<QuestScreen> {
  String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqYW1pbmhlbyIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY4NTAzNjR9.e22Wr6CWB7q-p0sNY1pVDnfbUW2BjlpL_b0G_FGSn-Q'; // 로그인 후 받은 토큰
  String selectedView = "주"; // 기본값을 주간으로 설정
  int selectedYear = 2025; // 기본 연도
  DateTime selectedDate = DateTime.now(); // 현재 날짜 기준
  int selectedMonth = 1; // 기본 월
  List<String> questList = []; // 선택된 주차의 퀘스트 목록

  // 테스트용 목표 달성 데이터
  Map<DateTime, String> achievementStatus = {
    DateTime(2025, 1, 7): "high", // 높은 목표 달성
    DateTime(2025, 2, 14): "medium", // 일반 목표 달성
    DateTime(2025, 4, 14): "medium", // 일반 목표 달성
    DateTime(2025, 1, 21): "medium", // 일반 목표 달성
    DateTime(2025, 1, 14): "medium", // 일반 목표 달성
    DateTime(2025, 1, 13): "medium", // 일반 목표 달성
    DateTime(2025, 1, 12): "medium", // 일반 목표 달성
    DateTime(2025, 1, 14): "medium", // 일반 목표 달성
    DateTime(2025, 2, 7): "high", // 높은 목표 달성
    DateTime(2025, 5, 1): "high", // 높은 목표 달성
    DateTime(2025, 4, 29): "high", // 높은 목표 달성
    DateTime(2025, 1, 7): "high", // 높은 목표 달성
    DateTime(2025, 3, 7): "high", // 높은 목표 달성
    DateTime(2025, 1, 5): "high", // 높은 목표 달성
    DateTime(2025, 1, 11): "high", // 높은 목표 달성


  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "우리 팀 퀘스트",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "소속",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "음성 1센터 - 그룹 1",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showQuestDialog(context);
                          },
                          child: Image.asset(
                            'assets/icons/quest_list.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.black12, thickness: 1.5),
                  ],
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6, // 화면의 50% 높이
                ),
                child: Stack(
                  children: [
                    // 캘린더 위젯
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0), // 캘린더 상단 여백 조정
                      child: selectedView == '주'
                          ? _buildWeeklyCalendar()
                          : _buildMonthlyCalendar(),
                    ),
                    // 년도와 주/월 드롭다운 섹션
                    Positioned(
                      top: -10,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedView,
                                    underline: Container(height: 0),
                                    isDense: true,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedView = value!;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: "주",
                                        child: Text("주"),
                                      ),
                                      DropdownMenuItem(
                                        value: "월",
                                        child: Text("월"),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "$selectedYear년",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 화살표 섹션 복원
                    Positioned(
                      top: 45.0, // 캘린더 상단과 맞춤
                      right: 0.0, // 캘린더 오른쪽 여백
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: Colors.grey),
                            splashColor: Colors.grey,
                            highlightColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                if (selectedView == "주") {
                                  // 주간에서 왼쪽 화살표 클릭
                                  if (selectedMonth == 1) {
                                    selectedMonth = 12;
                                    selectedYear--;
                                  } else {
                                    selectedMonth--;
                                  }
                                } else {
                                  // 월간에서 왼쪽 화살표 클릭
                                  selectedYear--;
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: Colors.grey),
                            splashColor: Colors.grey,
                            highlightColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                if (selectedView == "주") {
                                  // 주간에서 오른쪽 화살표 클릭
                                  if (selectedMonth == 12) {
                                    selectedMonth = 1;
                                    selectedYear++;
                                  } else {
                                    selectedMonth++;
                                  }
                                } else {
                                  // 월간에서 오른쪽 화살표 클릭
                                  selectedYear++;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // MAX, MEDIUM 표시
                    Positioned(
                      top: 430.0, // 캘린더 하단과 여백
                      right: 16.0, // 오른쪽 여백
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF8E73),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "MAX",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 11),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFBC9F),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "MEDIUM",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              if (questList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      ...questList.map((quest) => ListTile(title: Text(quest))).toList(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
    );
  }

  void _showQuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            "퀘스트 목록",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "* 달성 조건 및 부여 경험치",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                "직무별 퀘스트",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              _buildQuestItem("5.1 이상 경험치 80 부과", Color(0xFFFF8E73)),
              _buildQuestItem("4.3 이상 경험치 40 부과", Color(0xFFFFBC9F)),
              _buildQuestItem("그 이하 미달성", Colors.grey),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar() {
    List<Widget> weeks = [];
    DateTime weekEnd = getFirstSundayOfMonth(selectedYear, selectedMonth);
    int previousMonth = 0;

    for (int i = 0; i < 15; i++) {
      bool showMonth = weekEnd.month != previousMonth;
      String status = achievementStatus[weekEnd] ?? "none";
      weeks.add(WeekBox(
        weekEnd: weekEnd,
        selectedDate: selectedDate,
        onTap: () => _onWeekSelected(weekEnd),
        showMonth: showMonth,
        achievementStatus: status,
      ));
      previousMonth = weekEnd.month;
      weekEnd = weekEnd.add(Duration(days: 7));
    }

    return Center(
      child: Wrap(
        spacing: 12.0,
        runSpacing: 10.0,
        children: weeks,
      ),
    );
  }

  void _onWeekSelected(DateTime weekEnd) {
    setState(() {
      selectedDate = weekEnd;
      questList = [
        "퀘스트 1: ${DateFormat('yyyy-MM-dd').format(weekEnd)}",
        "퀘스트 2: ${DateFormat('yyyy-MM-dd').format(weekEnd)}",
        "퀘스트 3: ${DateFormat('yyyy-MM-dd').format(weekEnd)}",
      ];
    });
  }

  Widget _buildMonthlyCalendar() {
    List<String> months = [
      '1월', '2월', '3월', '4월', '5월', '6월',
      '7월', '8월', '9월', '10월', '11월', '12월'
    ];

    return Center(
      child: Wrap(
        spacing: 12.0,
        runSpacing: 10.0,
        children: List.generate(months.length, (index) {
          bool isSelected = (index + 1) == selectedMonth;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonth = index + 1;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ?Color(0xFFFF8E73) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  months[index],
                  style: TextStyle(
                    color: isSelected ? Color(0xFFFF8E73): Colors.black54,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class WeekBox extends StatelessWidget {
  final DateTime weekEnd;
  final DateTime selectedDate;
  final VoidCallback onTap;
  final bool showMonth;
  final String achievementStatus;

  const WeekBox({
    required this.weekEnd,
    required this.selectedDate,
    required this.onTap,
    required this.showMonth,
    required this.achievementStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color boxColor;
    if (achievementStatus == "high") {
      boxColor = Color(0xFFFF8E73);
    } else if (achievementStatus == "medium") {
      boxColor = Color(0xFFFFBC9F);
    } else {
      boxColor = Colors.grey.shade300;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
          child: showMonth
              ? Text(
            "${weekEnd.month}월",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          )
              : null,
        ),
        SizedBox(height: 4),
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(onTap: onTap),
        ),
        SizedBox(height: 4),
        Text(
          DateFormat('d').format(weekEnd),
          style: TextStyle(
            color: selectedDate == weekEnd ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
