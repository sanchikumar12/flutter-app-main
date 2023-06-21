import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/splash.dart';
import 'controller/home_controller.dart';

void main() {
  Get.put(HomeController());
  runApp(const GetMaterialApp(home: MyApp(),debugShowCheckedModeBanner: false,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
