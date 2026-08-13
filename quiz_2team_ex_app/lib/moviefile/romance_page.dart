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
      return const Scaffold(
        body: Center(child: Text('영화 데이터가 없습니다.')),
      );
    }

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: romanceMovies.length,
        onPageChanged: (index) {
          setState(() {
            current = index;
          });
        },
        itemBuilder: (context, index) {
          MovieInfo movie = romanceMovies[index];

          String releaseDateStr =
              "${movie.firstReleaseDate.year}.${movie.firstReleaseDate.month.toString().padLeft(2, '0')}.${movie.firstReleaseDate.day.toString().padLeft(2, '0')}";

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        movie.imageRoute,
                        width: 250,
                        height: 360,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 250,
                            height: 360,
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie, size: 80, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${movie.mainActor}, $releaseDateStr (${movie.runTimeInMinutes}분)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: current > 0
                              ? () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.deepPurple,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('리뷰 보기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                        ),
                        IconButton(
                          onPressed: current < romanceMovies.length - 1
                              ? () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}