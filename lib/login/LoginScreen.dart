import 'package:flutter/material.dart';
import '/MainScreen.dart'; // MainScreen을 import

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
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

  // Navigate to the main screen after login
  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()), // MainScreen으로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
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
                        text: '두손꼭', // 기본 텍스트 스타일
                        style: TextStyle(
                          fontFamily: 'RixInooAriDuri',
                          fontSize: 46.6,
                          color: Colors.black87,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Do', // "Do" 부분
                            style: TextStyle(
                              color: Color(0xFFF95E39), // 원하는 색으로 변경
                              fontWeight: FontWeight.bold, // 선택적으로 굵게 설정 가능
                            ),
                          ),
                          TextSpan(
                            text: '전!', // 나머지 텍스트
                            style: TextStyle(
                              fontFamily: 'RixInooAriDuri',
                              fontSize: 46.6,
                              color: Colors.black87,
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
                        fontWeight: FontWeight.bold,
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
                            fontSize: 16.0
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xFFC7C7C7), // 기본 테두리 색상
                            width: 1.0, // 기본 테두리 두께
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xFFC7C7C7), // 활성화된 상태에서의 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xFF7879F1), // 포커스 상태에서의 테두리 색상 (여기서는 파란색)
                            width: 2.0, // 포커스 상태에서 테두리 두께
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                           color: Color(0xFFC7C7C7)
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
                            color: Color(0xFFC7C7C7), // 기본 테두리 색상
                            width: 1.0, // 기본 테두리 두께
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xFFC7C7C7), // 활성화된 상태에서의 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xFF7879F1), // 포커스 상태에서의 테두리 색상
                            width: 2.0, // 포커스 상태에서 테두리 두께
                          ),
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
                    onPressed: isButtonActive
                        ? () {
                      // 로그인 버튼 클릭 시 Main 화면으로 이동
                      _navigateToMain();
                    }
                        : null,
                    child: Text(
                      "로그인",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: isButtonActive? Colors.white : Color(0xFFC7C7C7),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // 회원가입 버튼
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.0),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      print("회원가입 버튼 클릭!");
                    },
                    child: Text(
                      "회원가입",
                      style: TextStyle(
                        fontSize: 18.0,
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
    );
  }
}
