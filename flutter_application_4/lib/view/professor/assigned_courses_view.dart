import 'package:flutter/material.dart';
import '../../model/models.dart';

class AssignedCoursesView extends StatefulWidget {
  final String profCode;

  const AssignedCoursesView({
    super.key,
    this.profCode = 'P001',
  });

  @override
  State<AssignedCoursesView> createState() => _AssignedCoursesViewState();
}

class _AssignedCoursesViewState extends State<AssignedCoursesView> {
  int _tabIndex = 0;
  final List<String> _tabs = ["진행중", "예정", "종료"];

  void _showCourseDetailModal(CourseSection sec) {
    final course = sec.course;
    final enrolledStudents = Enrollment.list
        .where((e) => e.sectionCode == sec.sectionCode && e.status != '취소')
        .map((e) => Student.list.firstWhere(
              (s) => s.studentId == e.studentId,
              orElse: () => Student(studentId: e.studentId, deptCode: '', name: '알 수 없음', phone: '', grade: 1, academicStatus: '', maxCredits: 0, password: ''),
            ))
        .toList();

    final materials = CourseMaterial.list.where((m) => m.sectionCode == sec.sectionCode).toList();

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
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              maxChildSize: 0.9,
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
                      const SizedBox(height: 6),
                      Text("강의실: ${sec.classroomString} | 시간: ${sec.scheduleString}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("등록된 과목 자료 (${materials.length})", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          TextButton(
                            onPressed: () {
                              _showAddMaterialDialog(sec.sectionCode, () {
                                setModalState(() {});
                                setState(() {});
                              });
                            },
                            child: const Text("+ 자료 추가", style: TextStyle(color: Color(0xFF1B64F2), fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (materials.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                          child: const Text("등록된 학습 자료가 없습니다.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                        )
                      else
                        ...materials.map((m) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(m.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text(m.uploadDate, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(m.description, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                ],
                              ),
                            )),
                      const SizedBox(height: 20),
                      Text("수강생 명단 (${enrolledStudents.length} / ${sec.capacity}명)", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                      const SizedBox(height: 10),
                      if (enrolledStudents.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                          child: const Text("신청한 수강생이 없습니다.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                        )
                      else
                        ...enrolledStudents.map((stu) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(radius: 16, backgroundColor: Color(0xFFEFF6FF), child: Icon(Icons.person, size: 18, color: Color(0xFF1B64F2))),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${stu.name} (${stu.studentId})", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                        Text("${stu.departmentName} ${stu.grade}학년 | ${stu.phone}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
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

  void _showAddMaterialDialog(String? preSelectedSectionCode, [VoidCallback? onAdded]) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedSec = preSelectedSectionCode ?? CourseSection.list.where((s) => s.profCode == widget.profCode).first.sectionCode;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final mySections = CourseSection.list.where((s) => s.profCode == widget.profCode).toList();

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("과목 자료 등록", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("대상 과목", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSec,
                          isExpanded: true,
                          items: mySections.map((s) {
                            return DropdownMenuItem(
                              value: s.sectionCode,
                              child: Text("${s.course.courseName} (${s.division}분반)"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedSec = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text("자료 제목", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "예: 1주차 강의 계획서 및 실습자료",
                        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text("상세 내용 / 설명", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "자료에 대한 상세 안내사항을 적어주세요.",
                        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소", style: TextStyle(color: Color(0xFF64748B))),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("자료 제목을 입력해주세요.")));
                      return;
                    }
                    setState(() {
                      CourseMaterial.list.add(
                        CourseMaterial(
                          id: DateTime.now().millisecondsSinceEpoch,
                          sectionCode: selectedSec,
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          uploadDate: '2026-08-19',
                        ),
                      );
                    });
                    Navigator.pop(context);
                    onAdded?.call();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("과목 자료가 성공적으로 등록되었습니다!")));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B64F2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text("등록", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mySections = CourseSection.list.where((s) => s.profCode == widget.profCode).toList();

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
        title: const Text("담당 과목", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 48,
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = _tabIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tabIndex = index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_tabs[index]} (${index == 0 ? mySections.length : 0})",
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF1B64F2) : const Color(0xFF64748B),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          Container(margin: const EdgeInsets.only(top: 8), height: 2, width: 40, color: const Color(0xFF1B64F2)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: mySections.isEmpty
                ? const Center(child: Text("담당 중인 과목이 없습니다.", style: TextStyle(color: Color(0xFF94A3B8))))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: mySections.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final sec = mySections[index];
                      return InkWell(
                        onTap: () => _showCourseDetailModal(sec),
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
                                        child: Text("${sec.division}분반", style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                                ],
                              ),
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
                              Text("수강생 ${sec.enrolled}명 / 정원 ${sec.capacity}명", style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showAddMaterialDialog(null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B64F2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text("+ 과목 자료 등록", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}