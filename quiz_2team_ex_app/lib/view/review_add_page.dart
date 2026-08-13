import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/movie_info.dart';
import '../model/review_info.dart';
import '../util/movie_info_registry.dart';

class ReviewAddPage extends StatefulWidget {
  const ReviewAddPage({super.key});

  @override
  State<ReviewAddPage> createState() => _ReviewAddPageState();
}

class _ReviewAddPageState extends State<ReviewAddPage> {
  MovieInfo selectedMovie = MovieInfoRegistry.movies[0];
  String userName = Get.arguments ?? '';
  late TextEditingController reviewController;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
    if (userName.isEmpty) {
      Get.defaultDialog(
        title: '잘못된 입력입니다.',
        textCustom: '로그인되지 않은 상태이거나\n 유저 데이터를 받는 데에 실패했습니다.',
        barrierDismissible: false,
        textConfirm: '확인',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 작성'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: .start,
            spacing: 50,
            children: [
              GestureDetector(
                onTap: showReservationActionSheet, //actionsheet 호출
                child: SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Image.asset(selectedMovie.imageRoute, height: 200),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '제목 : ${selectedMovie.title}',
                            style: TextStyle(fontSize: 20, fontWeight: .w900),
                          ),
                          Text('감독 : ${selectedMovie.director}'),
                          Text('주연 배우 : ${selectedMovie.mainActor}'),
                          Text(
                            '장르 : ${MovieInfoRegistry.genres[selectedMovie.genre]}',
                          ),
                          Text('상영 시간 : ${selectedMovie.runTimeInMinutes}'),
                          Text(
                            '개봉일 : ${selectedMovie.firstReleaseDate.toString().substring(0, 10)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: '리뷰를 입력하세요.',
                  border: OutlineInputBorder(),
                ),
                maxLength: 25,
              ),
              ElevatedButton(onPressed: checkInputAndSubmit, child: Text('작성 완료')),
            ],
          ),
        ),
      ),
    );
  }

  void showReservationActionSheet() {
    Get.bottomSheet(
      CupertinoActionSheet(
        title: const Text('리뷰할 영화 선택'),
        message: const Text('리뷰할 영화를 선택해주세요.'),
        actions: [
          for (MovieInfo mi in MovieInfoRegistry.movies)
            CupertinoActionSheetAction(
              onPressed: () {
                selectedMovie = mi;
                Get.back();
                setState(() {});
              },
              child: Text(mi.title),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          child: const Text('취소'),
        ),
      ),
    );
  }

  void checkInputAndSubmit() {
    String checkInput = reviewController.text.trim();
    if (checkInput.isEmpty) {
      //경고 띄우기
    } else {
      ReviewInfo newReview = ReviewInfo(
        whoWroteThis: userName,
        movieTitle: selectedMovie.title,
        reviewContent: checkInput,
      );
      selectedMovie.reviewList.add(newReview);
      Get.back(result: newReview);
    }
  }
}
