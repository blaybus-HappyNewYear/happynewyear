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
                    child: Text(
                      "두손꼭Do전!",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "두헨즈 직원들의 능률향상",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 입력 필드
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: <Widget>[
                  // ID 입력 필드
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
                      hintText: "아이디를 입력하세요.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  // Password 입력 필드
                  TextFormField(
                    controller: _passwordController,
                    obscureText: isHiddenPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
                      hintText: "비밀번호를 입력하세요.",
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          isHiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
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
                      ),
                      Text(
                        "로그인 유지",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  // 로그인 버튼
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.0),
                      backgroundColor: isButtonActive ? Colors.orangeAccent : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // 회원가입 버튼
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.0),
                      side: BorderSide(color: Colors.orangeAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () {
                      print("회원가입 버튼 클릭!");
                    },
                    child: Text(
                      "회원가입",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.orangeAccent,
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
