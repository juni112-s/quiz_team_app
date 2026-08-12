import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../model/model_list.dart';
import 'calendar_second.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  void showCupertinoDateChanger(VaccinationModel item) {
    // 명세 7: 클릭 시 CupertinoDatePicker 스낵바/바텀시트 오픈
    showModalBottomSheet(
      context: context,
      builder: (context) {
        DateTime tempDate = DateTime.now();
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String formatted = '${tempDate.year}년 ${tempDate.month}월 ${tempDate.day}일';
                  AppModel.updateVaccinationDate(item.id, formatted);
                  Get.back();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C9C8)),
                child: Text('날짜 변경 완료', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool loggedIn = AppModel.isLoggedIn();
    List<VaccinationModel> list = AppModel.getVaccinations();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        title: Text('Medical Calendar', style: TextStyle(color: Colors.white)),
        actions: [
          if (loggedIn)
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await Get.to(() => CalendarSecond());
                setState(() {});
              },
            ),
        ],
      ),
      body: !loggedIn
          ? Center(
              child: Text(
                '로그인되지 않은 유저거나\n유저 데이터를 가져오는 데에 실패했습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return ListTile(
                  onTap: () => showCupertinoDateChanger(item),
                  title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.date),
                  trailing: Icon(
                    item.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: item.isCompleted ? Color(0xFF00C9C8) : Colors.grey,
                  ),
                );
              },
            ),
    );
  }
}