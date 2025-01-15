import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/api/auth_profile.dart';

// 프로필 이미지 리스트
const List<String> profileImages = [
  'assets/images/man-01.png',
  'assets/images/man-02.png',
  'assets/images/man-03.png',
  'assets/images/man-04.png',
  'assets/images/woman-01.png',
  'assets/images/woman-02.png',
  'assets/images/woman-03.png',
  'assets/images/woman-04.png'
];

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  int? _selectedProfileIndex;
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // 프로필 상태를 SharedPreferences에서 불러오는 함수
  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    AuthProfile authProfile = AuthProfile();

    // 서버에서 프로필 이미지 번호 가져오기
    int? serverImgNumber = await authProfile.getProfileFromServer();

    if (serverImgNumber != null) {
      setState(() {
        _selectedProfileIndex = serverImgNumber;
      });

      // SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('imgNumber', serverImgNumber);

      print('Profile loaded from server: $_selectedProfileIndex');
    } else {
      print('Failed to load profile from server');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 프로필 상태를 SharedPreferences에 저장하는 함수
  Future<void> _saveProfile(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('imgNumber', index); // 프로필 인덱스를 저장
    print('Selected new profile imgNumber: $index');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async { },
      child: _isLoading
          ? SizedBox(
        height: 72,
        width: 72,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3F9FC6),
          ),
        ),
      )
          : SizedBox(
        height: 72,
        width: 72,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFF6F6F6),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                height: 52,
                width: 52,
                color: Color(0xFFF6F6F6),
                child: ClipOval(
                  child: Padding(
                    padding: EdgeInsets.all(3), // 이미지 내부 여백 설정
                    child: Image.asset(
                      profileImages[_selectedProfileIndex ?? 0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 52,
              bottom: 0,
              child: SizedBox(
                height: 20,
                width: 20,
                child: Stack(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: const Color(0xFFEAEAEA),
                      ),
                      onPressed: () async {
                        int? newIndex = await _showProfileChangeDialog(context, _selectedProfileIndex ?? 0);
                        if (newIndex != null) {
                          setState(() {
                            _selectedProfileIndex = newIndex;
                          });
                          await _saveProfile(newIndex);

                          // 서버에 프로필 업데이트 호출
                          AuthProfile authProfile = AuthProfile();
                          bool success = await authProfile.updateProfileOnServer(newIndex);
                          if (success) {
                            print('프로필이 서버에 업데이트되었습니다.');
                          } else {
                            print('서버 업데이트 실패');
                          }
                        }
                      },
                      child: Container(),
                    ),
                    Center(
                      child: IconButton(
                        icon: Image.asset(
                          'assets/icons/Pencil.png',
                          width: 12,
                          height: 12,
                        ),
                        onPressed: () async {
                          int? newIndex = await _showProfileChangeDialog(context, _selectedProfileIndex ?? 0);
                          if (newIndex != null) {
                            setState(() {
                              _selectedProfileIndex = newIndex;
                            });
                            await _saveProfile(newIndex);

                            // 서버에 프로필 업데이트 호출
                            AuthProfile authProfile = AuthProfile();
                            bool success = await authProfile.updateProfileOnServer(newIndex);
                            if (success) {
                              print('프로필이 서버에 업데이트되었습니다.');
                            } else {
                              print('서버 업데이트 실패');
                            }
                          }
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _showProfileChangeDialog(BuildContext context, int initialIndex) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int tempIndex = initialIndex; // 서버에서 불러온 값으로 설정
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 266,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 28.0),
                      child: Text(
                        '프로필 변경', // 텍스트 내용
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black, // 텍스트 색상
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    // 프로필 이미지 선택 영역 (세 개씩 보여주기)
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 이전 이미지로 이동하는 버튼
                          Container(
                            width: 16,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tempIndex = (tempIndex - 1 + profileImages.length) % profileImages.length;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent, // 배경 투명
                                shadowColor: Colors.transparent,     // 그림자 제거
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // 세 개의 이미지를 가로로 보여주기
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                int imageIndex = (tempIndex + index - 1) % profileImages.length;

                                // 가운데 이미지를 선택했을 때 border 색상을 다르게 설정
                                bool isSelected = (tempIndex == imageIndex); // 가운데 이미지가 선택된 경우
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // 중앙 이미지만 선택되게 설정
                                      tempIndex = imageIndex;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFF6F6F6),
                                      border: Border.all(
                                        color: isSelected ? Color(0xFF0C8CE9) : Color(0xFFEAEAEA), // 가운데 선택된 경우 다른 border 색상
                                        width: isSelected ? 2 : 1.27, // 가운데 선택된 경우 border 두께를 조금 더 두껍게
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Padding(
                                        padding: EdgeInsets.all(10), // 이미지 내부 여백 설정
                                        child: Image.asset(
                                          profileImages[imageIndex],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          // 다음 이미지로 이동하는 버튼
                          Container(
                            width: 16,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tempIndex = (tempIndex + 1) % profileImages.length;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent, // 배경 투명
                                shadowColor: Colors.transparent,     // 그림자 제거
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 26),
                    // 확인 버튼
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF95E39),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(310, 52),
                          maximumSize: Size(310, 52),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(tempIndex);  // 다이얼로그 닫기
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}