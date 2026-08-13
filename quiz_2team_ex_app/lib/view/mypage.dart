import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/reservation_info.dart';
import '../model/review_info.dart';
import '../model/user_info.dart';
import 'reservation_add_page.dart';
import 'review_add_page.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  UserInfo? currentUser = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (currentUser == null) {
      currentUser = UserInfo(userID: 'dummy');
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
        title: Text('마이 페이지'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(
                ReservationAddPage(),
                arguments: currentUser!.userID,
              )!.then((value) {
                if (value != null) {
                  currentUser!.reservationList.add(value);
                  setState(() {});
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text('예매'),
          ),
          TextButton(
            onPressed: () {
              Get.to(ReviewAddPage(), arguments: currentUser!.userID)!.then((
                value,
              ) {
                if (value != null) {
                  currentUser!.reviewList.add(value);
                  setState(() {});
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text('리뷰'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: .start,
                  children: [
                    Text(
                      '내 예매 내역',
                      textAlign: .center,
                      style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentUser!.reservationList.length,
                        itemBuilder: (context, index) {
                          ReservationInfo rvi =
                              currentUser!.reservationList[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: .start,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(Icons.movie_edit),
                                  Column(
                                    mainAxisAlignment: .start,
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        rvi.movieTitle,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: .w900,
                                        ),
                                      ),
                                      Text(
                                        rvi.reservationDate
                                            .toString()
                                            .substring(0, 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: .start,
                  children: [
                    Text(
                      '내 리뷰 기록',
                      textAlign: .center,
                      style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentUser!.reviewList.length,
                        itemBuilder: (context, index) {
                          ReviewInfo rvi = currentUser!.reviewList[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.deepPurple,
                                ),
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
                                      Text(
                                        '영화 제목 : ${rvi.movieTitle}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: .w900,
                                        ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ListView.builder(
//               itemCount: currentUser!.reservationList.length,
//               itemBuilder: (context, index) {
//                 ReservationInfo currentResInfo =
//                     currentUser!.reservationList[index];
//                 return Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(width: 4, color: Colors.deepPurple),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: .start,
//                     children: [
//                       Icon(Icons.movie_edit),
//                       Column(
//                         mainAxisAlignment: .start,
//                         children: [
//                           Text(
//                             currentResInfo.movieTitle,
//                             style: TextStyle(fontSize: 20, fontWeight: .w900),
//                           ),
//                           Text(
//                             currentResInfo.reservationDate.toString().substring(
//                               0,
//                               9,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),