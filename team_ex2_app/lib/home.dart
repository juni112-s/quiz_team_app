import 'package:flutter/material.dart';
import 'package:team_ex2_app/model/moviename.dart';
import 'package:team_ex2_app/moviefile/action_page.dart';
import 'package:team_ex2_app/moviefile/romance_page.dart';
import 'package:team_ex2_app/moviefile/thriller_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late TabController controller;
  late List<MovieInfo> movieList;  // 영화 이미지
  late int current;  // 순서


  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    movieList = [
    // [액션 - genre: 0]
    MovieInfo(
      imageRoute: "images/spiderman.png",
      title: '스파이더맨: 브랜드 뉴 데이',
      mainActor: '톰 홀랜드',
      director: '감독 이름',
      runTimeInMinutes: 145,
      firstReleaseDate: DateTime(2026, 7, 29),
      genre: 0,
    ),

    // [스릴러/공포 - genre: 1]
    MovieInfo(
      imageRoute: "images/backroom.png",
      title: '백룸',
      mainActor: '추이텔 에지오프',
      director: '케인 파슨스',
      runTimeInMinutes: 100,
      firstReleaseDate: DateTime(2026, 5, 27),
      genre: 1,
    ),

    // [로맨스 - genre: 2]
    MovieInfo(
      imageRoute: "images/titanic.png",
      title: '타이타닉',
      mainActor: '레오나르도 디카프리오',
      director: '제임스 카메론',
      runTimeInMinutes: 195,
      firstReleaseDate: DateTime(1998, 2, 20),
      genre: 2,
    ),
  ];

    current = 0;
  }

        
  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: const Text('메인 화면'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom:TabBar(
            controller: controller,
            tabs: [
              Tab(text: '액션'),
              Tab(text: '스릴러/공포'),
              Tab(text: '로맨스'),
            ],
          ),

      ),
      // Scaffold의 drawer 속성에 Drawer 위젯 지정
      drawer: Drawer(
        child: Column(
          children: [
            // 1. 상단 프로필 헤더 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              color: Colors.deepPurple, // 보라색 배경
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 아이콘
                    CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 45, color: Colors.grey),
                  ),
                    SizedBox(height: 12),
                  // 안내 문구 및 로그인 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                        '로그인이 필요합니다.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // 하얀색 알약 모양 로그인 버튼
                      ElevatedButton(
                        onPressed: () {
                          // 로그인 페이지로 이동 로직
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          shape: StadiumBorder(), // 둥근 알약 형태
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text('로그인'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 3. 하단 메뉴 버튼 영역
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 200, 10, 10),
              child: Column(
                children: [
                  _buildMenuButton(
                    icon: Icons.person_outline,
                    label: '마이페이지',
                    onPressed: () {

                    },
                  ),
                SizedBox(height: 10),
                  _buildMenuButton(
                    icon: Icons.star_outline,
                    label: '리뷰 작성',
                    onPressed: () {

                    },
                  ),
                SizedBox(height: 10),
                  _buildMenuButton(
                    icon: Icons.confirmation_number_outlined,
                    label: '예매하기',
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body:TabBarView(
        children:
        [
          Actionpage(),
          Romancepage(),
          Thrillerpage(),
        ],
        ),
          
    );
  }// build

// =================Function====================

  // 하단 둥근 보라색 메뉴 버튼 생성 함수
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // 보라색 버튼
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // 모서리 둥글게
          ),
        ),
      ),
    );
  }

}
 
