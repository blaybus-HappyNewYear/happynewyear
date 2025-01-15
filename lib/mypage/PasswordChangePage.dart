import 'package:flutter/material.dart';
import '/api/auth_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isButtonActive = false;
  bool isHiddenCurrentPassword = true;
  bool isHiddenNewPassword = true;
  bool isHiddenConfirmPassword = true;

  String? errorMessage; // 기존 비밀번호 관련 오류 메시지
  String? errorMessageConfirm; // 새 비밀번호 확인 오류 메시지
  String? errorMessageNewPassword; // 새 비밀번호 유효성 오류 메시지
  String? loggedInPassword; // 로그인된 비밀번호를 저장할 변수
  String? accessToken; // 로그인된 accessToken을 저장할 변수

  final AuthPassword _authPassword = AuthPassword();

  // Update button state when text is entered
  void _updateButtonState() {
    setState(() {
      isButtonActive = _currentPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  // Toggle password visibility
  void _togglePasswordView(String field) {
    setState(() {
      if (field == 'current') {
        isHiddenCurrentPassword = !isHiddenCurrentPassword;
      } else if (field == 'new') {
        isHiddenNewPassword = !isHiddenNewPassword;
      } else if (field == 'confirm') {
        isHiddenConfirmPassword = !isHiddenConfirmPassword;
      }
    });
  }

  // 로그인된 비밀번호 및 accessToken 불러오기
  Future<void> _loadLoggedInData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInPassword = prefs.getString('password') ?? '';
      accessToken = prefs.getString('accessToken') ?? ''; // accessToken 불러오기
    });
  }

  // 비밀번호 확인 로직
  void _checkCurrentPassword() {
    if (_currentPasswordController.text != loggedInPassword) {
      setState(() {
        errorMessage = "현재 비밀번호가 일치하지 않습니다.";
      });
    } else {
      setState(() {
        errorMessage = null; // 일치하면 에러 메시지 제거
      });
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessageConfirm = "새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.";
      });
      return;
    } else {
      setState(() {
        errorMessageConfirm = null; // 일치하면 에러 메시지 제거
      });
    }
  }

  // 비밀번호가 영문 숫자만 포함하는지 확인하는 함수
  bool _isValidPassword(String password) {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(password);
  }

  // 비밀번호 변경 로직
  Future<void> _changePassword() async {
    // 현재 비밀번호 확인
    print("Current Password: ${_currentPasswordController.text}");
    print("New Password: ${_newPasswordController.text}");
    print("Confirm Password: ${_confirmPasswordController.text}");
    if (_currentPasswordController.text != loggedInPassword) {
      setState(() {
        errorMessage = "현재 비밀번호가 일치하지 않습니다.";
      });
      return;
    }

    // 새 비밀번호와 새 비밀번호 확인 일치 여부 확인
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessageConfirm = "새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.";
      });
      return;
    } else {
      setState(() {
        errorMessageConfirm = null;
      });
    }

    // 새 비밀번호가 영문, 숫자만 포함하는지 확인
    if (!_isValidPassword(_newPasswordController.text)) {
      setState(() {
        errorMessageNewPassword = "비밀번호 값은 영문, 숫자만 가능합니다.";
      });
      return;
    } else {
      setState(() {
        errorMessageNewPassword = null;
      });
    }

    // 서버에 비밀번호 변경 요청
    if (accessToken != null) {
      final bool isPasswordChanged = await _authPassword.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
        accessToken!,  // Authorization에 사용될 accessToken
      );

      print("isPasswordChanged: $isPasswordChanged");

      if (isPasswordChanged) {
        // 비밀번호 변경 성공 후, SharedPreferences에 새 비밀번호 저장
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('newPassword', _newPasswordController.text);

        setState(() {
          errorMessage = null; // 기존 비밀번호 관련 에러 메시지 제거
        });

        // 비밀번호 변경 완료 후 홈 화면으로 이동
        _showSuccessDialog();
      } else {
        // 서버에서 실패 메시지 출력
        setState(() {
          errorMessage = "서버에서 비밀번호 변경에 실패했습니다. 다시 시도해주세요.";
        });
      }
    } else {
      setState(() {
        errorMessage = "인증 정보가 유효하지 않습니다.";
      });
    }
  }

  void _showSuccessDialog() {
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
                SizedBox(height: 28),
                Text(
                  "비밀번호 변경 완료",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF565656),
                      height: 1.8,
                    ),
                    children: [
                      TextSpan(text: "비밀번호가 변경되었습니다.\n"),
                      TextSpan(text: "새로운 비밀번호로 로그인 해주시기 바랍니다."),
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
                      onPressed: () {
                        // 홈 화면으로 이동
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text(
                        "확인",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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
  }


  @override
  void initState() {
    super.initState();
    _loadLoggedInData(); // 로그인된 비밀번호 및 accessToken 불러오기
    // Add listeners to text fields
    _currentPasswordController.addListener(_updateButtonState);
    _newPasswordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
    print("Logged in password: $loggedInPassword");
    print("Access Token: $accessToken");
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
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
                      Navigator.pushReplacementNamed(context, '/mypage');
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      "비밀번호 변경",
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
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left:20.0, right: 20.0, top: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "비밀번호 변경" 텍스트
            Text(
              "비밀번호 변경",
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF565656),
              ),
            ),
            SizedBox(height: 10.0),

            // 기존 비밀번호 입력 필드
            _buildPasswordField(
              hintText: "기존 비밀번호를 입력해주세요",
              controller: _currentPasswordController,
              isHidden: isHiddenCurrentPassword,
              togglePasswordView: () {
                _togglePasswordView('current');
              },
            ),
            // 오류 메시지 표시
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ),
            SizedBox(height: 16.0),

            // 새 비밀번호 입력 필드
            _buildPasswordField(
              hintText: "새 비밀번호를 입력해주세요",
              controller: _newPasswordController,
              isHidden: isHiddenNewPassword,
              togglePasswordView: () => _togglePasswordView('new'),
            ),
            // 새 비밀번호 오류 메시지 표시
            if (errorMessageNewPassword != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessageNewPassword!,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ),
            SizedBox(height: 16.0),

            // 새 비밀번호 확인 입력 필드
            _buildPasswordField(
              hintText: "새 비밀번호를 한번 더 입력해주세요",
              controller: _confirmPasswordController,
              isHidden: isHiddenConfirmPassword,
              togglePasswordView: () => _togglePasswordView('confirm'),
            ),
            // 새 비밀번호 확인 오류 메시지
            if (errorMessageConfirm != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessageConfirm!,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ),

            SizedBox(height: 20),

            // 비밀번호 변경 버튼
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
                // 먼저 현재 비밀번호 확인
                _checkCurrentPassword();
                // 현재 비밀번호가 맞으면 변경 작업
                if (errorMessage == null) {
                  _changePassword(); // 비밀번호 변경 로직 처리
                }
              }
                  : null,
              child: Text(
                "비밀번호 변경",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                  color: isButtonActive ? Colors.white : Color(0xFFC7C7C7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 비밀번호 입력 필드 위젯 생성
  Widget _buildPasswordField({
    required String hintText,
    required TextEditingController controller,
    required bool isHidden,
    required VoidCallback togglePasswordView,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(  // hintStyle 설정
          fontFamily: 'Pretendard',
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC7C7C7),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: InkWell(
          onTap: togglePasswordView, // 비밀번호 보이기/숨기기만 처리
          child: Icon(
            isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: isHidden ? Color(0xFFC7C7C7) : Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Color(0xFFC7C7C7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Color(0xFFC7C7C7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Color(0xFF7879F1), width: 2.0),
        ),
      ),
    );
  }
}
