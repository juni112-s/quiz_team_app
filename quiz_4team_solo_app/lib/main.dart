import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_4team_app/view/login_home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
