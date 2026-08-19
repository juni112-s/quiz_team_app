import 'package:flutter/material.dart';
import '../../model/models.dart';

class MyCourseListView extends StatefulWidget {
  final String? studentId;
  final VoidCallback? onCourseChanged;

  const MyCourseListView({
    super.key,
    this.studentId,
    this.onCourseChanged,
  });

  @override
  State<MyCourseListView> createState() => _MyCourseListViewState();
}

class _MyCourseListViewState extends State<MyCourseListView> {
  int _categoryIndex = 0;
  final List<String> _tabs = ["전체", "수강중", "수강완료", "취소"];

  // ⭕ 과목 클릭 시 선수과목 및 상세 정보를 보여주는 BottomSheet 함수
  void _showCourseDetailModal(BuildContext context, CourseSection sec) {
    final course = sec.course;
    final prereqs = course.prerequisites;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 바 핸들
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 과목 기본 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.courseName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${course.credits}학점 / ${sec.division}분반",
                      style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "담당: ${sec.professor.name} 교수 (${sec.classroomString})",
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
              const SizedBox(height: 20),

              // 선수과목(Prerequisite) 안내 구역
              const Text(
                "선수과목 안내",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 8),
              if (prereqs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Text(
                    "이 과목은 지정된 선수과목이 없습니다.",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                )
              else
                ...prereqs.map((p) {
                  final targetPrereqCourse = Course.list.firstWhere(
                    (c) => c.courseCode == p.prereqCode,
                    orElse: () => Course(courseCode: p.prereqCode, deptCode: '', courseName: p.prereqCode, credits: 0, syllabus: ''),
                  );
                  final isMust = p.isMandatory == 'Y';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isMust ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 16, color: isMust ? const Color(0xFF1B64F2) : const Color(0xFF64748B)),
                            const SizedBox(width: 8),
                            Text(
                              targetPrereqCourse.courseName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "(${p.prereqCode})",
                              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isMust ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isMust ? "필수이수" : "권장이수",
                            style: TextStyle(
                              color: isMust ? const Color(0xFFEF4444) : const Color(0xFF1B64F2),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 16),

              // 강의 계획 요약
              const Text(
                "강의 계획",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 6),
              Text(
                course.syllabus.isNotEmpty ? course.syllabus : "강의 계획서가 등록되지 않았습니다.",
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStudentId = widget.studentId ?? Student.current?.studentId ?? '20231001';

    // 해당 학생의 수강신청 목록
    final myEnrollments = Enrollment.list.where((e) => e.studentId == currentStudentId).toList();

    // 상단 탭 필터링
    final filtered = myEnrollments.where((e) {
      if (_categoryIndex == 0) return true;
      return e.status == _tabs[_categoryIndex];
    }).toList();

    // 총 신청 학점 계산
    int totalCredits = myEnrollments
        .where((e) => e.status == '수강중')
        .fold(0, (sum, item) => sum + item.section.course.credits);

    return Column(
      children: [
        // 상단 카테고리 탭
        Container(
          color: Colors.white,
          height: 48,
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isSelected = _categoryIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _categoryIndex = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _tabs[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF1B64F2) : const Color(0xFF64748B),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 2,
                          width: 32,
                          color: const Color(0xFF1B64F2),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),

        // 수강 목록 리스트
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text(
                    "신청된 수강 내역이 없습니다.",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final sec = item.section;

                    // ⭕ 카드를 InkWell로 감싸서 클릭 가능하도록 구현
                    return InkWell(
                      onTap: () => _showCourseDetailModal(context, sec),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                const Icon(Icons.info_outline, size: 18, color: Color(0xFF94A3B8)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${sec.professor.name} 교수', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                            const SizedBox(height: 10),
                            Row(
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
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("신청일 ${item.applyDate}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.status == '수강중' ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: TextStyle(
                                          color: item.status == '수강중' ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      Enrollment.cancel(currentStudentId, sec.sectionCode);
                                    });
                                    widget.onCourseChanged?.call();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${sec.course.courseName} 수강이 취소되었습니다.')),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFEF4444)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  ),
                                  child: const Text("수강취소", style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // 하단 총 신청 학점
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school, color: Color(0xFF1B64F2), size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("총 신청 학점", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    const SizedBox(height: 2),
                    Text("$totalCredits 학점", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}