import 'package:flutter/material.dart';
import '../moviefile/action_page.dart';
import '../moviefile/thriller_page.dart';
import '../moviefile/romance_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
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
        title: const Text('Cine Log'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: controller,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 45, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '로그인이 필요합니다.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('로그인'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMenuButton(Icons.person_outline, '마이페이지'),
                  const SizedBox(height: 10),
                  _buildMenuButton(Icons.star_outline, '리뷰 작성'),
                  const SizedBox(height: 10),
                  _buildMenuButton(Icons.confirmation_number_outlined, '예매하기'),
                ],
              ),
            ),
          ],
        ),
      ),

      // 탭바 3개 연결
      body: TabBarView(
        controller: controller,
        children: const [
          Actionpage(),   // 액션 탭
          Thrillerpage(), // 스릴러/공포 탭
          Romancepage(),  // 로맨스 탭
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}