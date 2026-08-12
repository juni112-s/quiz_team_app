
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_4team_app/view/homes/bmi.dart';
import 'package:quiz_4team_app/view/gps/gps_map.dart';

class Clinic extends StatefulWidget {
  const Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  late List<Map<String, dynamic>> categories;



  @override
  void initState() {
    super.initState();
    categories = [
      {'title': 'Cardiology', 'icon': Icons.favorite_border},
      {'title': 'Dermatology', 'icon': Icons.clean_hands_outlined},
      {'title': 'Medicine', 'icon': Icons.medical_services_outlined},
      {'title': 'Gynecology', 'icon': Icons.person_outline},
    ];
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
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(()=>GpsMap());
                        },
                        icon: Icon(Icons.location_on),
                        color: Colors.white,
                        iconSize: 30,),
                        SizedBox(width: 50,),
                      IconButton(
                        onPressed: () {
                        Get.to(()=>Bmi());
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    //
                  },
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      var item = categories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF00C9C8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 12),
                            Text(
                              item['title'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}