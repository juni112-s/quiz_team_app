import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/moviename.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  final box = GetStorage();
  List<BookingInfo> myBookings = [];
  List<ReviewInfo> myReviews = [];

  @override
  void initState() {
    super.initState();
    _loadMyData();
  }

  // GetStorage에서 저장된 예매내역 및 작성 리뷰 불러오기
  void _loadMyData() {
    List rawBookings = box.read<List>('bookings') ?? [];
    myBookings = rawBookings.map((json) => BookingInfo.fromJson(json)).toList();

    List rawReviews = box.read<List>('reviews') ?? [];
    myReviews = rawReviews.map((json) => ReviewInfo.fromJson(json)).toList();

    setState(() {});
  }

  // 🗑️ 1. 예매 내역 삭제 함수
  void _deleteBooking(int index) {
    Get.defaultDialog(
      title: "예매 내역 삭제",
      middleText: "'${myBookings[index].movieTitle}' 예매 내역을 삭제하시겠습니까?",
      textConfirm: "삭제",
      textCancel: "취소",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[400],
      onConfirm: () {
        setState(() {
          myBookings.removeAt(index); // 리스트에서 삭제
        });

        // GetStorage에 업데이트된 리스트 저장
        List jsonList = myBookings.map((b) => b.toJson()).toList();
        box.write('bookings', jsonList);

        Get.back(); // 팝업 닫기
        Get.snackbar("삭제 완료", "예매 내역이 삭제되었습니다.", snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  // 🗑️ 2. 작성 리뷰 삭제 함수
  void _deleteReview(int index) {
    Get.defaultDialog(
      title: "리뷰 삭제",
      middleText: "'${myReviews[index].movieTitle}' 리뷰를 삭제하시겠습니까?",
      textConfirm: "삭제",
      textCancel: "취소",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[400],
      onConfirm: () {
        setState(() {
          myReviews.removeAt(index); // 리스트에서 삭제
        });

        // GetStorage에 업데이트된 리스트 저장
        List jsonList = myReviews.map((r) => r.toJson()).toList();
        box.write('reviews', jsonList);

        Get.back(); // 팝업 닫기
        Get.snackbar("삭제 완료", "리뷰가 삭제되었습니다.", snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎫 1. 내 예매내역 세션
            const Center(
              child: Text(
                "내 예매내역",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            myBookings.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("예매 내역이 없습니다."),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myBookings.length,
                    itemBuilder: (context, index) {
                      BookingInfo booking = myBookings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.confirmation_number, size: 18, color: Colors.black87),
                                    const SizedBox(width: 6),
                                    Text(
                                      booking.movieTitle,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  booking.bookingDate,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            // 🗑️ 예매 내역 삭제 아이콘 버튼
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _deleteBooking(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 32),

            // ✍️ 2. 내가 작성한 리뷰 세션
            const Center(
              child: Text(
                "내가 작성한 리뷰",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            myReviews.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("작성한 리뷰가 없습니다."),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myReviews.length,
                    itemBuilder: (context, index) {
                      ReviewInfo review = myReviews[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 16, color: Colors.black54),
                                      const SizedBox(width: 4),
                                      Text("작성자 : ${review.writer}",
                                          style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "영화 제목 : ${review.movieTitle}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "리뷰 내용 : ${review.content}",
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            // 🗑️ 작성 리뷰 삭제 아이콘 버튼
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _deleteReview(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}