import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/model_list.dart';

class TodoListSecond extends StatefulWidget {
  TodoListSecond({super.key});

  @override
  State<TodoListSecond> createState() => _TodoListSecondState();
}

class _TodoListSecondState extends State<TodoListSecond> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void saveRecord() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    String dateStr = '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일';

    if (title.isNotEmpty) {
      AppModel.addHealthRecord(title, content, dateStr);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        title: Text('검사 일정 추가', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('검사 날짜'),
            SizedBox(height: 8),
            InkWell(
              onTap: pickDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFEBF7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일'),
                    Icon(Icons.calendar_today, color: Color(0xFF00C9C8)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '검사 명'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: InputDecoration(labelText: '검사 내용 / 주의사항'),
            ),
            SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                onPressed: saveRecord,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C9C8)),
                child: Text('검사 일정 추가', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}