import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Bottom_Navigation.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> filteredPosts = [];
  bool isLoading = false;
  bool hasMore = true;
  bool isSearching = false;
  int currentPage = 1;
  int endPage = 1; // 서버에서 받은 마지막 페이지를 저장
  final int postsPerPage = 6;
  final String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5zdWtpbSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE3MzY2ODM5NDF9.aDaV167ZGbN5ntJaTUVYj622KsMaQbRFoZJE7J3YNNM';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore) {
        fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchPosts() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    // 게시글이 없을 때
    // try {
    //   // 서버 요청 부분을 주석 처리
    //   // final response = await http.get(...);
    //   // if (response.statusCode == 200) { ... }
    //
    //   // 빈 데이터 강제 설정
    //   setState(() {
    //     posts = [];
    //     filteredPosts = posts;
    //     hasMore = false;
    //   });
    // } catch (e) {
    //   print("Error fetching posts: $e");
    // } finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }

    try {
      final response = await http.get(
        Uri.parse('http://52.78.9.87:8080/board?page=$currentPage&size=$postsPerPage'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData.containsKey('posts')) {
          final List<dynamic> postsData = jsonData['posts'];

          setState(() {
            if(postsData.isEmpty){
              hasMore=false;
            }else{
              posts.addAll(postsData.map((e) {
                return {
                  'id': e['id'] ?? 0,
                  'title': e['title'] ?? '제목 없음',
                  'date': e['createdAt'] ?? '날짜 없음',
                  'views': e['views'] ?? 0,
                };
              }).toList());
              filteredPosts=posts;
              // 페이지네이션 처리
              currentPage++;
              endPage = jsonData['endPage'] ?? currentPage; // 서버에서 endPage 갱신
              if (currentPage > endPage) {
                hasMore = false;
              }
            }
          });
        } else {
          throw Exception('Posts key not found in response');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error fetching posts: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글을 불러오지 못했습니다. 다시 시도해주세요.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  void filterPosts(String query) {
    final filtered = posts.where((post) {
      final title = post['title'].toLowerCase();
      final search = query.toLowerCase();
      return title.contains(search);
    }).toList();

    setState(() {
      filteredPosts = filtered;
    });
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      filteredPosts = posts;
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "게시판",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              isSearching ? 'assets/icons/search.png' : 'assets/icons/search.png',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) clearSearch();
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 56.0 : 1.0),
          child: Container(
            color: Colors.grey.shade300,
            child: isSearching
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: filterPosts,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력해주세요.',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        'assets/icons/close.png',
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        searchController.clear();
                        filterPosts('');
                      },
                    ),
                  ),
                ),
              ),
            )
                : Container(
              height: 2.0,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : posts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/listx_icon.png",
                  ),
                  SizedBox(height: 8), // 아이콘과 텍스트 사이 간격
                  Text(
                    '아직 게시글이 없어요 :(',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : filteredPosts.isEmpty
                ? Center(
              child: Text(
                '검색 결과가 없습니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              itemCount: filteredPosts.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredPosts.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final post = filteredPosts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        post['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            post['date'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '조회수: ${post['views']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              postId: post['id'],
                              accessToken: accessToken,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 3),
    );
  }
}


class DetailPage extends StatefulWidget {
  final int postId;
  final String accessToken;

  DetailPage({required this.postId, required this.accessToken});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? post;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPostDetails(widget.postId);
  }

  Future<void> fetchPostDetails(int postId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://52.78.9.87:8080/board/$postId'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          post = {
            'id': data['id'] ?? 0,
            'title': data['title'] ?? '제목 없음',
            'author': data['author'] ?? '작성자 없음',
            'createdAt': data['createdAt'] ?? '날짜 없음',
            'content': data['content'] ?? '내용이 없습니다.',
          };
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load post details');
      }
    } catch (e) {
      print("Error fetching post details: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글을 불러오지 못했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.only(top: 5.0),
          icon: Image.asset(
            'assets/icons/back.png',
          ),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
        title: Text(
          "게시판",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // 보더의 높이를 설정
          child: Container(
            color: Color(0xFFEAEAEA), // 보더 색상
            height: 2.0, // 보더 두께
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : post == null
          ? Center(
        child: Text(
          '게시글 정보를 불러올 수 없습니다.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Pretendard',
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목, 작성자, 날짜 영역
          Container(
            color: Colors.white, // 배경색 흰색 유지
            child: Padding(
              padding: const EdgeInsets.all(25.0), // 텍스트에 패딩 추가
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post!['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${post!['author']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${post!['createdAt']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.shade300,
            height: 1.0,
          ),
          // 본문 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post!['content'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6, // 줄 간격 추가
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),

                    Text(
                      "목록 스크롤 확인을 위한 텍스트",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6, // 줄 간격 추가
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Phasellus lacinia velit a feugiat placerat. Nulla facilisi.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Curabitur eget eros vitae magna vehicula sodales non vel purus.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Praesent nec justo euismod, viverra metus at, facilisis augue.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Fusce feugiat dolor ac libero interdum, sit amet lacinia nisl tristique.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Donec dictum lectus a ipsum lacinia, ac dictum metus volutpat.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Etiam quis sapien id risus convallis feugiat ut at velit.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Pellentesque id orci in sapien pretium convallis.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Nunc vulputate augue et justo tempus, ut vehicula nisl mollis.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sed tristique tortor in libero fermentum, sit amet accumsan odio efficitur.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Pretendard',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}