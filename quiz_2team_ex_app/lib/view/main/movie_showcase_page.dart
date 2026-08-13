import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_ex2_app/model/movie_info.dart';
import 'package:team_ex2_app/util/movie_info_registry.dart';

import '../movie_detail_page.dart';

class MovieShowcasePage extends StatefulWidget {
  final int selectedGenre;
  const MovieShowcasePage({super.key, required this.selectedGenre});

  @override
  State<MovieShowcasePage> createState() => _MovieShowcasePageState();
}

class _MovieShowcasePageState extends State<MovieShowcasePage> {
  late List<MovieInfo> selectedMovies = [
    for (MovieInfo mi in MovieInfoRegistry.movies)
      if (mi.genre == widget.selectedGenre) mi,
  ];
  late MovieInfo selectedMovie = selectedMovies[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. 영화 포스터 사진
                GestureDetector(
                  onDoubleTap: () {
                    Get.to(MovieDetailPage(), arguments: selectedMovie);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      selectedMovie.imageRoute, // 포스터 사진
                      width: 250,
                      height: 360,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. 영화 제목 및 배우/개봉일 박스 (사진과 함께 변경됨)
                Container(
                  width: 250,
                  height: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CupertinoPicker.builder(
                    itemExtent: 100,
                    onSelectedItemChanged: (value) {
                      selectedMovie = selectedMovies[value];
                      setState(() {});
                    },
                    childCount: selectedMovies.length,
                    itemBuilder: (context, index) {
                      MovieInfo currentElement = selectedMovies[index];
                      return Column(
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            currentElement.title, // 영화 제목
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${currentElement.mainActor}, ${currentElement.firstReleaseDate.toString().substring(0, 10)} (${currentElement.runTimeInMinutes}분)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(MovieDetailPage(), arguments: selectedMovie);
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('리뷰 보기'),
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
      ),
    );
  }
}
