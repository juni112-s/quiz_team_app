import 'package:flutter/material.dart';
import '../../model/models.dart';

class AdviseeStudentsView extends StatefulWidget {
  final String profCode;

  const AdviseeStudentsView({
    super.key,
    this.profCode = 'P001',
  });

  @override
  State<AdviseeStudentsView> createState() => _AdviseeStudentsViewState();
}

class _AdviseeStudentsViewState extends State<AdviseeStudentsView> {
  late TextEditingController _searchController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showStudentDetailModal(Student student) {
    final studentEnrollments = Enrollment.list.where((e) => e.studentId == student.studentId && e.status == '수강중').toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFEFF6FF),
                child: Icon(Icons.person, color: Color(0xFF1B64F2)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text("학번: ${student.studentId}", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _infoRow("소속 학과", student.departmentName),
                _infoRow("학년 / 학적", "${student.grade}학년 (${student.academicStatus})"),
                _infoRow("연락처", student.phone),
                _infoRow("신청가능학점", "${student.maxCredits}학점"),
                const Divider(height: 24, color: Color(0xFFE2E8F0)),
                const Text("현재 수강 과목", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155))),
                const SizedBox(height: 8),
                if (studentEnrollments.isEmpty)
                  const Text("수강 중인 과목이 없습니다.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12))
                else
                  ...studentEnrollments.map((e) {
                    final sec = e.section;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(sec.course.courseName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text("${sec.course.credits}학점", style: const TextStyle(fontSize: 12, color: Color(0xFF1B64F2))),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기", style: TextStyle(color: Color(0xFF1B64F2), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myStudents = Student.list.where((s) => s.advisorCode == widget.profCode).toList();

    final filtered = myStudents.where((s) {
      final q = _searchController.text.toLowerCase();
      return s.name.toLowerCase().contains(q) || s.studentId.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B64F2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("지도 학생", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: "학생명 또는 학번 검색",
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("지도 학생이 없습니다.", style: TextStyle(color: Color(0xFF94A3B8))))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final s = filtered[index];
                        return InkWell(
                          onTap: () => _showStudentDetailModal(s),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Color(0xFFEFF6FF),
                                  child: Icon(Icons.person, size: 30, color: Color(0xFF1B64F2)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(s.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          Text(s.studentId, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text("${s.departmentName} ${s.grade}학년", style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone, size: 12, color: Color(0xFF64748B)),
                                          const SizedBox(width: 4),
                                          Text(s.phone, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  icon: const Icon(Icons.chevron_left, color: Color(0xFF94A3B8)),
                ),
                ...List.generate(3, (index) {
                  final pageNum = index + 1;
                  final isCur = _currentPage == pageNum;
                  return InkWell(
                    onTap: () => setState(() => _currentPage = pageNum),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCur ? const Color(0xFF1B64F2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "$pageNum",
                          style: TextStyle(
                            color: isCur ? Colors.white : const Color(0xFF64748B),
                            fontWeight: isCur ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                IconButton(
                  onPressed: _currentPage < 3 ? () => setState(() => _currentPage++) : null,
                  icon: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}