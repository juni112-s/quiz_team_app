import 'package:flutter/material.dart';
import 'student_home_view.dart';
import 'course_registration_view.dart';
import 'my_course_list_view.dart';
import 'student_profile_view.dart';

class StudentMainScreen extends StatefulWidget {
  final String studentName;
  final String studentId;
  final int initialTabIndex;

  const StudentMainScreen({
    super.key,
    this.studentName = "홍길동",
    this.studentId = "20231001",
    this.initialTabIndex = 0,
  });

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  late int _currentIndex;
  final List<String> _titles = ["학생 메인", "수강신청", "내 수강목록", "내 정보"];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B64F2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1B64F2),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: "수강신청"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: "수강목록"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "내정보"),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return StudentHomeView(
          studentName: widget.studentName,
          studentId: widget.studentId,
          onNavigateTab: _onTabChange,
        );
      case 1:
        return CourseRegistrationView(
          studentId: widget.studentId,
          onCourseChanged: () => setState(() {}),
        );
      case 2:
        return MyCourseListView(
          studentId: widget.studentId,
          onCourseChanged: () => setState(() {}),
        );
      case 3:
      default:
        return StudentProfileView(
          studentId: widget.studentId,
        );
    }
  }
}