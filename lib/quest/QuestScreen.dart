import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Bottom_Navigation.dart';

class QuestScreen extends StatefulWidget {
  @override
  _QuestScreenState createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  List<dynamic> weeklyCalendarData = [];
  List<dynamic> monthlyCalendarData = [];
  List<dynamic> selectedQuests = [];
  List<dynamic> leaderQuestData = [];

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int currentPage = 0;
  String teamName = "";
  String selectedView = "주";
  int weeklyPage = 0; // 주간 캘린더 페이지
  List<dynamic> selectedQuestList = [];


  @override
  void initState() {
    super.initState();
    fetchTeamName();
    fetchWeeklyCalendarData();
    fetchMonthlyCalendarData();
  }


  Future<void> fetchTeamName() async {
    final url = Uri.parse('http://52.78.9.87:8080/calendar/team');
    final token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5zdWtpbSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY5NDg0Njd9.g1V8THPXqDOMdEGeZg3-maqNU4CMpEc7J3fumyMRiK4';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          teamName = responseData['teamName'] ?? "소속 없음";
        });
        print("Team Name fetched successfully: $teamName");
      } else if (response.statusCode == 404) {
        setState(() {
          teamName = "소속 없음";
        });
        print("Team Name not found.");
      } else {
        print('Failed to load team name: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        teamName = "소속 없음";
      });
      print('Error fetching team name: $e');
    }
  }

  Future<void> fetchWeeklyCalendarData() async {
    final url = Uri.parse('http://52.78.9.87:8080/calendar/weekly');
    final token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5zdWtpbSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY5NDg0Njd9.g1V8THPXqDOMdEGeZg3-maqNU4CMpEc7J3fumyMRiK4';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          weeklyCalendarData = json.decode(response.body);
        });
        print("Weekly Calendar Data fetched successfully: $weeklyCalendarData");
      } else {
        print('Failed to load weekly data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weekly data: $e');
    }
  }

  Future<void> fetchMonthlyCalendarData() async {
    final url = Uri.parse('http://52.78.9.87:8080/calendar/monthly');

    try {
      final response = await http.get(
        url,

      );

      if (response.statusCode == 200) {
        setState(() {
          leaderQuestData = json.decode(response.body);
        });
        print("Leader Quest Data fetched successfully: $monthlyCalendarData");
      } else {
        print('Failed to load leaderQuest data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leaderQuest data: $e');
    }
  }

  Future<void> fetchLeaderQuest() async {
    final url = Uri.parse('http://52.78.9.87:8080/calendar/quest-list');
    final token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5zdWtpbSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY5NDg0Njd9.g1V8THPXqDOMdEGeZg3-maqNU4CMpEc7J3fumyMRiK4';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          leaderQuestData = json.decode(response.body);
        });
        print("Monthly Calendar Data fetched successfully: $monthlyCalendarData");
      } else {
        print('Failed to load monthly data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching monthly data: $e');
    }
  }





  List<Map<String, dynamic>> generateWeekData(int page) {
    List<Map<String, dynamic>> data = [];
    DateTime currentWeek = DateTime(2024, 1, 7).add(Duration(days: page * 15 * 7));

    for (int i = 0; i < 15; i++) {
      final match = weeklyCalendarData.firstWhere(
            (item) =>
        item['year'] == currentWeek.year &&
            item['month'] == currentWeek.month &&
            item['date'] == currentWeek.day,
        orElse: () => {
          "id": i + 1,
          "year": currentWeek.year,
          "month": currentWeek.month,
          "date": currentWeek.day,
          "achievement": "None",
          "questCount": 0,
          "questList": []
        },
      );
      data.add(match);
      currentWeek = currentWeek.add(Duration(days: 7));
    }
    return data;
  }

  void _onWeekSelected(Map<String, dynamic> weekData) {
    setState(() {
      selectedQuestList = weekData['questList'];
    });
  }


  void loadSelectedQuests() {
    setState(() {
      final monthData = monthlyCalendarData.firstWhere(
            (data) => data['year'] == selectedYear && data['month'] == selectedMonth,
        orElse: () => null,
      );
      selectedQuests = monthData != null ? monthData['questList'] : [];
    });
  }

  Color getBoxColor_(String achievement, List<dynamic> questList) {
    if (achievement == "Max" || questList.any((quest) => quest['achievement'] == "Max")) {
      return Color(0xFFFF8E73);
    }
    if (achievement == "Medium" || questList.any((quest) => quest['achievement'] == "Medium")) {
      return Color(0xFFFFBC9F);
    }else {
      return Colors.grey.shade300;
    }
  }

  Color getBoxColor(String achievement) {
    if (achievement == "Max") {
      return Color(0xFFFF8E73);
    } else if (achievement == "Medium") {
      return Color(0xFFFFBC9F);
    } else {
      return Colors.grey.shade300;
    }
  }

  Color getBarColor(String achievement) {
    if (achievement == "Max") {
      return Color(0xFFFF8E73);
    } else if (achievement == "Medium") {
      return Color(0xFFFFBC9F);
    } else {
      return Colors.grey.shade300;
    }
  }

  Widget buildWeeklyCalendar() {
    List<Map<String, dynamic>> currentWeekData = generateWeekData(currentPage);
    int currentYear = currentWeekData.isNotEmpty ? currentWeekData[0]['year'] : DateTime.now().year;

    return Column(
      children: [
        // 년도 표시 및 페이지 이동 버튼
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "$currentYear년",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                if (currentPage > 0) {
                  setState(() {
                    currentPage--;
                    selectedQuestList = []; // 선택 초기화
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  currentPage++;
                  selectedQuestList = []; // 선택 초기화
                });
              },
            ),
          ],
        ),
        SizedBox(height: 8),

        // 캘린더 박스
        Wrap(
          spacing: 9.0,
          runSpacing: 9.0,
          alignment: WrapAlignment.center,
          children: currentWeekData.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> weekData = entry.value;

            bool showMonth = index == 0 ||
                (index > 0 && currentWeekData[index - 1]['month'] != weekData['month']);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedQuestList = weekData['questList']; // 박스 선택 시 퀘스트 목록 업데이트
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 월 텍스트 공간 고정
                  SizedBox(
                    height: 20,
                    child: showMonth && weekData['date'] <= 7
                        ? Text(
                      "${weekData['month']}월",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                        : null,
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: getBoxColor(weekData['achievement']),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${weekData['date']}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 18.0,right: 20.0), // 오른쪽 여백 20
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
            children: [
              SizedBox(width: 50), // 왼쪽으로 이동
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
              SizedBox(width: 16),
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


        // 선택된 박스의 퀘스트 리스트
        selectedQuestList.isEmpty
            ? Center(child: Text(''))
            : ListView.builder(
          shrinkWrap: true, // ListView가 Column에 맞게 크기 조정
          physics: NeverScrollableScrollPhysics(), // 별도 스크롤 비활성화
          itemCount: selectedQuestList.length,
          itemBuilder: (context, index) {
            final quest = selectedQuestList[index];
            return ListTile(
              leading: Container(
                width: 10,
                height: 50,
                color: getBarColor(quest['achievement']),
              ),
              title: Text(quest['questName']),
              subtitle: Text(quest['comments']),
              trailing: Text('EXP: ${quest['exp']}'),
            );
          },
        ),
      ],
    );
  }




  Widget buildMonthlyCalendar() {
    return Column(
      children: [
        // 년도와 화살표 영역
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 0.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "$selectedYear년",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    selectedYear--;
                    loadSelectedQuests();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    selectedYear++;
                    loadSelectedQuests();
                  });
                },
              ),
            ],
          ),
        ),

        // 월간 캘린더 박스
        Center(
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: List.generate(12, (index) {
              final monthData = monthlyCalendarData.firstWhere(
                    (data) => data['year'] == selectedYear && data['month'] == index + 1,
                orElse: () => null,
              );
              final boxColor = monthData != null
                  ? getBoxColor_(monthData['achievement'], monthData['questList'])
                  : Colors.grey.shade300;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMonth = index + 1;
                    loadSelectedQuests();
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: monthData != null && monthData['questList'].isNotEmpty
                          ? Center(
                        child: Text(
                          '${monthData['questList'].length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : null,
                    ),
                    SizedBox(height: 8), // 박스와 텍스트 사이 간격
                    Text(
                      '${index + 1}월',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        SizedBox(height: 16),

        // 색상 정보
        Padding(
          padding: const EdgeInsets.only(right: 20.0), // 오른쪽 여백 20
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
            children: [
              SizedBox(width: 50), // 왼쪽으로 이동
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
              SizedBox(width: 16),
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

        if (selectedQuests.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                ...selectedQuests.map((quest) {
                  return ListTile(
                    leading: Container(
                      width: 8,
                      height: 50,
                      color: quest['achievement'] == "Max"
                          ? Color(0xFFFF8E73)
                          : quest['achievement'] == "Medium"
                          ? Color(0xFFFFBC9F)
                          : Colors.grey.shade300,
                    ),
                    title: Text(quest['questName']),
                    subtitle: Text(quest['comments']),
                    trailing: Text(
                      "EXP: ${quest['exp']}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
      ],
    );
  }




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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.bug_report, color: Colors.black),
        //     onPressed: loadDummyData, // 더미 데이터를 로드하는 버튼
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 팀 정보 섹션
              Text(
                "소속",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamName.isNotEmpty ? teamName : "팀 정보를 불러오는 중...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/quest_list.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 모달 창 제목
                                  Text(
                                    "퀘스트 목록",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "* 달성 조건 및 부여 경험치",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // 목록 내용
                                  Text(
                                    "직무별 퀘스트",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "[생산성]",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    "5.1 이상 경험치 80 부과\n"
                                        "4.3 이상 경험치 40 부과\n"
                                        "그 이하 미달성",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // 색상 정보
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
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
                                            "높은 목표",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
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
                                            "보통 목표",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "미달성",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
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
                  ),

                ],
              ),
              SizedBox(height: 12),
              Divider(color: Colors.black12, thickness: 1.5),

              // 주간/월간 드롭다운 버튼
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15,top: 16), // 왼쪽 여백 추가
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical:0), // 패딩 설정
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // 배경색
                      borderRadius: BorderRadius.circular(20), // 둥근 모서리
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedView,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedView = newValue!;
                          });
                        },
                        items: ["주", "월"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15), // 텍스트 크기 조정
                            ),
                          );
                        }).toList(),
                        dropdownColor: Colors.white, // 드롭다운 배경색
                        style: TextStyle(fontSize: 14, color: Colors.black), // 드롭다운 텍스트 스타일
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 16),

              // 캘린더 표시
              selectedView == "주" ? buildWeeklyCalendar() : buildMonthlyCalendar(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
    );
  }
}
