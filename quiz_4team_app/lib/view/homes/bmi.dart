import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Bmi extends StatefulWidget {
  const Bmi({super.key});

  @override
  State<Bmi> createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  // 입력 데이터 상태 변수
  String selectedGender = 'Female';
  double age = 26;
  double weight = 75;
  double height = 178;
  String selectedBloodType = 'AB +';

  // 혈액형 선택 목록
  List<String> bloodTypes = ['A +', 'A -', 'B +', 'B -', 'O +', 'O -', 'AB +', 'AB -'];

  // -------------------------------------------------------------
  // 이벤트 핸들러 스텁 함수 (추후 로직 작성 영역)
  // -------------------------------------------------------------
  void selectGender(String gender) {
      selectedGender = gender;
    setState(() {});
  }

  void updateAge(double value) {
      age = value;
    setState(() {});
  }

  void updateWeight(double value) {
      weight = value;
    setState(() {});
  }

  void updateHeight(double value) {
      height = value;
    setState(() {});
  }

  void updateBloodType(String? value) {
    if (value != null) {
        selectedBloodType = value;
      setState(() {});
    }
  }

  // void saveRecord() {

  //   // 저장 로직 구현 예정 위치
  // }

  // -------------------------------------------------------------
  // UI 레이아웃 빌드
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '+ Add Record',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 성별 선택 영역 (What is your gender)
              Text(
                'What is your gender',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildGenderButton('Male'),
                  buildGenderButton('Female'),
                  buildGenderButton('Other'),
                ],
              ),
              SizedBox(height: 28),

              
              // 2. 나이 슬라이더 (How old are you)
              Text(
                'How old are you',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Slider(
                value: age,
                min: 0,
                max: 100,
                activeColor: Color(0xFF00C9C8),
                inactiveColor: Colors.grey.shade300,
                onChanged: updateAge,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${age.round()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C9C8),
                      ),
                    ),
                    Text('100', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              SizedBox(height: 28),

              // 3. 체중 슬라이더 (What is your weight)
              Text(
                'What is your weight',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Slider(
                value: weight,
                min: 0,
                max: 200,
                activeColor: Color(0xFF00C9C8),
                inactiveColor: Colors.grey.shade300,
                onChanged: updateWeight,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${weight.round()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C9C8),
                      ),
                    ),
                    Text('200', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              SizedBox(height: 28),

              // 4. 신장 슬라이더 (What is your height)
              Text(
                'What is your height',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Slider(
                value: height,
                min: 0,
                max: 200,
                activeColor: Color(0xFF00C9C8),
                inactiveColor: Colors.grey.shade300,
                onChanged: updateHeight,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${height.round()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C9C8),
                      ),
                    ),
                    Text('200', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              SizedBox(height: 28),

              // 5. 혈액형 선택 영역 (What is your blood type)
              Text(
                'What is your blood type',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFEBF7F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedBloodType,
                    icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF00C9C8)),
                    items: bloodTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(
                            color: Color(0xFF00C9C8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: updateBloodType,
                  ),
                ),
              ),

              SizedBox(height: 40),

              // 6. 저장 버튼 (Save)
              Center(
                child: SizedBox(
                  width: 160,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: saveRecord,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF00C9C8), width: 1.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xFF00C9C8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 성별 버튼 빌더 위젯
  Widget buildGenderButton(String gender) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => selectGender(gender),
      child: Container(
        width: 95,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF00C9C8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF00C9C8),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              color: isSelected ? Colors.white : Color(0xFF00C9C8),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }//build

  //==============function================
    void saveRecord() {
      GetStorage box = GetStorage();

      box.write('gender', selectedGender);
      box.write('age', age.round());
      box.write('weight', weight.round());
      box.write('height', height.round());
      box.write('bloodType', selectedBloodType);

      Get.snackbar(
        '저장 완료', 
        '신체 정보가 정상적으로 저장되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white);

        Navigator.pop(context);
  }
  


}