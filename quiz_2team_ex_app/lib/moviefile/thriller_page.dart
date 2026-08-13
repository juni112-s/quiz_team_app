import 'package:flutter/material.dart';
import '../model/moviename.dart';

class Thrillerpage extends StatefulWidget {
  const Thrillerpage({super.key});

  @override
  State<Thrillerpage> createState() => _ThrillerpageState();
}

class _ThrillerpageState extends State<Thrillerpage> {
  late List<MovieInfo> thrillerMovies;
  late PageController pageController;
  int current = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    thrillerMovies = [
      MovieInfo(
        imageRoute: "images/backroom.png",
        title: '백룸',
        mainActor: '추이텔 에지오프',
        director: '케인 파슨스',
        runTimeInMinutes: 100,
        firstReleaseDate: DateTime(2026, 5, 27),
        genre: 1,
      ),
      MovieInfo(
        imageRoute: "images/getout.png",
        title: '겟아웃',
        mainActor: '다니엘 칼루야',
        director: '조던 필',
        runTimeInMinutes: 104,
        firstReleaseDate: DateTime(2017, 5, 17),
        genre: 1,
      ),
      MovieInfo(
        imageRoute: "images/salmokji.png",
        title: '살목지',
        mainActor: '주연 배우',
        director: '감독 이름',
        runTimeInMinutes: 110,
        firstReleaseDate: DateTime(2026, 6, 1),
        genre: 1,
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
    if (thrillerMovies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('영화 데이터가 없습니다.')),
      );
    }

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: thrillerMovies.length,
        onPageChanged: (index) {
          setState(() {
            current = index;
          });
        },
        itemBuilder: (context, index) {
          MovieInfo movie = thrillerMovies[index];

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
                          onPressed: current < thrillerMovies.length - 1
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