import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/moviename.dart'; // MovieInfo 모델 경로 확인

class Thrillerpage extends StatefulWidget {
  const Thrillerpage({super.key});

  @override
  State<Thrillerpage> createState() => _ThrillerpageState();
}

class _ThrillerpageState extends State<Thrillerpage> {
  late List<MovieInfo> thrillerMovies;
  late PageController pageController;
  int current = 0; // 현재 선택된 영화 인덱스

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

    MovieInfo currentMovie = thrillerMovies[current];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. 고정된 상단 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  currentMovie.imageRoute,
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
              SizedBox(height: 16),

           // 2. ⭐️ 회색 카드 박스 내 텍스트 전용 CupertinoPicker
              Container(
                width: 280,
                height: 100,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  scrollController: FixedExtentScrollController(initialItem: current),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      current = index; // 텍스트 휠 선택 변경 시 상단 이미지 변경
                    });
                  },
                  children: thrillerMovies.map((movie) {
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
              // 3. 하단 리뷰 보기 버튼

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