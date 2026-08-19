import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_4team_app/view/home.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({super.key});

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  // Property
  late TextEditingController useridController;   
  late TextEditingController passwordController; 
  final box = GetStorage();  

  @override
  void initState() {
    super.initState();
    useridController = TextEditingController();
    passwordController = TextEditingController();

    initStorage();  // 함수를 만들어서 box 내용 보관
  }
//========================Storage 의 함수 활용및 종료 시키기====================
  void initStorage(){
    box.write('user', "");
    box.write('password', "");
  }

  @override
  void dispose() {
    disposeStorage();
    super.dispose();
  }
  void disposeStorage(){
    box.erase();
  }
//==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOG IN 화면'),
        centerTitle: true,
        backgroundColor: Color(0xFF00C9C8),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: useridController,
                decoration: InputDecoration(
                  hintText: "ID를 입력하세요",
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
               TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "PassWord를 입력하세요",
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(useridController.text.trim().isEmpty || passwordController.text.trim().isEmpty){
                  errorSnackBar();
                }else{
                  // 비어있지 않으면 다이얼로그 출력
                  _showDialog();
                }setState(() {});
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00C9C8),
                foregroundColor: Colors.white,
                shape: BeveledRectangleBorder()
              ),
              child: Text('Log In')
            ),
          ],
        ),
      ),
    );
  }//build

//========================Function===============================
//=========================Get Snackbar======================
  void errorSnackBar(){
    Get.snackbar(
      "경고", 
      "사용자의 ID와 암호를 입력하세요!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white
      );
  }

//============================DiaLog===============================
  void _showDialog(){
    Get.defaultDialog(
      title: '환영 합니다.',
      middleText: '확인 되었습니다.',
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed:() {
            saveStorage();
            //Dialog 를 종료시킨다.
            Get.back();
            // Dialog를 종료시키고 Secondpage 를 실행
            // get.back 이 먼저 나온뒤 get.to를 실행시켜야한다.
            Get.to(Home());
          }, 
          child: Text('Exit'))
      ]
    );
  }
  void saveStorage(){
    // write =  저장한다는 개념
    box.write('p_userId', "3team");
    box.write('p_password', "1234");
  }
}//class