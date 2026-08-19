import 'package:flutter/material.dart';
import '../login_view.dart';

class StudentHomeView extends StatefulWidget {
  final String studentName;
  final String studentId;
  final Function(int)? onNavigateTab;

  const StudentHomeView({
    super.key,
    required this.studentName,
    required this.studentId,
    this.onNavigateTab,
  });

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Color(0xFF1B64F2)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "안녕하세요, ${widget.studentName}님!",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 4),
                    const Text("컴퓨터공학과 3학년", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    Text("학번 ${widget.studentId}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _menuItem(
            icon: Icons.menu_book_outlined,
            title: "수강신청",
            subtitle: "개설된 과목을 조회하고\n수강신청을 합니다.",
            onTap: () => widget.onNavigateTab?.call(1),
          ),
          const SizedBox(height: 12),
          _menuItem(
            icon: Icons.list_alt_outlined,
            title: "내 수강목록",
            subtitle: "신청한 과목과 수강상태를\n확인합니다.",
            onTap: () => widget.onNavigateTab?.call(2),
          ),
          const SizedBox(height: 12),
          _menuItem(
            icon: Icons.person_outline,
            title: "내 정보",
            subtitle: "개인정보를 확인하고\n수정합니다.",
            onTap: () => widget.onNavigateTab?.call(3),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Text("로그아웃", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: const Color(0xFF1B64F2)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}