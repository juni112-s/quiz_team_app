import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // 검사 결과 분석 한국어 데이터 리스트
  List<Map<String, String>> analysisList = [
    {
      'title': '혈액 검사',
      'subtitle': '혈당: 수치가 높으면 당뇨병 가능성을 나타낼 수 있습니다.',
      'date': '2026년 2월 10일 수동 추가됨',
    },
    {
      'title': '소변 검사',
      'subtitle': '색상 및 악취: 이상 수치는 요로 감염이나 신장 질환을 나타낼 수 있습니다.',
      'date': '2026년 6월 6일 수동 추가됨',
    },
    {
      'title': '지질 / 콜레스테롤 검사',
      'subtitle': '중성지방: 수치가 높으면 심혈관 질환 위험이 증가할 수 있습니다.',
      'date': '2026년 10월 20일 수동 추가됨',
    },
    {
      'title': '갑상선 기능 검사',
      'subtitle': 'T3 및 T4: 이상 수치는 갑상선 기능 장애를 나타낼 수 있습니다.',
      'date': '2026년 10월 20일 수동 추가됨',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8), // 메인 민트 색상
        elevation: 0,
        centerTitle: true,
        title: Text(
          '건강 기록',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 소제목 (검사 결과 분석)
            Text(
              '검사 결과 분석',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // 2. ListView.builder 영역
            Expanded(
              child: ListView.builder(
                itemCount: analysisList.length,
                itemBuilder: (context, index) {
                  var item = analysisList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF00C9C8),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 좌측 원형 아이콘
                        Padding(
                          padding: EdgeInsets.only(top: 2, right: 12),
                          child: Icon(
                            Icons.radio_button_checked,
                            color: Color(0xFF00C9C8),
                            size: 20,
                          ),
                        ),

                        // 수평 중앙 콘텐츠 (제목, 세부내용, 날짜)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: TextStyle(
                                  color: Color(0xFF00C9C8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                item['subtitle']!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                item['date']!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 우측 다운로드 아이콘
                        Padding(
                          padding: EdgeInsets.only(left: 8, top: 2),
                          child: Icon(
                            Icons.arrow_circle_down_outlined,
                            color: Color(0xFF00C9C8),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}