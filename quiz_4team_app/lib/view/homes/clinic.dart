import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_4team_app/view/homes/sign_up_page.dart';
import '../../model/model_list.dart';
import 'bmi.dart';
import '../gps/gps_map.dart';

class Clinic extends StatefulWidget {
  Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  late TextEditingController idController;
  late TextEditingController pwController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  // 로그인 처리 및 예외 다이얼로그
  void handleLogin() {
    String id = idController.text.trim();
    String pw = pwController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      Get.snackbar('경고', 'ID와 비밀번호를 모두 입력해 주세요.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white);
      return;
    }

    String result = AppModel.login(id, pw);

    if (result == 'NO_USER') {
      // 명세 1: 존재하지 않는 유저
      Get.defaultDialog(
        title: '알림',
        middleText: '존재하지 않는 유저',
        textConfirm: 'Exit',
        confirmTextColor: Colors.white,
        buttonColor: Color(0xFF00C9C8),
        onConfirm: () => Get.back(),
      );
    } else if (result == 'WRONG_PASSWORD') {
      // 명세 1: 비밀번호 불일치
      Get.defaultDialog(
        title: '알림',
        middleText: '비밀번호 불일치',
        textConfirm: 'Exit',
        confirmTextColor: Colors.white,
        buttonColor: Color(0xFF00C9C8),
        onConfirm: () => Get.back(),
      );
    } else if (result == 'SUCCESS') {
      idController.clear();
      pwController.clear();
      setState(() {});
    }
  }

  // 로그아웃 처리
  void handleLogout() {
    AppModel.logout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool loggedIn = AppModel.isLoggedIn();
    String currentUserId = AppModel.getCurrentUserId();
    BodyMetrics? metrics = AppModel.getMetrics();

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더 영역
            Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: Color(0xFF00C9C8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Specialties',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Find Your Doctor',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Get.to(() => GpsMap()),
                        icon: Icon(Icons.location_on),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      SizedBox(width: 40),
                      // 로그인 여부에 따른 아이콘 동작 변경
                      IconButton(
                        onPressed: () {
                          if (loggedIn) {
                            Get.to(() => Bmi())?.then((value) => setState(() {}));
                          } else {
                            Get.to(() => SignUpPage())?.then((value) => setState(() {}));
                          }
                        },
                        icon: Icon(loggedIn ? Icons.monitor : Icons.person_add),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 로그인 상태인 경우: 사용자 프로필 정보 박스 표시
            if (loggedIn)
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFEBF7F7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF00C9C8), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, color: Color(0xFF00C9C8), size: 28),
                        SizedBox(width: 8),
                        Text(
                          '$currentUserId님 환영합니다!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C9C8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Color(0xFF00C9C8), thickness: 1),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('키', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            SizedBox(height: 4),
                            Text(
                              metrics != null ? '${metrics.height.round()} cm' : '180 cm',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('몸무게', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            SizedBox(height: 4),
                            Text(
                              metrics != null ? '${metrics.weight.round()} kg' : '80 kg',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('혈액형', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            SizedBox(height: 4),
                            Text(
                              metrics != null ? metrics.bloodType : 'A +',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00C9C8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('로그아웃', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else
              // 로그인 안 된 경우: ID / Password 입력창 표시
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(hintText: 'ID를 입력하세요'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: pwController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Pass Word를 입력하세요'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00C9C8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Log In', style: TextStyle(color: Colors.white)),
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