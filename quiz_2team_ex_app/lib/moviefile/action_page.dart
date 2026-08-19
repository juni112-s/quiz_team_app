import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/moviename.dart'; // MovieInfo 모델 경로 확인

class Actionpage extends StatefulWidget {
  const Actionpage({super.key});

  @override
  State<Actionpage> createState() => _ActionpageState();
}

class _ActionpageState extends State<Actionpage> {
  late List<MovieInfo> actionMovies;
  late PageController pageController;
  int current = 0; // 현재 선택된 영화 인덱스

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    actionMovies = [
      MovieInfo(
        imageRoute: "images/spiderman.png",
        title: '스파이더맨: 브랜드 뉴 데이',
        mainActor: '톰 홀랜드',
        director: '감독 이름',
        runTimeInMinutes: 145,
        firstReleaseDate: DateTime(2026, 7, 29),
        genre: 0,
      ),
      MovieInfo(
        imageRoute: "images/theoutlaws.png",
        title: '범죄도시',
        mainActor: '마동석',
        director: '강윤성',
        runTimeInMinutes: 120,
        firstReleaseDate: DateTime(2023, 5, 31),
        genre: 0,
      ),
      MovieInfo(
        imageRoute: "images/odyssey.png",
        title: '오디세이',
        mainActor: '주연 배우',
        director: '강윤성',
        runTimeInMinutes: 130,
        firstReleaseDate: DateTime(2026, 8, 1),
        genre: 0,
      ),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (actionMovies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('영화 데이터가 없습니다.')),
      );
    }

    // ⭐️ 현재 선택된 영화 데이터
    MovieInfo currentMovie = actionMovies[current];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ----------------------------------------------------
              // 1. 고정된 상단 이미지 (current 변수에 맞춰 이미지 변경)
              // ----------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  currentMovie.imageRoute, // 현재 선택된 영화 이미지
                  width: 250,
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 250,
                      height: 350,
                      color: Colors.grey[300],
                      child: Icon(Icons.movie, size: 80, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ----------------------------------------------------
              // 2. 위아래로 움직이는 텍스트 전용 영역 (SizedBox 높이 고정)
              // ----------------------------------------------------
                Container(
                width: 280,
                height: 100, // 텍스트 피커 박스 높이
                decoration: BoxDecoration(
                  color: Colors.grey, // 회색 카드 배경
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoPicker(
                  itemExtent: 45.0, // 피커 1칸 높이
                  scrollController: FixedExtentScrollController(initialItem: current),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      current = index; // 텍스트 피커 휠을 위아래로 돌리면 상단 포스터 변경
                    });
                  },
                  children: actionMovies.map((movie) {
                    String releaseDateStr =
                        "${movie.firstReleaseDate.year}.${movie.firstReleaseDate.month.toString().padLeft(2, '0')}.${movie.firstReleaseDate.day.toString().padLeft(2, '0')}";

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                            ),
                          ),
                          Text(
                            '${movie.mainActor}, $releaseDateStr (${movie.runTimeInMinutes}분)',
                            style: const TextStyle(
                              fontSize: 11,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ----------------------------------------------------
              // 3. 하단 리뷰 보기 버튼
              // ----------------------------------------------------

              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble_outline),
                label: Text('리뷰 보기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}