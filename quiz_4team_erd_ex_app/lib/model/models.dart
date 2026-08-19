// 1. 학과 모델
class Department {
  final String deptCode;
  final String deptName;
  final String officeLoc;
  final String phone;

  Department({
    required this.deptCode,
    required this.deptName,
    required this.officeLoc,
    required this.phone,
  });

  static List<Department> list = [
    Department(deptCode: 'CSE', deptName: '컴퓨터공학과', officeLoc: 'IT관 301호', phone: '02-123-4501'),
    Department(deptCode: 'AIE', deptName: '인공지능학과', officeLoc: 'IT관 405호', phone: '02-123-4502'),
    Department(deptCode: 'EEE', deptName: '전자전기공학과', officeLoc: '공학관 201호', phone: '02-123-4503'),
    Department(deptCode: 'SWE', deptName: '소프트웨어학과', officeLoc: 'IT관 302호', phone: '02-123-4504'),
  ];
}

// 2. 교수 모델
class Professor {
  final String profCode;
  final String deptCode;
  final String name;
  final String phone;
  final String officeRoom;
  final String status;

  Professor({
    required this.profCode,
    required this.deptCode,
    required this.name,
    required this.phone,
    required this.officeRoom,
    required this.status,
  });

  static List<Professor> list = [
    Professor(profCode: 'P001', deptCode: 'CSE', name: '김철수', phone: '010-1111-2222', officeRoom: 'IT관 501호', status: '재직'),
    Professor(profCode: 'P002', deptCode: 'CSE', name: '이영희', phone: '010-2222-3333', officeRoom: 'IT관 502호', status: '재직'),
    Professor(profCode: 'P003', deptCode: 'AIE', name: '박민수', phone: '010-3333-4444', officeRoom: 'IT관 503호', status: '재직'),
    Professor(profCode: 'P004', deptCode: 'SWE', name: '정다은', phone: '010-4444-5555', officeRoom: 'IT관 504호', status: '연구년'),
    Professor(profCode: 'P005', deptCode: 'EEE', name: '최진호', phone: '010-5555-6666', officeRoom: '공학관 401호', status: '재직'),
  ];
}

// 3. 학생 모델
class Student {
  final String studentId;
  final String deptCode;
  final String? advisorCode;
  final String name;
  final String phone;
  final int grade;
  final String academicStatus;
  int maxCredits;
  final String password;

  Student({
    required this.studentId,
    required this.deptCode,
    this.advisorCode,
    required this.name,
    required this.phone,
    required this.grade,
    required this.academicStatus,
    required this.maxCredits,
    required this.password,
  });

  static Student? current;

  static List<Student> list = [
    Student(studentId: '20231001', deptCode: 'CSE', advisorCode: 'P001', name: '강동원', phone: '010-9001-1001', grade: 3, academicStatus: '재학', maxCredits: 19, password: '1234'),
    Student(studentId: '20231002', deptCode: 'CSE', advisorCode: 'P002', name: '이지은', phone: '010-9002-1002', grade: 3, academicStatus: '재학', maxCredits: 21, password: '1234'),
    Student(studentId: '20241001', deptCode: 'AIE', advisorCode: 'P003', name: '김선호', phone: '010-9003-1003', grade: 2, academicStatus: '재학', maxCredits: 18, password: '1234'),
    Student(studentId: '20251001', deptCode: 'SWE', advisorCode: 'P001', name: '박보영', phone: '010-9004-1004', grade: 1, academicStatus: '재학', maxCredits: 18, password: '1234'),
    Student(studentId: '20221005', deptCode: 'CSE', advisorCode: 'P002', name: '송중기', phone: '010-9005-1005', grade: 4, academicStatus: '휴학', maxCredits: 0, password: '1234'),
  ];

  String get departmentName {
    final d = Department.list.firstWhere((e) => e.deptCode == deptCode, orElse: () => Department(deptCode: '', deptName: '학과미지정', officeLoc: '', phone: ''));
    return d.deptName;
  }
}

// 4. 선수과목 모델
class Prerequisite {
  final String courseCode;
  final String prereqCode;
  final String isMandatory;

  Prerequisite({
    required this.courseCode,
    required this.prereqCode,
    required this.isMandatory,
  });

  static List<Prerequisite> list = [
    Prerequisite(courseCode: 'CS201', prereqCode: 'CS101', isMandatory: 'Y'),
    Prerequisite(courseCode: 'CS301', prereqCode: 'CS201', isMandatory: 'Y'),
    Prerequisite(courseCode: 'CS302', prereqCode: 'CS201', isMandatory: 'N'),
    Prerequisite(courseCode: 'AI201', prereqCode: 'CS101', isMandatory: 'Y'),
  ];
}

