import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/model_list.dart';
import 'bmi.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController idController;
  late TextEditingController pwController;
  late TextEditingController pwConfirmController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();
    pwConfirmController = TextEditingController();
  }

  void handleSignUp() {
    String id = idController.text.trim();
    String pw = pwController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      Get.snackbar('경고', '모든 항목을 입력해 주세요.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white);
      return;
    }

    // 명세 4: 가입 최종 확인 메세지 발송
    Get.defaultDialog(
      title: '확인',
      middleText: '정말 $id로 가입하시겠습니까?',
      textConfirm: '예',
      textCancel: '아니오',
      confirmTextColor: Colors.white,
      buttonColor: Color(0xFF00C9C8),
      onConfirm: () {
        Get.back(); // 다이얼로그 닫기
        AppModel.registerUser(id, pw, id, '');

        // 명세 4: 회원가입 직후 초기 설정을 위해 Bmi 페이지로 이동
        Get.off(() => Bmi());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        title: Text('회원가입', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: '사용할 ID'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(labelText: '사용할 비밀번호'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: pwConfirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호 확인'),
            ),
            SizedBox(height: 28),
            ElevatedButton(
              onPressed: handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00C9C8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('가입하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}