import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/movie_info.dart';
import '../model/reservation_info.dart';
import '../util/movie_info_registry.dart';
import 'movie_detail_page.dart';

const Duration anYear = Duration(days: 365);

class ReservationAddPage extends StatefulWidget {
  const ReservationAddPage({super.key});

  @override
  State<ReservationAddPage> createState() => _ReservationAddPageState();
}

class _ReservationAddPageState extends State<ReservationAddPage> {
  DateTime selectedDate = DateTime.now();
  int selectedGenres = 7, selectedIndex = -1;
  late List<MovieInfo> validMovieList;
  String userName = Get.arguments ?? '';

  @override
  void initState() {
    super.initState();
    fillValidMoviesList();
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
        title: Text('예매하기'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: .start,
            children: [
              InkWell(
                onTap: selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.deepPurple,
                      ),

                      const SizedBox(width: 12),

                      Text(
                        '${selectedDate.year}년 '
                        '${selectedDate.month}월 '
                        '${selectedDate.day}일',
                        style: const TextStyle(fontSize: 16),
                      ),

                      const Spacer(),

                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: .start,
                children: [
                  Text('액션'),
                  Checkbox(
                    value: selectedGenres & 1 != 0,
                    onChanged: (value) {
                      selectedGenres ^= 1;
                      fillValidMoviesList();
                    },
                  ),
                  SizedBox(width: 10),

                  Text('스릴러'),
                  Checkbox(
                    value: selectedGenres & 2 != 0,
                    onChanged: (value) {
                      selectedGenres ^= 2;
                      fillValidMoviesList();
                    },
                  ),
                  SizedBox(width: 10),

                  Text('로맨스'),
                  Checkbox(
                    value: selectedGenres & 4 != 0,
                    onChanged: (value) {
                      selectedGenres ^= 4;
                      fillValidMoviesList();
                    },
                  ),
                ],
              ),
              Text('상영중인 영화 : ${validMovieList.length}'),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: validMovieList.length,
                  scrollDirection: .horizontal,
                  itemBuilder: (context, index) {
                    MovieInfo currentElement = validMovieList[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                          setState(() {});
                        },
                        onDoubleTap: () {
                          Get.to(MovieDetailPage(), arguments: currentElement);
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedIndex == index
                                  ? Colors.yellow
                                  : Colors.transparent,
                              width: 5,
                            ),
                          ),
                          child: Image.asset(currentElement.imageRoute),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .start,
                    children: [
                      Text('예매 정보'),
                      Text('예매일 : ${selectedDate.toString().substring(0, 10)}'),
                      Text(
                        '영화 제목 : ${selectedIndex == -1 ? "선택 대기 중" : validMovieList[selectedIndex].title}',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if(selectedIndex == -1){
                    //영화 선택 안되었다는 메시지 출력
                  }else{
                    //최종 확인 메시지 출력
                    //메시지에서는 선택한 날짜, 선택된 영화 제목을 보여줌
                    ReservationInfo resultRI = ReservationInfo(
                      movieTitle: validMovieList[selectedIndex].title, 
                      reservationDate: selectedDate
                    );
                    Get.back(result: resultRI);
                  }
                }, 
                child: Text('예매하기')
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate.subtract(anYear),
      lastDate: selectedDate.add(anYear),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void fillValidMoviesList() {
    validMovieList = [
      for (MovieInfo mi in MovieInfoRegistry.movies)
        if (selectedGenres & (1 << mi.genre) != 0) mi,
    ];
    selectedIndex = -1;
    setState(() {});
  }
}
