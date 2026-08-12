import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_4team_app/model/model_list.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  
  // Property
  late List<AppointmentItem> appointmentList;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    appointmentList = [
      AppointmentItem(
        title: '독감 접종일',
        appointmentDateTime: DateTime(
          box.read('appointment1Year') ?? 2020,
          box.read('appointment1Month') ?? 8,
          box.read('appointment1Day') ?? 18,
        ),
      ),
      AppointmentItem(
        title: '파상풍 접종일',
        appointmentDateTime: DateTime(
          box.read('appointment2Year') ?? 2019,
          box.read('appointment2Month') ?? 2,
          box.read('appointment2Day') ?? 9,
        ),
      ),
      AppointmentItem(
        title: 'A형 간염 접종일',
        appointmentDateTime: DateTime(
          box.read('appointment3Year') ?? 2018,
          box.read('appointment3Month') ?? 6,
          box.read('appointment3Day') ?? 22,
        ),
      ),
      AppointmentItem(
        title: 'B형 간염 접종일',
        appointmentDateTime: DateTime(
          box.read('appointment4Year') ?? 2017,
          box.read('appointment4Month') ?? 9,
          box.read('appointment4Day') ?? 15,
        ),
      ),
      AppointmentItem(
        title: 'HPV 접종 예정일',
        appointmentDateTime: DateTime(
          box.read('appointment5Year') ?? 2024,
          box.read('appointment5Month') ?? 2,
          box.read('appointment5Day') ?? 18,
        ),
      ),
      AppointmentItem(
        title: '독감 접종 예정일',
        appointmentDateTime: DateTime(
          box.read('appointment6Year') ?? 2024,
          box.read('appointment6Month') ?? 3,
          box.read('appointment6Day') ?? 18,
        ),
      ),
      AppointmentItem(
        title: '파상풍 접종 예정일',
        appointmentDateTime: DateTime(
          box.read('appointment7Year') ?? DateTime.now().year,
          box.read('appointment7Month') ?? DateTime.now().month,
          box.read('appointment7Day') ?? DateTime.now().day,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
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

            Column(
              children: List.generate(
                4,
                (index) {
                  return Column(
                    children: [
                      dateSearch(
                        appointmentList[index],
                        index,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 35,),

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

            Column(
              children: List.generate(
                3,
                (index) {
                  return Column(
                    children: [
                      dateSearch(
                        appointmentList[index + 4],
                        index + 4,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Functions ---

  Widget dateSearch(
    AppointmentItem item,
    int index,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            item.title,
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
                    initialDateTime:
                        item.appointmentDateTime,
                    onDateTimeChanged: (value) {
                      item.appointmentDateTime = value;
                      box.write('appointment${index + 1}Year', value.year,);
                      box.write('appointment${index + 1}Month', value.month,);
                      box.write('appointment${index + 1}Day', value.day,);

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
                    item.appointmentDateTime.year
                        .toString()
                        .substring(2),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    item.appointmentDateTime.month
                        .toString()
                        .padLeft(2, '0'),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    item.appointmentDateTime.day
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