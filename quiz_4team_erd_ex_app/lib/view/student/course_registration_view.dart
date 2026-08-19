import 'package:flutter/material.dart';
import '../../model/models.dart';

class CourseRegistrationView extends StatefulWidget {
  final String? studentId;
  final VoidCallback? onCourseChanged;

  const CourseRegistrationView({
    super.key,
    this.studentId,
    this.onCourseChanged,
  });

  @override
  State<CourseRegistrationView> createState() => _CourseRegistrationViewState();
}

class _CourseRegistrationViewState extends State<CourseRegistrationView> {
  late TextEditingController _searchController;

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

  Future<bool?> _showRetakeConfirmDialog(String courseName) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text("재수강 안내", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
          content: Text(
            "'$courseName' 과목은 이전에 수강 완료한 이력이 있습니다.\n\n재수강으로 신청하시겠습니까?",
            style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B64F2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("재수강 신청", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleApplyCourse(String currentStudentId, CourseSection sec) async {
    if (sec.enrolled >= sec.capacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모집 정원이 마감되었습니다.')),
      );
      return;
    }

    String retakeFlag = 'N';

    if (Enrollment.hasPassedCourse(currentStudentId, sec.courseCode)) {
      final bool? isRetakeConfirm = await _showRetakeConfirmDialog(sec.course.courseName);
      if (isRetakeConfirm != true) return;
      retakeFlag = 'Y';
    }

    setState(() {
      Enrollment.apply(currentStudentId, sec.sectionCode, isRetake: retakeFlag);
    });

    widget.onCourseChanged?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(retakeFlag == 'Y'
            ? '${sec.course.courseName} 과목이 [재수강]으로 신청되었습니다!'
            : '${sec.course.courseName} 수강신청이 완료되었습니다!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStudentId = widget.studentId ?? Student.current?.studentId ?? '20231001';

    final appliedCodes = Enrollment.list
        .where((e) => e.studentId == currentStudentId && e.status == '수강중')
        .map((e) => e.sectionCode)
        .toSet();

    final filtered = CourseSection.list.where((sec) {
      final q = _searchController.text.toLowerCase();
      return sec.course.courseName.toLowerCase().contains(q) ||
          sec.professor.name.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
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
                      hintText: "과목명 또는 교수명 검색",
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sec = filtered[index];
                final isApplied = appliedCodes.contains(sec.sectionCode);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(sec.course.courseName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "전공",
                              style: TextStyle(color: Color(0xFF1B64F2), fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${sec.professor.name} 교수', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(sec.scheduleString, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(width: 8),
                            const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(sec.classroomString, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(width: 8),
                            const Icon(Icons.book_outlined, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text("${sec.course.credits}학점", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "정원 ${sec.enrolled} / ${sec.capacity}명",
                            style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (isApplied) {
                                setState(() {
                                  Enrollment.cancel(currentStudentId, sec.sectionCode);
                                });
                                widget.onCourseChanged?.call();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${sec.course.courseName} 수강신청이 취소되었습니다.')),
                                );
                              } else {
                                _handleApplyCourse(currentStudentId, sec);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApplied ? const Color(0xFF94A3B8) : const Color(0xFF1B64F2),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            ),
                            child: Text(
                              isApplied ? "신청완료" : "신청",
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}