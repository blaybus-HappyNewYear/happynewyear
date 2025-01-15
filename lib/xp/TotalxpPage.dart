import 'package:flutter/material.dart';
import '/api/auth_xplogdata.dart'; // XplogItem과 AuthXplogdata를 import
import '/api/auth_currentxp.dart';
import 'package:intl/intl.dart';

class Totalxppage extends StatefulWidget {
  @override
  _TotalxppageState createState() => _TotalxppageState();
}

class _TotalxppageState extends State<Totalxppage> {
  int? currentExp; // currentExp 값을 저장할 변수
  List<XplogItem> experienceDataList = []; // XplogItem 데이터를 저장할 리스트

  Future<void> fetchCurrentExp() async {
    AuthCurrentxp authCurrentxp = AuthCurrentxp();
    int? fetchedExp = await authCurrentxp.fetchCurrentxpData();
    setState(() {
      currentExp = fetchedExp;
    });
  }

  Future<void> fetchExperienceData() async {
    AuthXplogdata authXplogdata = AuthXplogdata();
    List<XplogItem> fetchedData = await authXplogdata.FetchXplogData();
    setState(() {
      experienceDataList = fetchedData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentExp();
    fetchExperienceData();
  }

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
                      Navigator.pop(context);
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
          automaticallyImplyLeading: false,
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
                          currentExp != null
                              ? NumberFormat('#,###').format(currentExp)
                              : '로딩 중...',
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
            child: experienceDataList.isEmpty
                ? Center(child: CircularProgressIndicator()) // 로딩 중 표시
                : ListView.builder(
              itemCount: experienceDataList.length,
              itemBuilder: (context, index) {
                return ExperienceItem(experienceData: experienceDataList[index]);
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final XplogItem experienceData;

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
          // 왼쪽: 경험치와 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experienceData.type,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  experienceData.comments,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A8A8A),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top : 4, right: 10),
                child: Text(
                  '+${experienceData.exp} do',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  DateFormat('yy/MM/dd').format(experienceData.earnedDate),
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
        ],
      ),
    );
  }
}