import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/model_list.dart';

class Bmi extends StatefulWidget {
  Bmi({super.key});

  @override
  State<Bmi> createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  String selectedGender = 'Male';
  double age = 20;
  double weight = 80;
  double height = 180;
  String selectedBloodType = 'A +';

  List<String> bloodTypes = ['A +', 'A -', 'B +', 'B -', 'O +', 'O -', 'AB +', 'AB -'];

  void saveRecord() {
    BodyMetrics metrics = BodyMetrics(
      gender: selectedGender,
      age: age,
      weight: weight,
      height: height,
      bloodType: selectedBloodType,
    );

    AppModel.saveMetrics(metrics);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C9C8),
        title: Text('+ Set Record', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What is your gender', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Male', 'Female', 'Other'].map((g) {
                bool sel = selectedGender == g;
                return ElevatedButton(
                  onPressed: () => setState(() => selectedGender = g),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sel ? Color(0xFF00C9C8) : Colors.white,
                    foregroundColor: sel ? Colors.white : Color(0xFF00C9C8),
                  ),
                  child: Text(g),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('How old are you: ${age.round()}'),
            Slider(
              value: age,
              min: 0,
              max: 100,
              activeColor: Color(0xFF00C9C8),
              onChanged: (v) => setState(() => age = v),
            ),
            SizedBox(height: 16),
            Text('What is your weight: ${weight.round()} kg'),
            Slider(
              value: weight,
              min: 0,
              max: 200,
              activeColor: Color(0xFF00C9C8),
              onChanged: (v) => setState(() => weight = v),
            ),
            SizedBox(height: 16),
            Text('What is your height: ${height.round()} cm'),
            Slider(
              value: height,
              min: 0,
              max: 200,
              activeColor: Color(0xFF00C9C8),
              onChanged: (v) => setState(() => height = v),
            ),
            SizedBox(height: 16),
            Text('What is your blood type'),
            DropdownButton<String>(
              value: selectedBloodType,
              items: bloodTypes
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => selectedBloodType = v!),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: saveRecord,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C9C8)),
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}