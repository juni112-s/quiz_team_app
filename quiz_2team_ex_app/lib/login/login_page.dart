import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_ex2_app/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // GetStorage객체 작성
  final box = GetStorage();
  late TextEditingController idController;
  late TextEditingController passwordController;

  

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();

  }
  

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CINE Log',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            Text('영화를 고르고, 예매하고, 기록하는 하나의 앱'),
            SizedBox(height: 70,),
            Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(
                      hintText: "아이디",
                      border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                      hintText: "비밀번호",
                      border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                checkData();
              }, 
              child: Text('로그인')
            ),
          ],
        ),
      ),
    );
  }

    //========================Funtion===================


// ==================== 로그인 검증 로직 ====================
  void checkData() {
    String inputId = idController.text.trim();
    String inputPw = passwordController.text.trim();

    // 1. 미입력 시 경고 스낵바
    if (inputId.isEmpty || inputPw.isEmpty) {
      errorSnackBar();
      return;
    }

    // 2. ID/비밀번호 검증 (예: 관리자 계정 또는 저장된 가입 정보 비교)
    if (inputId == '1' && inputPw == '1') {
      _showDialog(); // 로그인 성공 다이얼로그
    } else {
      checkSnackBar(); // 불일치 오류 스낵바
    }
  }

  // 🔴 1. 미입력 경고 스낵바 (Get.snackbar)
  void errorSnackBar() {
    Get.snackbar(
      '경고',
      '사용자 ID와 암호를 입력하세요.',
      snackPosition: SnackPosition.BOTTOM, // 하단 표시
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
    );
  }

  // 🔵 2. ID/비밀번호 불일치 오류 스낵바 (Get.snackbar)
  void checkSnackBar() {
    Get.snackbar(
      '오류',
      '사용자 ID나 암호가 일치하지 않습니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
    );
  }

  // 🟣 3. 로그인 성공 환영 다이얼로그 (Get.defaultDialog + GetStorage)
  void _showDialog() {
    Get.defaultDialog(
      title: "환영합니다",
      middleText: "신원이 확인되었습니다.",
      textConfirm: "OK",
      buttonColor: Colors.deepPurple,
      confirmTextColor: Colors.white,
      barrierDismissible: false, // 다이얼로그 바깥 클릭 방지
      onConfirm: () {
        String id = idController.text.trim();

        // ① GetStorage에 로그인 데이터 저장
        box.write('userId', id);
        box.write('isLoggedIn', true);

        // ② 입력 텍스트 필드 초기화
        idController.text = "";
        passwordController.text = "";

        // ③ 다이얼로그 닫기
        Get.back();

        // ④ 메인 화면으로 전환 (스택 삭제)
        Get.offAll(() => Home());
      },
    );
  }
}