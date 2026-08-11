import 'package:flutter/material.dart';

class Clinic extends StatefulWidget {
  const Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {'title': 'Cardiology', 'icon': Icons.favorite_border},
      {'title': 'Dermatology', 'icon': Icons.clean_hands_outlined},
      {'title': 'Medicine', 'icon': Icons.medical_services_outlined},
      {'title': 'Gynecology', 'icon': Icons.person_outline},
      {'title': 'Odontology', 'icon': Icons.health_and_safety_outlined},
      {'title': 'Oncology', 'icon': Icons.coronavirus_outlined},
      {'title': 'Ophthalmology', 'icon': Icons.remove_red_eye_outlined},
      {'title': 'Orthopedics', 'icon': Icons.accessibility_new_outlined},
    ];
    return Scaffold(
      appBar: null,
      body: SafeArea(
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF00C9C8)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Sort By 영역
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort By',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Doctors',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00C9C8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 3. GridView 영역
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
          ],
        ),
      ),
    );
  }
}