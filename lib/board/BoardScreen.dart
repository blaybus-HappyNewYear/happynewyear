import 'package:flutter/material.dart';
import '/api/auth_boardlist.dart';
import '../Bottom_Navigation.dart';
import '/board/BoardDetail.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<Post> posts = []; // 게시글 리스트
  List<Post> filteredPosts = []; // 검색된 게시글 리스트
  bool isLoading = true; // 로딩 상태를 관리하는 변수
  late AuthBoardlist authBoardlist;
  TextEditingController searchController = TextEditingController(); // 검색어 입력을 위한 컨트롤러
  bool isSearchEnabled = false; // 검색바 활성화 여부

  @override
  void initState() {
    super.initState();
    authBoardlist = AuthBoardlist(); // AuthBoardlist 객체 초기화

    // 데이터 로딩
    _loadPosts();
  }

  // 데이터를 로드하는 함수
  Future<void> _loadPosts() async {
    try {
      // getBoardListContent() 메서드를 호출하여 데이터 가져오기
      final response = await authBoardlist.getBoardListContent();

      if (response != null && response.posts.isNotEmpty) {
        setState(() {
          posts = response.posts; // 받아온 게시글로 posts 업데이트
          filteredPosts = posts; // 검색된 게시글도 처음에는 전체 게시글로 설정
          isLoading = false; // 로딩이 끝났으므로 false로 설정
        });
      } else {
        setState(() {
          isLoading = false; // 로딩 종료
          filteredPosts = []; // 게시글이 없으면 빈 리스트
        });
        print("게시글 데이터가 없습니다.");
      }
    } catch (error) {
      setState(() {
        isLoading = false; // 로딩 종료
      });
      print("게시글을 불러오는 중 오류가 발생했습니다: $error");
    }
  }

  // 검색어에 맞는 게시글을 필터링하는 함수
  void _filterPosts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPosts = posts; // 검색어가 비었으면 전체 게시글을 다시 표시
      });
    } else {
      final filtered = posts.where((post) {
        final titleLower = post.title.toLowerCase();
        final queryLower = query.toLowerCase();
        return titleLower.contains(queryLower); // 제목에 검색어가 포함되면 true
      }).toList();

      setState(() {
        filteredPosts = filtered; // 필터링된 게시글로 업데이트
      });
    }
  }

  // 검색 아이콘 클릭시 활성화/비활성화 처리
  void _toggleSearch() {
    setState(() {
      isSearchEnabled = !isSearchEnabled; // 검색 바의 활성화 여부를 토글
      if (!isSearchEnabled) {
        searchController.clear(); // 검색 취소시 텍스트 필드를 초기화
        filteredPosts = posts; // 검색 취소시 전체 게시글을 다시 표시
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top:10.0),
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
        actions: [
          IconButton(
            icon: Icon(
              isSearchEnabled ? Icons.close : Icons.search, // 검색 상태에 따라 아이콘 변경
              color: Colors.black,
            ),
            onPressed: _toggleSearch, // 아이콘 클릭시 토글
          ),
        ],
        bottom: isSearchEnabled
            ? PreferredSize(
          preferredSize: Size.fromHeight(56.0), // 검색바 높이 설정
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterPosts, // 검색어 변경시마다 필터링
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ),
          ),
        )
            : PreferredSize(
          preferredSize: Size.fromHeight(2.0), // 높이를 2.0으로 설정
          child: Container(
            color: Color(0xFFEAEAEA), // 구분선 색상 설정
            height: 2.0, // 라인의 두께
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 화면
          : Container(
        color: Colors.white,
        child: filteredPosts.isNotEmpty
            ? ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return Column(
              children: [
                ListTile(
                  title: Text(post.title),
                  subtitle: Text(
                      "조회수: ${post.views} / 작성일: ${post.createdAt}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardDetail(post.id.toString()),
                      ),
                    ).then((_) {
                      // 돌아왔을 때 게시글 목록을 새로 고침
                      _loadPosts();  // 게시글 목록을 다시 로드하여 최신 정보를 반영
                    });
                  },
                ),
                Divider(
                  color: Color(0xFFEAEAEA),
                  thickness: 0.5,
                ), // 각 항목 사이에 구분선 추가
              ],
            );
          },
        )
            : Center(child: Text("검색 결과가 없습니다.")), // 검색 결과가 없을 때
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 3),
    );
  }
}