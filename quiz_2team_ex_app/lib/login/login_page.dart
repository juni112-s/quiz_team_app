import 'dart:convert'; // jsonEncode, jsonDecode 사용을 위해 추가
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController userIdController;
  late TextEditingController passwordController;

  // GetStorage 객체 생성
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    userIdController = TextEditingController();
    passwordController = TextEditingController();

    // 초기 유저 데이터 등록
    initUsers();
  }

  // 유저 정보 저장 함수 (JSON String 형태로 안전하게 저장)
  void initUsers() {
    Map<String, String> userList = {
      'human': '1234',
      'user1': '1111',
    };

    // Map을 String(JSON)으로 변환해서 저장해야 타입 오류가 나지 않습니다.
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
            style: TextStyle(fontSize: 30),
          ),
          const Text('영화를 고르고, 예매하고, 기록하는 하나의 앱'),
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

  // --- Functions ---
  void checkData() {
    String inputId = userIdController.text.trim();
    String inputPw = passwordController.text.trim();

    if (inputId.isEmpty || inputPw.isEmpty) {
      errorSnackBar();
      return;
    }

    // 1. GetStorage에서 저장된 String데이터 읽어오기
    String? rawData = box.read('userMap');

    // 만약 읽어온 데이터가 없다면 그 자리에서 다시 한 번 저장 시도
    if (rawData == null) {
      initUsers();
      rawData = box.read('userMap');
    }

    if (rawData != null) {
      // 2. String을 Map으로 디코딩
      Map<String, dynamic> userMap = jsonDecode(rawData);

      // 3. 아이디와 비밀번호 일치 확인
      if (userMap.containsKey(inputId) &&
          userMap[inputId].toString() == inputPw) {
        _showDialog();
        return;
      }
    }

    // 위 조건에 맞지 않으면 로그인 실패
    checkSnackBar();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('환영합니다.'),
          content: const Text('확인 되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                String id = userIdController.text.trim();

                box.write('userId', id);

                userIdController.clear();
                passwordController.clear();

                Get.back(); // 다이얼로그 닫기

                Get.to(() => const Home());
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  void errorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사용자 ID와 암호를 입력 하세요'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

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