import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_ex2_app/model/user_info.dart';

// Second 페이지 import
// import 'second.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController userIdController;
  late TextEditingController passwordController;

  // GetStorage 객체
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    userIdController = TextEditingController();
    passwordController = TextEditingController();

    // 초기 유저 데이터 등록
    initUsers();
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 유저 정보 저장
  void initUsers() {
    final Map<String, String> userList = {
      'human': '1234',
      'user1': '1111',
    };

    box.write('userMap', jsonEncode(userList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'CINE Log',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const Text(
            '영화를 고르고, 예매하고, 기록하는 하나의 앱',
          ),
          const SizedBox(height: 100),

          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.lock),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: checkData,
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }

  // 로그인 정보 확인
  void checkData() {
    final String inputId = userIdController.text.trim();
    final String inputPw = passwordController.text.trim();

    if (inputId.isEmpty || inputPw.isEmpty) {
      errorSnackBar();
      return;
    }

    // GetStorage에서 JSON String 읽기
    String? rawData = box.read<String>('userMap');

    // 데이터가 없다면 초기 데이터 생성
    if (rawData == null) {
      initUsers();
      rawData = box.read<String>('userMap');
    }

    if (rawData != null) {
      // JSON String -> Map
      final Map<String, dynamic> userMap = jsonDecode(rawData);

      // 아이디와 비밀번호 확인
      if (userMap.containsKey(inputId) &&
          userMap[inputId].toString() == inputPw) {
        _showDialog();
        return;
      }
    }

    // 로그인 실패
    checkSnackBar();
  }

  // 로그인 성공 Dialog
  void _showDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('환영합니다.'),
          content: const Text('확인 되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                final String id = userIdController.text.trim();
                UserInfo user = UserInfo(userID: id);
                // 로그인한 사용자 ID 저장
                if(box.hasData(id)){
                  user = box.read(id);
                }

                userIdController.clear();
                passwordController.clear();

                // Dialog 닫기
                Get.back();
                Get.back(result: user);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // 입력값이 비어있을 때
  void errorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사용자 ID와 암호를 입력하세요.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  // 로그인 실패
  void checkSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사용자 ID나 암호가 일치하지 않습니다.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
