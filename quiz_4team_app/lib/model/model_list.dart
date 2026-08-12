import 'package:get_storage/get_storage.dart';

// 1. 신체 건강 정보 모델
class BodyMetrics {
  String gender;
  double age;
  double weight;
  double height;
  String bloodType;

  BodyMetrics({
    this.gender = 'Male',
    this.age = 20,
    this.weight = 80,
    this.height = 180,
    this.bloodType = 'A +',
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'bloodType': bloodType,
    };
  }

  factory BodyMetrics.fromJson(Map<String, dynamic> json) {
    return BodyMetrics(
      gender: json['gender'] as String? ?? 'Male',
      age: (json['age'] as num? ?? 20).toDouble(),
      weight: (json['weight'] as num? ?? 80).toDouble(),
      height: (json['height'] as num? ?? 180).toDouble(),
      bloodType: json['bloodType'] as String? ?? 'A +',
    );
  }
}

// 2. 건강 검진 기록 모델 (Tab 2)
class HealthRecordModel {
  String id;
  String date;
  String title;
  String content;

  HealthRecordModel({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'content': content,
    };
  }

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['id'] as String,
      date: json['date'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}

// 3. 예방접종 일정 모델 (Tab 3)
class VaccinationModel {
  String id;
  String title;
  String date;
  bool isCompleted;

  VaccinationModel({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isCompleted': isCompleted,
    };
  }

  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

// 4. 통합 비즈니스 로직 및 GetStorage 데이터 관리 클래스
class AppModel {
  static GetStorage box = GetStorage();

  // 로그인 상태 확인
  static bool isLoggedIn() {
    return box.read('isLoggedIn') ?? false;
  }

  // 현재 로그인된 유저 ID
  static String getCurrentUserId() {
    return box.read('currentUserId') ?? '';
  }

  // 로그인 처리 (결과 메시지 반환)
  static String login(String id, String password) {
  // String 뒤에 물음표(?)를 붙여 null 값을 허용하도록 수정
    String? savedPw = box.read('user_pw_$id');

  // 가입된 비번이 없으면(null) 존재하지 않는 유저로 처리
    if (savedPw == null) {
      return 'NO_USER'; // 존재하지 않는 유저
    }

    // 비밀번호 비교
    if (savedPw != password) {
      return 'WRONG_PASSWORD'; // 비밀번호 불일치
    }

    // 로그인 성공 시 상태 저장
    box.write('isLoggedIn', true);
    box.write('currentUserId', id);
    return 'SUCCESS';
  }

  // 회원가입 정보 저장
  static void registerUser(String id, String password, String name, String mobile) {
    box.write('user_pw_$id', password);
    box.write('user_name_$id', name);
    box.write('user_mobile_$id', mobile);

    box.write('isLoggedIn', true);
    box.write('currentUserId', id);
  }

  // 로그아웃 처리
  static void logout() {
    box.write('isLoggedIn', false);
    box.write('currentUserId', '');
  }

  // 신체 정보 저장
  static void saveMetrics(BodyMetrics metrics) {
    String userId = getCurrentUserId();
    if (userId.isNotEmpty) {
      box.write('metrics_$userId', metrics.toJson());
    }
  }

  // 신체 정보 불러오기
  static BodyMetrics? getMetrics() {
    String userId = getCurrentUserId();
    if (userId.isEmpty) return null;
    var json = box.read('metrics_$userId');
    if (json == null) return null;
    return BodyMetrics.fromJson(Map<String, dynamic>.from(json));
  }

  // 검사 기록 목록 가져오기 (Tab 2)
  static List<HealthRecordModel> getHealthRecords() {
    String userId = getCurrentUserId();
    if (userId.isEmpty) return [];
    var list = box.read('health_records_$userId') as List<dynamic>?;
    if (list == null) return [];
    return list
        .map((e) => HealthRecordModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // 검사 기록 추가 (Tab 2)
  static void addHealthRecord(String title, String content, String date) {
    String userId = getCurrentUserId();
    if (userId.isEmpty) return;
    List<HealthRecordModel> currentList = getHealthRecords();
    currentList.add(HealthRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      date: date,
    ));
    box.write(
      'health_records_$userId',
      currentList.map((e) => e.toJson()).toList(),
    );
  }

  // 예방접종 목록 가져오기 (Tab 3)
  static List<VaccinationModel> getVaccinations() {
    String userId = getCurrentUserId();
    if (userId.isEmpty) return [];
    var list = box.read('vaccinations_$userId') as List<dynamic>?;
    if (list == null) return [];
    return list
        .map((e) => VaccinationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // 예방접종 기록 추가 (Tab 3)
  static void addVaccination(String title, String date, bool isCompleted) {
    String userId = getCurrentUserId();
    if (userId.isEmpty) return;
    List<VaccinationModel> currentList = getVaccinations();
    currentList.add(VaccinationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
      isCompleted: isCompleted,
    ));
    box.write(
      'vaccinations_$userId',
      currentList.map((e) => e.toJson()).toList(),
    );
  }

  // 예방접종 일자 수정 (Tab 3 CupertinoDatePicker 사용)
  static void updateVaccinationDate(String id, String newDate) {
    String userId = getCurrentUserId();
    if (userId.isEmpty) return;
    List<VaccinationModel> currentList = getVaccinations();
    for (var item in currentList) {
      if (item.id == id) {
        item.date = newDate;
        break;
      }
    }
    box.write(
      'vaccinations_$userId',
      currentList.map((e) => e.toJson()).toList(),
    );
  }
}