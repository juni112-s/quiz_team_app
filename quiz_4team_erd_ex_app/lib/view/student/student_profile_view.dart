import 'package:flutter/material.dart';
import '../../model/models.dart';
import '../login_view.dart';

class StudentProfileView extends StatefulWidget {
  final String studentId;

  const StudentProfileView({
    super.key,
    required this.studentId,
  });

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {
  @override
  Widget build(BuildContext context) {
    final student = Student.list.firstWhere(
      (s) => s.studentId == widget.studentId,
      orElse: () => Student(
        studentId: widget.studentId,
        deptCode: 'CSE',
        name: '홍길동',
        phone: '010-0000-0000',
        grade: 3,
        academicStatus: '재학',
        maxCredits: 18,
        password: '1234',
      ),
    );

    final advisor = Professor.list.firstWhere(
      (p) => p.profCode == student.advisorCode,
      orElse: () => Professor(
        profCode: '',
        deptCode: '',
        name: '배정 미정',
        phone: '-',
        officeRoom: '-',
        status: '-',
      ),
    );

    final studentEnrollments = Enrollment.list.where((e) => e.studentId == widget.studentId).toList();
    final takingCourses = studentEnrollments.where((e) => e.status == '수강중').toList();
    final completedCourses = studentEnrollments.where((e) => e.status == '수강완료').toList();

    int currentCredits = takingCourses.fold(0, (sum, e) => sum + e.section.course.credits);
    int completedCredits = completedCourses.fold(0, (sum, e) => sum + e.section.course.credits);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.person, size: 40, color: Color(0xFF1B64F2)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: student.academicStatus == '재학' ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              student.academicStatus,
                              style: TextStyle(
                                color: student.academicStatus == '재학' ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("${student.departmentName} • ${student.grade}학년", style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      Text("학번: ${student.studentId}", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 학적 상세 정보
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("학적 및 기본 정보", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                _infoRow("소속 학과", student.departmentName),
                _infoRow("학년 / 과정", "${student.grade}학년 (학사과정)"),
                _infoRow("학적 상태", student.academicStatus),
                _infoRow("전화번호", student.phone),
                _infoRow("지도교수", "${advisor.name} 교수 (${advisor.officeRoom})"),
                _infoRow("최대 신청가능학점", "${student.maxCredits}학점"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 수강 학점 통계 카드
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const Text("현재 신청 학점", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("$currentCredits / ${student.maxCredits}학점", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B64F2))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const Text("기이수 완료 학점", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("$completedCredits 학점", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 현재 수강 과목 목록
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
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
                    const Text("현재 수강 중인 과목", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    Text("${takingCourses.length}과목", style: const TextStyle(color: Color(0xFF1B64F2), fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                if (takingCourses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("현재 수강 신청된 과목이 없습니다.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                  )
                else
                  ...takingCourses.map((e) {
                    final sec = e.section;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sec.course.courseName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text("${sec.professor.name} 교수 • ${sec.classroomString}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                            child: Text("${sec.course.credits}학점", style: const TextStyle(color: Color(0xFF1B64F2), fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 로그아웃
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}