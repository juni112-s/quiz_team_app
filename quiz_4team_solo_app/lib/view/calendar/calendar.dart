import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // 현재 선택된 연도, 월, 일
  int currentYear = 2026;
  int currentMonth = 8;
  int selectedDay = 11;

  // 요일 표시 텍스트
  List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

  // 예방접종 및 의료 일정 샘플 데이터 (날짜별)
  Map<int, List<Map<String, String>>> scheduleData = {
    8: [
      {'title': 'HPV 3차 접종', 'category': '예방접종', 'time': '10:30 AM'},
    ],
    11: [
      {'title': '내과 정기 검진', 'category': '병원진료', 'time': '02:00 PM'},
    ],
    18: [
      {'title': '코로나 백신 추가접종', 'category': '예방접종', 'time': '11:00 AM'},
    ],
    25: [
      {'title': '파상풍(Tetanus) 주사', 'category': '예방접종', 'time': '03:30 PM'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8), // 메인 민트 색상
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Medical Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. 연도 및 월 선택 컨트롤러
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Color(0xFFEBF7F7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF00C9C8)),
                  onPressed: () {
                    setState(() {
                      if (currentMonth > 1) {
                        currentMonth--;
                      } else {
                        currentMonth = 12;
                        currentYear--;
                      }
                    });
                  },
                ),
                Text(
                  '$currentYear년 $currentMonth월',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C9C8),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF00C9C8)),
                  onPressed: () {
                      if (currentMonth < 12) {
                        currentMonth++;
                      } else {
                        currentMonth = 1;
                        currentYear++;
                      }
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          // 2. 요일 표시 바 (일 ~ 토)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((day) {
                return SizedBox(
                  width: 35,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: day == '일' ? Colors.red : (day == '토' ? Colors.blue : Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. 달력 그리드 영역
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 31, // 31일 기준
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                int day = index + 1;
                bool isSelected = day == selectedDay;
                bool hasEvent = scheduleData.containsKey(day);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(0xFF00C9C8)
                          : (hasEvent ? Color(0xFFEBF7F7) : Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasEvent ? Color(0xFF00C9C8) : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected || hasEvent ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        if (hasEvent)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Color(0xFF00C9C8),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 12),
          Divider(thickness: 1, color: Colors.grey.shade200),

          // 4. 선택된 날짜의 일정 표시 영역
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$currentMonth월 $selectedDay일 일정',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: (scheduleData[selectedDay] != null &&
                            scheduleData[selectedDay]!.isNotEmpty)
                        ? ListView.builder(
                            itemCount: scheduleData[selectedDay]!.length,
                            itemBuilder: (context, index) {
                              var event = scheduleData[selectedDay]![index];
                              return Card(
                                elevation: 0,
                                color: Color(0xFFEBF7F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.medical_information,
                                    color: Color(0xFF00C9C8),
                                  ),
                                  title: Text(
                                    event['title']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text('${event['category']} • ${event['time']}'),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              '등록된 일정이 없습니다.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}