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

  // 1. 캘린더 & 전체 개설 수업 모달
  void _showCalendarScheduleModal(BuildContext context, Student student) {
    int selectedDay = 19;
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final date = DateTime(2026, 8, selectedDay);
            final dayOfWeekStr = ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1];

            final matchedPeriods = RegistrationPeriod.list.where((p) {
              return (date.isAfter(p.startDate.subtract(const Duration(days: 1))) &&
                      date.isBefore(p.endDate.add(const Duration(days: 1)))) ||
                  (date.year == p.startDate.year && date.month == p.startDate.month && date.day == p.startDate.day);
            }).toList();

            final daySchedules = CourseSchedule.list.where((s) => s.dayOfWeek == dayOfWeekStr).toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "2026년 8월 학사 & 수업 일정",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "내 학년: ${student.grade}학년",
                              style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weekdays.map((w) {
                          final isSun = w == '일';
                          final isSat = w == '토';
                          return SizedBox(
                            width: 38,
                            child: Center(
                              child: Text(
                                w,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSun ? const Color(0xFFEF4444) : (isSat ? const Color(0xFF3B82F6) : const Color(0xFF64748B)),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 37,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          if (index < 6) return const SizedBox.shrink();
                          final day = index - 5;
                          if (day > 31) return const SizedBox.shrink();

                          final isSelected = day == selectedDay;
                          final hasPeriod = (day >= 18 && day <= 21) || (day >= 24 && day <= 26);
                          final isMyGradeDay = (student.grade == 4 && day == 18) ||
                              (student.grade == 3 && day == 19) ||
                              (student.grade == 2 && day == 20) ||
                              (student.grade == 1 && day == 21);

                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedDay = day;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1B64F2)
                                    : (isMyGradeDay
                                        ? const Color(0xFFEFF6FF)
                                        : (hasPeriod ? const Color(0xFFF8FAFC) : Colors.transparent)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1B64F2)
                                      : (isMyGradeDay ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0)),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      "$day",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected || isMyGradeDay ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected
                                            ? Colors.white
                                            : (isMyGradeDay ? const Color(0xFF1B64F2) : const Color(0xFF1E293B)),
                                      ),
                                    ),
                                  ),
                                  if (hasPeriod && !isSelected)
                                    Positioned(
                                      bottom: 4,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: isMyGradeDay ? const Color(0xFF1B64F2) : const Color(0xFF94A3B8),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.event_note, color: Color(0xFF1B64F2), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "8월 $selectedDay일 ($dayOfWeekStr) 일정 상세",
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (matchedPeriods.isNotEmpty) ...[
                        const Text("📌 수강신청 학사 일정", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 6),
                        ...matchedPeriods.map((p) {
                          final isMyPeriod = p.targetGrade == student.grade;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMyPeriod ? const Color(0xFFEFF6FF) : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isMyPeriod ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  p.gradeLabel,
                                  style: TextStyle(
                                    fontWeight: isMyPeriod ? FontWeight.bold : FontWeight.w600,
                                    color: isMyPeriod ? const Color(0xFF1B64F2) : const Color(0xFF1E293B),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(p.periodText, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 14),
                      ],
                      Text("📚 $dayOfWeekStr요일 개설 강의 목록 (${daySchedules.length}개)", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      const SizedBox(height: 6),
                      if (daySchedules.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: Text("해당 요일에 개설된 수업이 없습니다.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                          ),
                        )
                      else
                        ...daySchedules.map((sc) {
                          final sec = CourseSection.list.firstWhere((s) => s.sectionCode == sc.sectionCode);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(sec.course.courseName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                                          child: Text("${sec.division}분반", style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text("${sec.professor.name} 교수 | ${sc.classroom}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFCBD5E1)),
                                  ),
                                  child: Text(
                                    "${sc.startPeriod.toString().padLeft(2, '0')}:00 ~ ${sc.endPeriod.toString().padLeft(2, '0')}:50",
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // 2. 상단 수강신청 기간 배너
  Widget _buildRegistrationPeriodBanner(Student student) {
    final period = RegistrationPeriod.getPeriodForStudent(student.grade);
    final now = DateTime.now();

    bool isOpening = now.isAfter(period.startDate) && now.isBefore(period.endDate);
    bool isBefore = now.isBefore(period.startDate);

    String statusText = isOpening ? "수강신청 가능 (진행중)" : (isBefore ? "신청 대기중" : "신청 기간 마감");
    Color statusBg = isOpening ? const Color(0xFFDCFCE7) : (isBefore ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9));
    Color statusColor = isOpening ? const Color(0xFF16A34A) : (isBefore ? const Color(0xFFD97706) : const Color(0xFF64748B));

    return InkWell(
      onTap: () => _showCalendarScheduleModal(context, student),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month, color: Color(0xFF1B64F2), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${student.grade}학년 수강신청 기간",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.touch_app, size: 14, color: Color(0xFF1B64F2)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    period.periodText,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
          ],
        ),
      ),
    );
  }

  // 3. 개별 과목 상세 모달
  void _showCourseDetailModal(BuildContext context, String currentStudentId, CourseSection sec) {
    final course = sec.course;
    final prereqs = course.prerequisites;
    final subsequents = course.subsequentCourses;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          "${course.courseLevelTag} • ${course.credits}학점",
                          style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "담당: ${sec.professor.name} 교수 (${sec.classroomString} / ${sec.scheduleString})",
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  const Text("1. 선수과목 (수강 전 필수/권장 이수 과목)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 8),
                  if (prereqs.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                      child: const Text("선수과목이 없는 기초 입문 과목입니다.", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    )
                  else
                    ...prereqs.map((p) {
                      final target = Course.list.firstWhere((c) => c.courseCode == p.prereqCode, orElse: () => Course(courseCode: p.prereqCode, deptCode: '', courseName: p.prereqCode, credits: 0, syllabus: ''));
                      final isPassed = Enrollment.isCoursePassed(currentStudentId, p.prereqCode);
                      final isMust = p.isMandatory == 'Y';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isPassed ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isPassed ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(isPassed ? Icons.check_circle : Icons.cancel_outlined, size: 18, color: isPassed ? const Color(0xFF16A34A) : const Color(0xFFEF4444)),
                                const SizedBox(width: 8),
                                Text("${target.courseName} (${p.prereqCode})", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: isPassed ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                isPassed ? "이수완료" : (isMust ? "필수 미이수" : "권장 미이수"),
                                style: TextStyle(color: isPassed ? const Color(0xFF16A34A) : const Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 20),

                  const Text("2. 후수과목 (이 과목을 이수한 후 수강 가능한 과목)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 8),
                  if (subsequents.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                      child: const Text("후속 연계 과목이 없는 심화/종료 과목입니다.", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    )
                  else
                    ...subsequents.map((sub) {
                      final nextCourse = Course.list.firstWhere((c) => c.courseCode == sub.courseCode, orElse: () => Course(courseCode: sub.courseCode, deptCode: '', courseName: sub.courseCode, credits: 0, syllabus: ''));
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_right_alt, size: 20, color: Color(0xFF1B64F2)),
                                const SizedBox(width: 8),
                                Text("${nextCourse.courseName} (${sub.courseCode})", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                sub.isMandatory == 'Y' ? "필수 선수조건" : "권장 선수조건",
                                style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 20),

                  const Text("3. 강의 계획", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  Text(course.syllabus.isNotEmpty ? course.syllabus : "강의 계획서가 등록되지 않았습니다.", style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 4. 선수과목 미이수 경고 다이얼로그
  void _showPrerequisiteWarningDialog(String courseName, List<Prerequisite> missingPrereqs) {
    final missingNames = missingPrereqs.map((p) {
      final c = Course.list.firstWhere((item) => item.courseCode == p.prereqCode, orElse: () => Course(courseCode: p.prereqCode, deptCode: '', courseName: p.prereqCode, credits: 0, syllabus: ''));
      return "• ${c.courseName} (${p.prereqCode})";
    }).join("\n");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.block, color: Color(0xFFEF4444)),
              SizedBox(width: 8),
              Text("선수과목 미이수 안내", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("'$courseName' 과목을 수강하기 위해서는 아래 필수 선수과목을 먼저 이수해야 합니다.", style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFECACA))),
                child: Text(missingNames, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w600, height: 1.4)),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B64F2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("확인", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // 5. 재수강 확인 다이얼로그
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
          content: Text("'$courseName' 과목은 이전에 수강 완료한 이력이 있습니다.\n\n재수강으로 신청하시겠습니까?", style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.4)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("취소", style: TextStyle(color: Color(0xFF64748B)))),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B64F2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("재수강 신청", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // 6. 수강신청 클릭 검증 핸들러
  Future<void> _handleApplyCourse(String currentStudentId, CourseSection sec) async {
    final isAlreadyTaking = Enrollment.list.any((e) => e.studentId == currentStudentId && e.section.courseCode == sec.courseCode && e.status == '수강중');
    if (isAlreadyTaking) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이미 신청 중인 과목(${sec.course.courseName})입니다.')));
      return;
    }

    final missingPrereqs = Enrollment.getMissingPrerequisites(currentStudentId, sec.courseCode);
    if (missingPrereqs.isNotEmpty) {
      _showPrerequisiteWarningDialog(sec.course.courseName, missingPrereqs);
      return;
    }

    if (sec.enrolled >= sec.capacity) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('모집 정원이 마감되었습니다.')));
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
    final student = Student.list.firstWhere(
      (s) => s.studentId == currentStudentId,
      orElse: () => Student(
        studentId: currentStudentId,
        deptCode: 'CSE',
        name: '홍길동',
        phone: '010-0000-0000',
        grade: 3,
        academicStatus: '재학',
        maxCredits: 18,
        password: '1234',
      ),
    );

    final appliedCodes = Enrollment.list.where((e) => e.studentId == currentStudentId && e.status == '수강중').map((e) => e.sectionCode).toSet();

    final filtered = CourseSection.list.where((sec) {
      final q = _searchController.text.toLowerCase();
      return sec.course.courseName.toLowerCase().contains(q) || sec.professor.name.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildRegistrationPeriodBanner(student),
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
                final missingPrereqs = Enrollment.getMissingPrerequisites(currentStudentId, sec.courseCode);
                final bool hasMissingPrereq = missingPrereqs.isNotEmpty;

                return InkWell(
                  onTap: () => _showCourseDetailModal(context, currentStudentId, sec),
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
                                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                                  child: Text(sec.course.courseLevelTag, style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 11, fontWeight: FontWeight.w600)),
                                ),
                                if (hasMissingPrereq) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(4)),
                                    child: const Text("선수과목 필요", style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                            const Icon(Icons.info_outline, size: 18, color: Color(0xFF94A3B8)),
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
                            Text("정원 ${sec.enrolled} / ${sec.capacity}명", style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
                            ElevatedButton(
                              onPressed: () {
                                if (isApplied) {
                                  setState(() {
                                    Enrollment.cancel(currentStudentId, sec.sectionCode);
                                  });
                                  widget.onCourseChanged?.call();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${sec.course.courseName} 수강신청이 취소되었습니다.')));
                                } else {
                                  _handleApplyCourse(currentStudentId, sec);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isApplied ? const Color(0xFF94A3B8) : (hasMissingPrereq ? const Color(0xFFCBD5E1) : const Color(0xFF1B64F2)),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              ),
                              child: Text(isApplied ? "신청완료" : "신청", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
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
        ],
      ),
    );
  }
}