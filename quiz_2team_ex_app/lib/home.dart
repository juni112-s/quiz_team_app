import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_ex2_app/login/advence_page.dart';
import 'package:team_ex2_app/login/login_page.dart';
import 'package:team_ex2_app/login/mypage.dart';
import 'package:team_ex2_app/login/review_page.dart';
import 'package:team_ex2_app/login/search_page.dart';
import '../moviefile/action_page.dart';
import '../moviefile/thriller_page.dart';
import '../moviefile/romance_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final box = GetStorage();
  late String userID;
  late TabController controller;
  bool isLoggedIn =false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    userID = box.read('userID') ?? '게스트';
    isLoggedIn = box.read('isLoggedIn') ?? false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cine Log'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Get.to(SearchPage());
            },
          ),
        ],
        bottom: TabBar(
          controller: controller,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs:[
            Tab(text: '액션'),
            Tab(text: '스릴러/공포'),
            Tab(text: '로맨스'),
          ],
        ),
      ),

      // 좌측 드로어
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              color: Colors.deepPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 45, color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // ⭐️ 3. 로그인 여부에 따른 유저 이름 표시
                        isLoggedIn ? '$userID님 환영합니다.' : '로그인이 필요합니다.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      // ⭐️ 4. 로그인/로그아웃 버튼 분기 처리
                      ElevatedButton(
                        onPressed: () {
                          if (isLoggedIn) {
                            handleLogout(); // 로그인 상태면 로그아웃 팝업 실행
                          } else {
                            Get.to(() => const LoginPage()); // 비로그인이면 로그인 창으로
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          shape: StadiumBorder(),
                        ),
                        child: Text(isLoggedIn ? '로그아웃':'로그인'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMenuButton(Icons.person_outline, '마이페이지',() => Get.to(() => Mypage()),),
                  SizedBox(height: 10),
                  _buildMenuButton(Icons.star_outline, '리뷰 작성',() => Get.to(() => ReviewPage())),
                  SizedBox(height: 10),
                  _buildMenuButton(Icons.confirmation_number_outlined, '예매하기',() => Get.to(() => AdvencePage()),),
                ],
              ),
            ),
          ],
        ),
      ),

      // 탭바 3개 연결
      body: TabBarView(
        controller: controller,
        children: [
          Actionpage(),  // 액션 탭
          Thrillerpage(), // 스릴러/공포 탭
          Romancepage(),  // 로맨스 탭
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
  void handleLogout(){
    Get.defaultDialog(
      title: '로그아웃',
      middleText: '정말 로그아웃 하시겠습니까?',
      textConfirm: '확인',
      textCancel: '취소',
      confirmTextColor: Colors.white,
      buttonColor: Colors.deepPurple,
      onConfirm: () {
        // 1. GetStorage 로그인 정보 지우기
        box.write('isLoggedIn', false);
        box.remove('userId');

        // 2. 로그인 페이지로 이동 (메인 화면 스택 삭제)
        Get.to(() => const LoginPage());
      },
    );
  }    
}


