import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/movie_info.dart';
import '../model/review_info.dart';
import '../util/movie_info_registry.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieInfo? currentMovie = Get.arguments;

  @override
  void initState() {
    if (currentMovie == null) {
      currentMovie = MovieInfoRegistry.movies[0];
      Get.defaultDialog(
        title: '잘못된 입력입니다.',
        textCustom: '영화 데이터를 받는 데에 실패했습니다.',
        barrierDismissible: false,
        textConfirm: '확인',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영화 ${currentMovie!.title}의 리뷰 모음'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Expanded(
          child: ListView.builder(
            itemCount: currentMovie!.reviewList.length,
            itemBuilder: (context, index) {
              ReviewInfo rvi = currentMovie!.reviewList[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.deepPurple),
                  ),
                  child: Row(
                    mainAxisAlignment: .start,
                    children: [
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            mainAxisAlignment: .start,
                            children: [
                              Icon(Icons.person),
                              Text('작성자 : ${rvi.whoWroteThis}'),
                            ],
                          ),
                          Text('리뷰 내용 : ${rvi.reviewContent}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
