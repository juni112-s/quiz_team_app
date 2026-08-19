import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/moviename.dart';

class Romancepage extends StatefulWidget {
  const Romancepage({super.key});

  @override
  State<Romancepage> createState() => _RomancepageState();
}

class _RomancepageState extends State<Romancepage> {
  late List<MovieInfo> romanceMovies;
  late PageController pageController;
  int current = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    romanceMovies = [
      MovieInfo(
        imageRoute: "images/titanic.png",
        title: '타이타닉',
        mainActor: '레오나르도 디카프리오',
        director: '제임스 카메론',
        runTimeInMinutes: 195,
        firstReleaseDate: DateTime(1998, 2, 20),
        genre: 2,
      ),
      MovieInfo(
        imageRoute: "images/abouttime.png",
        title: '어바웃 타임',
        mainActor: '돔놀 글리슨',
        director: '리처드 커티스',
        runTimeInMinutes: 123,
        firstReleaseDate: DateTime(2013, 12, 5),
        genre: 2,
      ),
      MovieInfo(
        imageRoute: "images/oncewewereus.png",
        title: '원스 위 워 어스',
        mainActor: '주연 배우',
        director: '감독 이름',
        runTimeInMinutes: 115,
        firstReleaseDate: DateTime(2026, 7, 1),
        genre: 2,
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
    if (romanceMovies.isEmpty) {
      return const CupertinoPageScaffold(
        child: Center(child: Text('영화 데이터가 없습니다.')),
      );
    }

    MovieInfo currentMovie = romanceMovies[current];

    return CupertinoPageScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  currentMovie.imageRoute,
                  width: 250,
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 250,
                      height: 350,
                      color: CupertinoColors.systemGrey5,
                      child: const Icon(
                        CupertinoIcons.film,
                        size: 80,
                        color: CupertinoColors.systemGrey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

// 2. ⭐️ 회색 카드 박스 내 텍스트 전용 CupertinoPicker
              Container(
                width: 280,
                height: 100,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoPicker(
                  itemExtent: 45.0,
                  scrollController: FixedExtentScrollController(initialItem: current),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      current = index; // 텍스트 휠 선택 변경 시 상단 이미지 변경
                    });
                  },
                  children: romanceMovies.map((movie) {
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
                              color: CupertinoColors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble_outline),
                label: Text('리뷰 보기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}