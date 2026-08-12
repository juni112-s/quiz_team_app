import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/model_list.dart';
import 'todo_list_second.dart';

class TodoList extends StatefulWidget {
  TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    bool loggedIn = AppModel.isLoggedIn();
    List<HealthRecordModel> records = AppModel.getHealthRecords();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        title: Text('건강 기록', style: TextStyle(color: Colors.white)),
        actions: [
          if (loggedIn)
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await Get.to(() => TodoListSecond());
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
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('검사 결과 분석',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Expanded(
                    child: records.isEmpty
                        ? Center(child: Text('등록된 검사 기록이 없습니다.', style: TextStyle(color: Colors.grey)))
                        : ListView.builder(
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              var item = records[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Color(0xFF00C9C8)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title,
                                        style: TextStyle(
                                            color: Color(0xFF00C9C8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text(item.content, style: TextStyle(fontSize: 13)),
                                    SizedBox(height: 8),
                                    Text(item.date, style: TextStyle(color: Colors.grey, fontSize: 11)),
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