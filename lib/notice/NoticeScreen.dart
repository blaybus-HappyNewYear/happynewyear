import 'package:flutter/material.dart';
import '/Bottom_Navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '게시판',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BoardPage(),
    );
  }
}

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // 게시글 데이터
  List<Map<String, dynamic>> posts = [
    {'id': 1, 'title': 'AAA프로젝트 신설 🔔', 'date': '2025-01-05', 'views': 13},
    {'id': 2, 'title': '잡초이스 공고 🔔', 'date': '2024-12-05', 'views': 10},
    {'id': 3, 'title': '프로젝트 일정 안내', 'date': '2024-12-08', 'views': 25},
    {'id': 4, 'title': '휴가 일정 공지', 'date': '2024-12-17', 'views': 18},
    {'id': 5, 'title': '공지사항 업데이트', 'date': '2024-12-19', 'views': 6},
    {'id': 6, 'title': '휴가 일정 공지1', 'date': '2024-12-25', 'views': 15},
    {'id': 7, 'title': '휴가 일정 공지2', 'date': '2024-11-30', 'views': 9},
    {'id': 8, 'title': '휴가 일정 공지3', 'date': '2024-11-22', 'views': 5},
    {'id': 9, 'title': '휴가 일정 공지4', 'date': '2024-11-20', 'views': 12},
    {'id': 10, 'title': '휴가 일정 공지5', 'date': '2024-11-12', 'views': 2},
    {'id': 11, 'title': '휴가 일정 공지6', 'date': '2024-11-08', 'views': 3},
    {'id': 12, 'title': '휴가 일정 공지7', 'date': '2024-10-28', 'views': 14},
    {'id': 13, 'title': '휴가 일정 공지8', 'date': '2024-10-15', 'views': 7},
    {'id': 14, 'title': '휴가 일정 공지9', 'date': '2024-10-12', 'views': 3},
    {'id': 15, 'title': '휴가 일정 공지10', 'date': '2024-10-10', 'views': 9},
    {'id': 16, 'title': '휴가 일정 공지11', 'date': '2024-10-1', 'views': 11},


  ];

  // 검색어 필터링된 게시글 목록
  List<Map<String, dynamic>> filteredPosts = [];

  // 검색어 상태 관리
  String searchQuery = '';

  // 페이지 상태관리
  int currentPage=1;
  final int postsPerPage=5;//화면에 보여줄 최대 목록 개수

  @override
  void initState() {
    super.initState();
    filteredPosts = posts; // 초기에는 모든 게시글 표시
  }

  // 검색 기능
  void filterPosts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredPosts = posts.where((post) {
        return post['title'].toLowerCase().contains(searchQuery) ||
            post['date'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    // 현재 페이지에 해당하는 목록 불러오기
    final startIndex=(currentPage-1)*postsPerPage;
    final endIndex=startIndex+postsPerPage;
    final currentPosts=filteredPosts.sublist(
      startIndex,
      endIndex>filteredPosts.length?filteredPosts.length:endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "게시판",
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
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterPosts(value),
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // 게시글 목록
          Expanded(
            child: ListView.builder(
              itemCount: currentPosts.length,
              itemBuilder: (context, index) {
                final post = currentPosts[index];
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text('${post['date']}'),
                  trailing: Text('조회수: ${post['views']}'),
                );
              },
            ),
          ),

          //페이지네이션 버튼
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ?(){
                    setState(() {
                      currentPage--;
                    });
                  }
                      :null,
                ),

                for (int i=1;i<=(filteredPosts.length/postsPerPage).ceil(); i++)
                  TextButton(
                    onPressed: (){
                      setState(() {
                        currentPage=i;
                      });
                    },
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: currentPage==i?Colors.blue:Colors.black,
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: currentPage<(filteredPosts.length/postsPerPage).ceil()
                      ?(){
                    setState(() {
                      currentPage++;
                    });
                  }
                      :null,
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 3),
    );
  }
}
