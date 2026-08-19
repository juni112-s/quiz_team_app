import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/moviename.dart';
import 'mypage.dart';

class AdvencePage extends StatefulWidget {
  const AdvencePage({super.key});

  @override
  State<AdvencePage> createState() => _AdvencePageState();
}

class _AdvencePageState extends State<AdvencePage> {
  final box = GetStorage();
  DateTime selectedDate = DateTime.now();
  MovieInfo? selectedMovie;

  // 장르 체크박스 상태
  bool isActionChecked = true;
  bool isThrillerChecked = false;
  bool isRomanceChecked = false;

  @override
  void initState() {
    super.initState();
    selectedMovie = MovieInfo.movieList.first;
  }

  // 달력 팝업 (Date Picker)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ⭐️ [예매하기] 버튼 클릭 시 동작 함수
  void _handleBookingSubmit() {
    if (selectedMovie == null) {
      Get.snackbar("알림", "예매할 영화를 선택해 주세요!", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String dateStr =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    // 1. 예매 데이터 객체 생성
    final newBooking = BookingInfo(
      movieTitle: selectedMovie!.title,
      bookingDate: dateStr,
    );

    // 2. GetStorage에 누적 저장
    List storedBookings = box.read<List>('bookings') ?? [];
    storedBookings.add(newBooking.toJson());
    box.write('bookings', storedBookings);

    // 3. 알림 후 마이페이지로 바로 이동
    Get.defaultDialog(
      title: "예매 완료",
      middleText: "'${selectedMovie!.title}' 예매가 등록되었습니다.\n마이페이지로 이동합니다.",
      textConfirm: "확인",
      confirmTextColor: Colors.white,
      buttonColor: Colors.deepPurple,
      onConfirm: () {
        Get.back();
        Get.to(() => const Mypage()); // 마이페이지로 이동
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateStr =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    // 체크박스로 필터링된 영화 목록
    List<MovieInfo> filteredMovies = MovieInfo.movieList.where((movie) {
      if (isActionChecked && movie.genre == 0) return true;
      if (isThrillerChecked && movie.genre == 1) return true;
      if (isRomanceChecked && movie.genre == 2) return true;
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("예매하기"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. 날짜 선택 입력 필드 (캘린더 아이콘)
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Text(dateStr, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 2. 장르 선택 체크박스 Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isActionChecked,
                  onChanged: (val) => setState(() => isActionChecked = val ?? false),
                  activeColor: Colors.deepPurple,
                ),
                const Text("액션"),
                const SizedBox(width: 10),
                Checkbox(
                  value: isThrillerChecked,
                  onChanged: (val) => setState(() => isThrillerChecked = val ?? false),
                  activeColor: Colors.deepPurple,
                ),
                const Text("스릴러"),
                const SizedBox(width: 10),
                Checkbox(
                  value: isRomanceChecked,
                  onChanged: (val) => setState(() => isRomanceChecked = val ?? false),
                  activeColor: Colors.deepPurple,
                ),
                const Text("로맨스"),
              ],
            ),
            const SizedBox(height: 8),

            Text("상영중인 영화 ${filteredMovies.length}편",
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),

            // 3. 상영 영화 가로 목록
            SizedBox(
              height: 160,
              child: filteredMovies.isEmpty
                  ? const Center(child: Text("선택된 장르의 영화가 없습니다."))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        MovieInfo movie = filteredMovies[index];
                        bool isSelected = selectedMovie?.title == movie.title;
                        return GestureDetector(
                          onTap: () => setState(() => selectedMovie = movie),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.deepPurple : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Image.asset(
                              movie.imageRoute,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // 4. 예매 정보 요약 박스
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple.shade200),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("예매 정보", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text("예매일 : $dateStr", style: const TextStyle(fontSize: 12)),
                  Text("영화 제목 : ${selectedMovie?.title ?? '선택 안됨'}",
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ⭐️ 5. [예매하기] 버튼 (클릭 시 GetStorage 저장 ➔ 마이페이지 이동)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: _handleBookingSubmit,
                child: const Text("예매하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}