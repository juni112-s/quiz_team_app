import 'package:flutter/material.dart';
import 'package:quiz_4team_app/view/calendar/calendar.dart';
import 'package:quiz_4team_app/view/homes/clinic.dart';
import 'package:quiz_4team_app/view/todo_list/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late TabController controller;
  late int selectedIndex;
  late List<Widget> pages;


  @override
  void initState() {
    super.initState();
    controller =  TabController(length: 3, vsync: this);
    selectedIndex = 0;
    pages = [
      Clinic(),
      TodoList(),
      Calendar(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('asdadasd'),
      // ),
      body: TabBarView(
        controller: controller,
        children: [
          Clinic(),
          TodoList(),
          Calendar(),
        ],
        ),
        bottomNavigationBar: TabBar(
          controller: controller,
          tabs: [
            Tab(
              icon: Icon(
                Icons.looks_one,
                color: Colors.blue,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.looks_two,
                color: Colors.red,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.looks_3,
                color: Colors.grey,
              ),
            ),
            ]),
    );
  }
}