import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/moviename.dart';
import 'mypage.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final box = GetStorage();
  late MovieInfo selectedMovie;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedMovie = MovieInfo.movieList.first;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // 하단 영화 선택 모달 바텀시트
  void _showMovieSelectModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("리뷰할 영화 선택", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("목록에서 영화를 선택해 주세요.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: MovieInfo.movieList.length,
                  itemBuilder: (context, index) {
                    MovieInfo movie = MovieInfo.movieList[index];
                    return ListTile(
                      title: Center(
                        child: Text(
                          movie.title,
                          style: const TextStyle(fontSize: 15, color: Colors.deepPurple),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedMovie = movie;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("취소", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  // ⭐️ [리뷰 등록] 버튼 클릭 시 동작 함수
  void _handleReviewSubmit() {
    String text = _reviewController.text.trim();

    if (text.isEmpty) {
      Get.snackbar("알림", "리뷰 내용을 입력해 주세요!", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 1. 리뷰 객체 생성
    final newReview = ReviewInfo(
      writer: 'User',
      movieTitle: selectedMovie.title,
      content: text,
    );

    // 2. GetStorage에 누적 저장
    List storedReviews = box.read<List>('reviews') ?? [];
    storedReviews.add(newReview.toJson());
    box.write('reviews', storedReviews);

    _reviewController.clear();

    // 3. 알림 후 마이페이지로 이동
    Get.defaultDialog(
      title: "등록 완료",
      middleText: "'${selectedMovie.title}' 리뷰가 저장되었습니다.\n마이페이지로 이동합니다.",
      textConfirm: "확인",
      confirmTextColor: Colors.white,
      buttonColor: Colors.deepPurple,
      onConfirm: () {
        Get.back();
        Get.to(() => const Mypage()); // 마이페이지로 이동
      },
    );
  }

  String _getGenreText(int genre) {
    switch (genre) {
      case 0:
        return '액션';
      case 1:
        return '스릴러, 공포';
      case 2:
        return '로맨스';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    String releaseDateStr =
        "${selectedMovie.firstReleaseDate.year}-${selectedMovie.firstReleaseDate.month.toString().padLeft(2, '0')}-${selectedMovie.firstReleaseDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("리뷰 작성"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. 선택된 영화 카드 영역 (클릭 시 영화 선택 모달 오픈)
            GestureDetector(
              onTap: _showMovieSelectModal,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        selectedMovie.imageRoute,
                        width: 90,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("제목 : ${selectedMovie.title}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 3),
                          Text("감독 : ${selectedMovie.director}", style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 3),
                          Text("주연 배우 : ${selectedMovie.mainActor}", style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 3),
                          Text("장르 : ${_getGenreText(selectedMovie.genre)}", style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 3),
                          Text("상영 시간 : ${selectedMovie.runTimeInMinutes}분", style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 3),
                          Text("개봉일 : $releaseDateStr", style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. 리뷰 입력 필드 (최대 25자 제한)
            TextField(
              controller: _reviewController,
              maxLength: 25,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "리뷰를 입력하세요.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ⭐️ 3. [리뷰 등록] 버튼 (클릭 시 GetStorage 저장 ➔ 마이페이지 이동)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: _handleReviewSubmit,
              child: const Text("리뷰 등록", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}