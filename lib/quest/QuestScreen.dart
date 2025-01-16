import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/api/auth_questteamname.dart';
import '/api/auth_questleader.dart';
import '/api/auth_questweekcalendar.dart';

import '../Bottom_Navigation.dart';

class QuestScreen extends StatefulWidget {
  @override
  _QuestScreenState createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  List<dynamic> weeklyCalendarData = [];
  List<dynamic> monthlyCalendarData = [];
  List<dynamic> selectedQuests = [];
  bool isLoading = true;

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int currentPage = 0;
  String teamName = "팀 정보를 불러오는 중...";
  List<dynamic> quests = [];
  String selectedView = "주";
  int weeklyPage = 0; // 주간 캘린더 페이지
  List<dynamic> selectedQuestList = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    // 현재 날짜에 해당하는 페이지 계산
    int daysFromStartOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    currentPage = (daysFromStartOfYear / 7).floor();

    fetchWeeklyCalendarData();
    fetchMonthlyCalendarData();
    _loadTeamName();
    _loadReaderQuest();
    loadSelectedQuests();
  }

  Future<void> _loadTeamName() async {
    String? fetchedTeamName = await fetchTeamName();
    setState(() {
      teamName = fetchedTeamName ?? "팀 정보를 가져올 수 없습니다.";
      isLoading = false;
    });
  }

  Future<void> _loadReaderQuest() async {
    List<dynamic>? leaderQuests = await fetchLeaderQuest();

    setState(() {
      isLoading = false;
      quests = leaderQuests ?? [];
    });
  }

  Future<void> fetchMonthlyCalendarData() async {
    final url = Uri.parse('http://52.78.9.87:8080/calendar/monthly');

    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        setState(() {
          // leaderQuestData = json.decode(response.body);
        });
        print("Leader Quest Data fetched successfully: $monthlyCalendarData");
      } else {
        // print('Failed to load leaderQuest data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leaderQuest data: $e');
    }
  }

  List<Map<String, dynamic>> generateWeekData(int page) {
    List<Map<String, dynamic>> data = [];
    DateTime firstSunday2024 = DateTime(2024, 1, 7);
    DateTime currentWeekStart = firstSunday2024.add(Duration(days: page * 105)); // 페이지에 따라 이동

    for (int i = 0; i < 15; i++) {
      List<dynamic> weekQuests = weeklyCalendarData.where((item) {
        DateTime itemDate = DateTime(item['year'], item['month'], item['date']);
        return itemDate.isAfter(currentWeekStart.subtract(Duration(days: 1))) &&
            itemDate.isBefore(currentWeekStart.add(Duration(days: 7)));
      }).toList();

      Map<String, dynamic> weekData = {
        "id": i + 1,
        "year": currentWeekStart.year,
        "month": currentWeekStart.month,
        "endDate": currentWeekStart.day,
        "achievement": weekQuests.isEmpty ? "None" : "HasData",
        "questCount": weekQuests.length,
        "questList": weekQuests,
      };

      data.add(weekData);
      currentWeekStart = currentWeekStart.add(Duration(days: 7));
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
    } else {
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
    List<Map<String, dynamic>> previousWeekData = generateWeekData(currentPage - 1); // 이전 페이지 데이터 추가
    Set<int> shownMonths = {}; // Set으로 중복 방지

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "$selectedYear년",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: currentPage > 0 || selectedYear > 2024
                  ? () {
                setState(() {
                  if (currentPage == 0 && selectedYear > 2024) {
                    selectedYear--;
                    currentPage = 51; // 이전 년도의 마지막 페이지로 이동
                  } else {
                    currentPage--;
                  }
                  selectedQuestList = [];
                });
              }
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  if (currentPage == 51 && currentWeekData.isNotEmpty &&
                      currentWeekData.last['month'] == 1) {
                    selectedYear++;
                    currentPage = 0; // 다음 년도의 첫 페이지로 이동
                  } else {
                    currentPage++;
                  }
                  selectedQuestList = [];
                });
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 9.0,
          runSpacing: 9.0,
          children: List.generate(15, (index) {
            if (index >= currentWeekData.length) return SizedBox.shrink();

            Map<String, dynamic> weekData = currentWeekData[index];

            // 이전 페이지에 동일 월 주차가 있는지 확인
            bool isDuplicatedInPreviousPage = previousWeekData.any((previousWeek) => previousWeek['month'] == weekData['month']);

            // 월 표시 여부 결정: 이전 페이지가 우선 표시되도록
            bool showMonth = !shownMonths.contains(weekData['month']) && !isDuplicatedInPreviousPage;

            if (showMonth) {
              shownMonths.add(weekData['month']);
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedQuestList = weekData['questList'];
                });
              },
              child: Column(
                children: [
                  if (showMonth)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "${weekData['month']}월",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                    "${weekData['endDate']}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }




  Widget buildMonthlyCalendar() {
    return Column(
      children: [
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
                    SizedBox(height: 8),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Color(0xFFEAEAEA),
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // 로딩 중일 때 표시
          : SingleChildScrollView(
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
                    teamName,
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
                            backgroundColor: Colors.white,
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
                                  SizedBox(height: 16),
                                  // 목록 내용
                                  Text(
                                    "리더별 퀘스트",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  quests.isNotEmpty
                                      ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: quests.length,
                                    itemBuilder: (context, index) {
                                      var quest = quests[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          "${quest}",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    },
                                  ):
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