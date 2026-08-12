import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/model_list.dart';

class CalendarSecond extends StatefulWidget {
  CalendarSecond({super.key});

  @override
  State<CalendarSecond> createState() => _CalendarSecondState();
}

class _CalendarSecondState extends State<CalendarSecond> {
  late TextEditingController titleController;
  DateTime selectedDate = DateTime.now();
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
  }

  void saveVaccine() {
    String title = titleController.text.trim();
    String dateStr = '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일';

    if (title.isNotEmpty) {
      AppModel.addVaccination(title, dateStr, isCompleted);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        title: Text('예방접종 기록 추가', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '접종명 (예: 독감 예방접종)'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChip(
                  label: Text('접종 예정'),
                  selected: !isCompleted,
                  onSelected: (v) => setState(() => isCompleted = false),
                ),
                FilterChip(
                  label: Text('접종 완료'),
                  selected: isCompleted,
                  onSelected: (v) => setState(() => isCompleted = true),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: saveVaccine,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C9C8)),
                child: Text('접종 기록 추가', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}