// 5. 과목 모델
class Course {
  final String courseCode;
  final String deptCode;
  final String courseName;
  final int credits;
  final String syllabus;

  Course({
    required this.courseCode,
    required this.deptCode,
    required this.courseName,
    required this.credits,
    required this.syllabus,
  });

  static List<Course> list = [
    Course(courseCode: 'CS101', deptCode: 'CSE', courseName: '컴퓨팅사고및프로그래밍', credits: 3, syllabus: 'Python 기초 문법 및 알고리즘적 사고 훈련'),
    Course(courseCode: 'CS201', deptCode: 'CSE', courseName: '자료구조', credits: 3, syllabus: '선형 및 비선형 자료구조의 이해와 C++ 구현'),
    Course(courseCode: 'CS301', deptCode: 'CSE', courseName: '알고리즘', credits: 3, syllabus: '탐욕법, DP, 그래프 알고리즘 및 복잡도 분석'),
    Course(courseCode: 'CS302', deptCode: 'CSE', courseName: '데이터베이스', credits: 3, syllabus: '관계형 데이터 모델, 정규화, SQL 및 트랜잭션'),
    Course(courseCode: 'AI201', deptCode: 'AIE', courseName: '인공지능개론', credits: 3, syllabus: '머신러닝/딥러닝 기초 개념 및 신경망 구조 실습'),
    Course(courseCode: 'SW301', deptCode: 'SWE', courseName: '소프트웨어공학', credits: 3, syllabus: '애자일 방법론, 디자인 패턴 및 소프트웨어 아키텍처'),
  ];

  List<Prerequisite> get prerequisites =>
      Prerequisite.list.where((p) => p.courseCode == courseCode).toList();
}

// 6. 강의 시간표 모델
class CourseSchedule {
  final int scheduleId;
  final String sectionCode;
  final String dayOfWeek;
  final int startPeriod;
  final int endPeriod;
  final String classroom;

  CourseSchedule({
    required this.scheduleId,
    required this.sectionCode,
    required this.dayOfWeek,
    required this.startPeriod,
    required this.endPeriod,
    required this.classroom,
  });

  static List<CourseSchedule> list = [
    CourseSchedule(scheduleId: 1001, sectionCode: 'SEC2601', dayOfWeek: '월', startPeriod: 3, endPeriod: 4, classroom: 'IT관 201호'),
    CourseSchedule(scheduleId: 1002, sectionCode: 'SEC2601', dayOfWeek: '수', startPeriod: 3, endPeriod: 4, classroom: 'IT관 실습실A'),
    CourseSchedule(scheduleId: 1003, sectionCode: 'SEC2602', dayOfWeek: '화', startPeriod: 1, endPeriod: 2, classroom: 'IT관 202호'),
    CourseSchedule(scheduleId: 1004, sectionCode: 'SEC2602', dayOfWeek: '목', startPeriod: 1, endPeriod: 2, classroom: 'IT관 실습실B'),
    CourseSchedule(scheduleId: 1005, sectionCode: 'SEC2603', dayOfWeek: '화', startPeriod: 5, endPeriod: 7, classroom: 'IT관 301호'),
    CourseSchedule(scheduleId: 1006, sectionCode: 'SEC2604', dayOfWeek: '수', startPeriod: 6, endPeriod: 8, classroom: 'IT관 401호'),
    CourseSchedule(scheduleId: 1007, sectionCode: 'SEC2605', dayOfWeek: '금', startPeriod: 2, endPeriod: 4, classroom: 'IT관 101호'),
  ];
}

// 7. 개설 분반 모델
class CourseSection {
  final String sectionCode;
  final String courseCode;
  final String profCode;
  final int year;
  final String semester;
  final String division;
  final int capacity;
  int enrolled;

  CourseSection({
    required this.sectionCode,
    required this.courseCode,
    required this.profCode,
    required this.year,
    required this.semester,
    required this.division,
    required this.capacity,
    required this.enrolled,
  });

  static List<CourseSection> list = [
    CourseSection(sectionCode: 'SEC2601', courseCode: 'CS201', profCode: 'P001', year: 2026, semester: '1학기', division: '1', capacity: 30, enrolled: 30),
    CourseSection(sectionCode: 'SEC2602', courseCode: 'CS201', profCode: 'P002', year: 2026, semester: '1학기', division: '2', capacity: 30, enrolled: 28),
    CourseSection(sectionCode: 'SEC2603', courseCode: 'CS302', profCode: 'P001', year: 2026, semester: '1학기', division: '1', capacity: 40, enrolled: 38),
    CourseSection(sectionCode: 'SEC2604', courseCode: 'AI201', profCode: 'P003', year: 2026, semester: '1학기', division: '1', capacity: 35, enrolled: 35),
    CourseSection(sectionCode: 'SEC2605', courseCode: 'CS101', profCode: 'P002', year: 2026, semester: '1학기', division: '1', capacity: 50, enrolled: 45),
  ];

