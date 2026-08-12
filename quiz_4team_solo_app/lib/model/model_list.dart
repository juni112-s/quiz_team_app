// 오늘의 할일 모델

class TodoItem{
  String id;
  String title;
  bool isCompleted;
  DateTime date;

  TodoItem({
    required this.date,
    required this.id,
    required this.title,
    required this.isCompleted
    }
  );
}


// 습관 체크리스트 모델
class HabitItem{
  String id;
  String title;
  bool isCompleted;
  int streakCount;

  HabitItem({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.streakCount
  });
}

// 병원 예약 및 진료 날짜 모델
class AppointmentItem{
  String id;
  String hospitalName;
  String? department; // 진료 과목 (옵션)
  DateTime appointmentDateTime;
  String? memo;

  AppointmentItem({
    required this.id,
    required this.hospitalName,
    required this.department,
    required this.appointmentDateTime,
    required this.memo
  });
}

// 신체 정보 모델
class BodyMetrics{
  int age;
  double weight;
  double height;
  double bmi;
  String man;

  BodyMetrics({
    required this.age,
    required this.bmi,
    required this.height,
    required this.weight,
    required this.man

  });
}

// 사용자 전체 모델 [통합]
class UserModel {
  String id;
  String name;
  BodyMetrics bodyMetrics; // 신체 정보
  List<TodoItem> todoList; // 할 일 리스트
  List<HabitItem> habitList; // 습관 리스트
  List<AppointmentItem> appointmentList; // 병원 예약 리스트

  UserModel({
    required this.id,
    required this.name,
    required this.bodyMetrics,
    List<TodoItem>? todoList,
    List<HabitItem>? habitList,
    List<AppointmentItem>? appointmentList,
  })  : todoList = todoList ?? [],
        habitList = habitList ?? [],
        appointmentList = appointmentList ?? [];
}