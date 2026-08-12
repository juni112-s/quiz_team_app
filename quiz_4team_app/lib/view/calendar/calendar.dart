import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

   // Property
  late DateTime covidDate;
  late DateTime tetanusDate;
  late DateTime typusDate;
  late DateTime hepatitisDate;

  late DateTime hpvDate;
  late DateTime secondDoseDate;
  late DateTime thirdDoseDate;


  @override
  void initState() {
    super.initState();

    covidDate = DateTime(2020, 8, 18);
    tetanusDate = DateTime(2019, 2, 9);
    typusDate = DateTime(2018, 6, 22);
    hepatitisDate = DateTime(2017, 9, 15);

    hpvDate = DateTime(2024, 2, 18);
    secondDoseDate = DateTime(2024, 3, 18);
    thirdDoseDate = DateTime.now();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8), // 메인 민트 색상
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Medical Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vaccinations',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30,),

            Divider(),

            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    'Immunisation history',
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('Y'),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('M'),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('D'),
                  ),
                ),
              ],
            ),

            Divider(),

            dateSearch(
              '독감 접종일',
              covidDate,
              (value) {
                covidDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              '파상풍 접종일',
              tetanusDate,
              (value) {
                tetanusDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'A형 간염 접종일',
              typusDate,
              (value) {
                typusDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'B형 간염 접종일',
              hepatitisDate,
              (value) {
                hepatitisDate = value;
              },
            ),
            SizedBox(height: 50,),

            Divider(),

            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    'Next Immunisations due',
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('Y'),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('M'),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('D'),
                  ),
                ),
              ],
            ),

            Divider(),

            dateSearch(
              'HPV 접종 예정일',
              hpvDate,
              (value) {
                hpvDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              '독감 접종 예정일',
              secondDoseDate,
              (value) {
                secondDoseDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              '파상풍 접종 예정일',
              thirdDoseDate,
              (value) {
                thirdDoseDate = value;
              },
            ),
          ],
        ),
      ),
    );
  } // build


  // --- Functions ---

  Widget dateSearch(
    String title,
    DateTime date,
    Function(DateTime) changeDate,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return Container(
                  height: 250,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: date,
                    onDateTimeChanged: (value) {
                      changeDate(value);
                      setState(() {});
                    },
                  ),
                );
              },
            );
          },
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    date.year
                        .toString()
                        .substring(2),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    date.month
                        .toString()
                        .padLeft(2, '0'),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    date.day
                        .toString()
                        .padLeft(2, '0'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


///// 11시 50분 수정