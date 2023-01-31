import 'package:e_reader_app/util/constants/app_string_constants.dart';
import 'package:e_reader_app/view/home/home_page.dart';
import 'package:e_reader_app/view/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

int? isViewed;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStringConstant.appName,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: isViewed != 0 ? OnBoardingPage() : const HomePage(),
    );
  }
}