  Course get course => Course.list.firstWhere((c) => c.courseCode == courseCode);
  Professor get professor => Professor.list.firstWhere((p) => p.profCode == profCode);
  List<CourseSchedule> get schedules => CourseSchedule.list.where((s) => s.sectionCode == sectionCode).toList();

  String get scheduleString => schedules
      .map((s) => '${s.dayOfWeek} ${s.startPeriod.toString().padLeft(2, '0')}:00 ~ ${s.endPeriod.toString().padLeft(2, '0')}:50')
      .join(', ');

  String get classroomString => schedules.isNotEmpty ? schedules.first.classroom : '';
}

// 8. 수강신청 모델
class Enrollment {
  final int enrollmentId;
  final String studentId;
  final String sectionCode;
  final String applyDate;
  String status;
  int waitOrder;
  String isRetake;
  String? grade;

  Enrollment({
    required this.enrollmentId,
    required this.studentId,
    required this.sectionCode,
    required this.applyDate,
    required this.status,
    required this.waitOrder,
    required this.isRetake,
    this.grade,
  });

  static List<Enrollment> list = [
    Enrollment(enrollmentId: 40001, studentId: '20231001', sectionCode: 'SEC2605', applyDate: '2025-08-20', status: '수강완료', waitOrder: 0, isRetake: 'N', grade: 'B+'),
    Enrollment(enrollmentId: 50001, studentId: '20231001', sectionCode: 'SEC2601', applyDate: '2026-02-18', status: '수강중', waitOrder: 0, isRetake: 'N'),
    Enrollment(enrollmentId: 50002, studentId: '20231001', sectionCode: 'SEC2603', applyDate: '2026-02-18', status: '수강중', waitOrder: 0, isRetake: 'N'),
    Enrollment(enrollmentId: 50003, studentId: '20231002', sectionCode: 'SEC2602', applyDate: '2026-02-18', status: '수강중', waitOrder: 0, isRetake: 'N'),
  ];

  static bool hasPassedCourse(String studentId, String courseCode) {
    return list.any((e) =>
        e.studentId == studentId &&
        e.section.courseCode == courseCode &&
        (e.status == '수강완료' || e.isRetake == 'Y'));
  }

  static bool apply(String studentId, String sectionCode, {String isRetake = 'N'}) {
    final already = list.any((e) => e.studentId == studentId && e.sectionCode == sectionCode && e.status == '수강중');
    if (already) return false;

    final sec = CourseSection.list.firstWhere((s) => s.sectionCode == sectionCode);
    sec.enrolled++;

    list.add(
      Enrollment(
        enrollmentId: DateTime.now().millisecondsSinceEpoch,
        studentId: studentId,
        sectionCode: sectionCode,
        applyDate: '2026-08-19',
        status: '수강중',
        waitOrder: 0,
        isRetake: isRetake,
      ),
    );
    return true;
  }

  static void cancel(String studentId, String sectionCode) {
    final sec = CourseSection.list.firstWhere((s) => s.sectionCode == sectionCode);
    if (sec.enrolled > 0) sec.enrolled--;
    list.removeWhere((e) => e.studentId == studentId && e.sectionCode == sectionCode && e.status == '수강중');
  }

  CourseSection get section => CourseSection.list.firstWhere((s) => s.sectionCode == sectionCode);
}

// 9. 과목 자료 모델
class CourseMaterial {
  final int id;
  final String sectionCode;
  final String title;
  final String description;
  final String uploadDate;

  CourseMaterial({
    required this.id,
    required this.sectionCode,
    required this.title,
    required this.description,
    required this.uploadDate,
  });

  static List<CourseMaterial> list = [
    CourseMaterial(
      id: 1,
      sectionCode: 'SEC2601',
      title: '1주차 강의자료 및 오리엔테이션',
      description: '강의 계획 소개 및 개발 환경 세팅 안내 PDF',
      uploadDate: '2026-03-02',
    ),
    CourseMaterial(
      id: 2,
      sectionCode: 'SEC2603',
      title: 'ERD 설계 가이드라인 및 실습 과제',
      description: '정규화 실습 예제 및 다이어그램 작성법',
      uploadDate: '2026-03-05',
    ),
  ];
}