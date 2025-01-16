import 'package:flutter/material.dart';
import '/api/auth_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String fcmToken;
  Login({required this.fcmToken});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authLogin = AuthLogin();

  String? idErrorMessage;
  String? passwordErrorMessage;
  bool isIdError = false;
  bool isPasswordError = false;
  String? errorMessage;

  // Password visibility state
  bool isHiddenPassword = true;

  // Checkbox state for "로그인 유지"
  bool isRememberMe = false;

  // Button active state
  bool isButtonActive = false;

  // Toggle password visibility
  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  // Update button state when input changes
  void _updateButtonState() {
    setState(() {
      // If both fields are filled, enable button
      isButtonActive = _idController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  //아이디 양식 일치하는지 확인 (영문 + 숫자)
  bool _isValidId(String id) {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(id);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Add listeners to text fields to update button state when text is entered
    _idController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // Dispose controllers when widget is destroyed
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 저장된 사용자 정보 불러오기
  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isRememberMe = prefs.getBool('isRememberMe') ?? false;
      if (isRememberMe) {
        _idController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  // "로그인 유지" 상태 저장
  _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRememberMe', isRememberMe);
    prefs.setString('username', _idController.text);
    prefs.setString('password', _passwordController.text);
  }

  Future<void> _sendFcmToken(String accessToken) async {
    try {
      final response = await authLogin.sendFcmToken(widget.fcmToken, accessToken);
      if (response) {
        print("FCM 토큰 전송 성공");
      } else {
        print("FCM 토큰 전송 실패");
      }
    } catch (e) {
      print("FCM 토큰 전송 중 오류 발생: $e");
    }
  }

  // Navigate to the main screen after login
  void _navigateToMainScreen() {
    Navigator.pushReplacementNamed(
        context,
        '/mainpage'
    ); // MainScreen으로 이동
  }

  bool isLoading = false; // 로딩 상태 변수 추가

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final username = _idController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final tokens = await authLogin.signIn(username, password);

      if (tokens != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', tokens['accessToken'] ?? '');

        // FCM 토큰 전송
        final success = await authLogin.sendFcmToken(widget.fcmToken, tokens['accessToken'] ?? '');

        if (!success) {
          // FCM 토큰 전송 실패 시에도 메인 페이지로 이동할지 판단
          print("FCM 토큰 전송 실패, 하지만 메인 페이지로 이동");
        }

        if (isRememberMe) {
          await _saveUserData();
        }

        // MainPage로 이동
        Navigator.pushReplacementNamed(context, '/mainpage');
      } else {
        setState(() {
          errorMessage = "아이디 또는 비밀번호가 잘못되었습니다.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "로그인 중 오류가 발생했습니다. 다시 시도해주세요.";
      });
      print("Login error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 큰 제목과 소제목
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          text: '두손꼭',
                          style: TextStyle(
                            fontFamily: 'RixInooAriDuri',
                            fontSize: 46.6,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Do',
                              style: TextStyle(
                                color: Color(0xFFF95E39),
                              ),
                            ),
                            TextSpan(
                              text: '전!', // 나머지 텍스트
                              style: TextStyle(
                                fontFamily: 'RixInooAriDuri',
                                fontSize: 46.6,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.0),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "두헨즈 직원들의 능률향상",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 입력 필드
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 48.0, right: 20.0, bottom: 40.0),
                child: Column(
                  children: <Widget>[
                    // ID 입력 필드
                    Container(
                      height: 52.0,
                      child: TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                          hintText: "아이디를 입력하세요.",
                          hintStyle: TextStyle(
                              color: Color(0xFFC7C7C7),
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: isIdError ? Color(0xFFFF6969) : Color(0xFFC7C7C7), // 기본 테두리 색상
                              width: 1.0, // 기본 테두리 두께
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: isIdError ? Color(0xFFFF6969) : Color(0xFFC7C7C7), // 활성화된 상태에서의 테두리 색상
                              width: 1.0, // 테두리 두께
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: isIdError ? Color(0xFFFF6969) : Color(0xFF7879F1), // 포커스 상태에서의 테두리 색상
                              width: 2.0, // 포커스 상태에서 테두리 두께
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    // ID 오류 메시지
                    if (idErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            idErrorMessage!,
                            style: TextStyle(
                              color: Color(0xFFFF6969),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    // Password 입력 필드
                    Container(
                      height: 52.0,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: isHiddenPassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                          hintText: "비밀번호를 입력하세요.",
                          hintStyle: TextStyle(
                              color: Color(0xFFC7C7C7),
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0
                          ),
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                                isHiddenPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: isHiddenPassword ? Color(0xFFC7C7C7) : Colors.black
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: isPasswordError ? Color(0xFFFF6969) : Color(0xFFC7C7C7), // 기본 테두리 색상
                              width: 1.0, // 기본 테두리 두께
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: isPasswordError ? Color(0xFFFF6969) : Color(0xFFC7C7C7), // 활성화된 상태에서의 테두리 색상
                              width: 1.0, // 테두리 두께
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: isPasswordError ? Color(0xFFFF6969) : Color(0xFF7879F1), // 포커스 상태에서의 테두리 색상
                              width: 1.0, // 포커스 상태에서 테두리 두께
                            ),
                          ),
                          errorBorder: OutlineInputBorder( // 오류 상태의 테두리 색상
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.red, // 오류 색상
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // password 오류 메시지
                    if (passwordErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            passwordErrorMessage!,
                            style: TextStyle(
                              color: Color(0xFFFF6969),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    // 로그인 유지 체크박스
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isRememberMe,
                          onChanged: (value) {
                            setState(() {
                              isRememberMe = value!;
                            });
                          },
                          activeColor: Color(0xFFF95E39), // 체크박스 선택된 상태 색상 (주황색)
                          checkColor: Colors.white, // 체크된 상태의 체크 표시 색상 (흰색)
                        ),
                        Text(
                          "로그인 유지",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // 로그인 버튼
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.0),
                        backgroundColor: isButtonActive ? Color(0xFFF95E39) : Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: isButtonActive ? _handleLogin : null,
                      child: isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        "로그인",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: isButtonActive ? Colors.white : Color(0xFFC7C7C7),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // 회원가입 버튼
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.0),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed:() {    // AlertDialog를 띄우기 위해 showDialog 사용
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.white,
                              child: Container(
                                height: 234.0,
                                width: 350.0,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Text("회원가입안내",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black)
                                    ),
                                    SizedBox(height: 16),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          height: 1.8,
                                        ),
                                        children: [
                                          TextSpan(text: "회원가입 및 정보를 잊어버리신 경우에는\n"),
                                          TextSpan(text: "담당자에게 문의해주시기 바랍니다."),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 22),
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
                                          onPressed: () { Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "확인",
                                            style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700
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
                      child: Text(
                        "회원가입",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF95E39),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}