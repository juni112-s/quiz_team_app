import 'package:flutter/material.dart';
import '../model/moviename.dart';

class Actionpage extends StatefulWidget {
  const Actionpage({super.key});

  @override
  State<Actionpage> createState() => _ActionpageState();
}

class _ActionpageState extends State<Actionpage> {
  late List<MovieInfo> actionMovies;
  late PageController pageController;
  int current = 0;

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
        director: '감독 이름',
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

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: actionMovies.length,
        onPageChanged: (index) {
          setState(() {
            current = index;
          });
        },
        itemBuilder: (context, index) {
          MovieInfo movie = actionMovies[index];

          String releaseDateStr =
              "${movie.firstReleaseDate.year}.${movie.firstReleaseDate.month.toString().padLeft(2, '0')}.${movie.firstReleaseDate.day.toString().padLeft(2, '0')}";

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 포스터 이미지
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

                    // 제목 및 정보 박스
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

                    // 버튼 영역
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
                          onPressed: () {
                            
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('리뷰 보기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                        ),
                        IconButton(
                          onPressed: current < actionMovies.length - 1
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