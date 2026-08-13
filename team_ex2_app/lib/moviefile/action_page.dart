import 'package:flutter/material.dart';
import '../model/moviename.dart'; // MovieInfo 모델 경로 확인

class Actionpage extends StatefulWidget {
  const Actionpage({super.key});

  @override
  State<Actionpage> createState() => _ActionpageState();
}

class _ActionpageState extends State<Actionpage> {
  late List<MovieInfo> actionMovies;
  late PageController pageController; // 스와이프 제어용 컨트롤러
  int current = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    // 액션 영화 목록 데이터
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
    return Scaffold(
      // ⭐️ PageView를 사용하면 좌우 슬라이드 시 사진과 제목이 동시에 함께 넘어갑니다.
      body: PageView.builder(
        controller: pageController,
        itemCount: actionMovies.length,
        onPageChanged: (index) {
          setState(() {
            current = index; // 페이지가 바뀔 때 현재 인덱스 업데이트
          });
        },
        itemBuilder: (context, index) {
          MovieInfo movie = actionMovies[index];

          // 개봉일 포맷팅 (YYYY.MM.DD)
          String releaseDateStr =
              "${movie.firstReleaseDate.year}.${movie.firstReleaseDate.month.toString().padLeft(2, '0')}.${movie.firstReleaseDate.day.toString().padLeft(2, '0')}";

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 1. 영화 포스터 사진
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        movie.imageRoute, // 포스터 사진
                        width: 250,
                        height: 360,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. 영화 제목 및 배우/개봉일 박스 (사진과 함께 변경됨)
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
                            movie.title, // 영화 제목
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

                    // 3. 하단 버튼 영역 (리뷰 보기 & 이전/다음 화살표)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이전 영화 버튼
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
                        
                        // 리뷰 보기 버튼
                        ElevatedButton.icon(
                          onPressed: () {
                            // 리뷰 보기 클릭 시 동작
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('리뷰 보기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                        ),

                        // 다음 영화 버튼
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