
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_4team_app/view/homes/bmi.dart';
import 'package:quiz_4team_app/view/gps/gps_map.dart';

class Clinic extends StatefulWidget {
  const Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  final box = GetStorage();
  late TextEditingController iDController;
  late TextEditingController passWordController;

  late double age;
  late double weight;
  late double height;

  late String selectedGender;     // 성별
  late String selectedBloodType;   // 혈액형

//  late List<Map<String, dynamic>> categories;
  late bool  button2Vible;


  @override
  void initState() {
    super.initState();
  bool isLoggedIn = box.read('isLoggedIn') ?? false;
    // categories = [
    //   {'title': 'Cardiology', 'icon': Icons.favorite_border},
    //   {'title': 'Dermatology', 'icon': Icons.clean_hands_outlined},
    //   {'title': 'Medicine', 'icon': Icons.medical_services_outlined},
    //   {'title': 'Gynecology', 'icon': Icons.person_outline},
    // ];
    button2Vible = !isLoggedIn;
    iDController = TextEditingController();
    passWordController = TextEditingController();
    loginStorage();
    loadData();
  }

void loadData() {
  selectedGender = box.read('gender') ?? '선택 안됨';
  age = (box.read('age') ?? 0).toDouble();
  weight = (box.read('weight') ?? 0).toDouble();
  height = (box.read('height') ?? 0).toDouble();
  selectedBloodType = box.read('bloodType') ?? '선택 안됨';
  setState(() {});
}


  void loginStorage(){
      box.write('user', '');
      box.write('password', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      
      body: Center(
        child: Column(
          children: [
            // 1. 상단 검색 영역
            Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: Color(0xFF00C9C8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Specialties',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Find Your Doctor',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(()=>GpsMap());
                        },
                        icon: Icon(Icons.location_on),
                        color: Colors.white,
                        iconSize: 30,),
                        SizedBox(width: 200,),
                      IconButton(
                     //   onPressed: () => Get.to(Bmi())?.then((value) => loadData,),
                        onPressed:() {
                          Get.to(() => Bmi())?.then((value) {
                            loadData();
                          },);
                        },
                        icon: Icon(Icons.monitor),
                        color: Colors.white,
                        iconSize: 30,),
                    ],
                  ),
                ],
              ),
            ),

            // 3. GridView 영역
            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20.0),
            //     child: GestureDetector(
            //       onTap: () {
            //         //
            //       },
            //       child: GridView.builder(
            //         itemCount: categories.length,
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2,
            //           crossAxisSpacing: 16,
            //           mainAxisSpacing: 16,
            //           childAspectRatio: 1.15,
            //         ),
            //         itemBuilder: (context, index) {
            //           var item = categories[index];
            //           return Container(
            //             decoration: BoxDecoration(
            //               color: Color(0xFF00C9C8),
            //               borderRadius: BorderRadius.circular(20),
            //             ),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   item['icon'] as IconData,
            //                   size: 40,
            //                   color: Colors.white,
            //                 ),
            //                 SizedBox(height: 12),
            //                 Text(
            //                   item['title'] as String,
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 15,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
//             1. [로그인 성공 시 표시] 유저 건강 프로필 카드
            Visibility(
              visible: !button2Vible, // button2Visible이 false일 때 표시됨
              child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFEBF7F7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFF00C9C8),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    // 이름 표시
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, color: Color(0xFF00C9C8), size: 28),
                        SizedBox(width: 8),
                        Text(
                          '${iDController.text.isNotEmpty ? iDController.text : "User"}님 환영합니다!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C9C8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Color(0xFF00C9C8), thickness: 1),
                    SizedBox(height: 12),

                    // 키, 몸무게, 혈액형 수평 정렬
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('키', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            SizedBox(height: 4),
                            Text('${height.round()} cm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('몸무게', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            SizedBox(height: 4),
                            Text('${weight.round()} kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('혈액형', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            SizedBox(height: 4),
                            Text(selectedBloodType, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
              Visibility(
              visible: button2Vible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: iDController,
                      decoration: InputDecoration(
                        hintText: 'ID를 입력하세요',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: passWordController,
                      decoration: InputDecoration(
                        hintText: 'Pass Word를 입력하세요',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (iDController.text.trim().isNotEmpty && passWordController.text.trim().isNotEmpty) {
                    box.write('isLoggedIn', true); // GetStorage에 로그인 성공 상태 기록
                      button2Vible = false; // 프로필 카드로 전환
                      _showDialog();
                  } else {
                    errorSnackBar();
                  }
                    setState(() {});
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00C9C8),
                foregroundColor: Colors.white,
                shape: BeveledRectangleBorder()
              ),
              child: Text('Log In')
            ),
              ],
            )
          )
        ]
      )
     )
    );
  }

    void errorSnackBar(){
    Get.snackbar(
      "경고", 
      "사용자의 ID와 암호를 입력하세요!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white
      );
  }

//============================DiaLog===============================
  void _showDialog(){
    Get.defaultDialog(
      title: '환영 합니다.',
      middleText: '확인 되었습니다.',
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed:() {
            saveStorage();
            Get.back();
          }, 
          child: Text('종료'))
      ]
    );
  }

    void saveStorage(){
    // write =  저장한다는 개념
    box.write('p_userId', "4team");
    box.write('p_password', "1234");
  }
}