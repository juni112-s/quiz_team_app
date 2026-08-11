import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Medical Record'
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
                    child: Text('D'),
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
                    child: Text('Y'),
                  ),
                ),
              ],
            ),

            Divider(),

            dateSearch(
              'Covid',
              covidDate,
              (value) {
                covidDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'Tetanus',
              tetanusDate,
              (value) {
                tetanusDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'Typus',
              typusDate,
              (value) {
                typusDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'Hepatitis',
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
                    child: Text('D'),
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
                    child: Text('Y'),
                  ),
                ),
              ],
            ),

            Divider(),

            dateSearch(
              'Human Papillomavirus (HPV)',
              hpvDate,
              (value) {
                hpvDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'Second Dose',
              secondDoseDate,
              (value) {
                secondDoseDate = value;
              },
            ),
            SizedBox(height: 15),
            dateSearch(
              'Third Dose',
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
                    date.day
                        .toString()
                        .padLeft(2, '0'),
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
                    date.year
                        .toString()
                        .substring(2),
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