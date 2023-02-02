// @dart=2.9
import 'package:e_reader_app/util/constants/app_pref.dart';
import 'package:e_reader_app/util/constants/app_string_constants.dart';
import 'package:e_reader_app/view/dashboard/DashboardPage.dart';
import 'package:e_reader_app/view/home/home_page.dart';
import 'package:e_reader_app/view/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/book/book_model.dart';

int isViewed;
AppPref appPref = Get.put(AppPref());
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt(appPref.onBoardingPref);

  await Hive.initFlutter();
  Hive.registerAdapter(BookModelAdapter());
  await Hive.openBox<BookModel>(AppStringConstant.hiveBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStringConstant.appName,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: isViewed != 0 ? OnBoardingPage() : const DashboardPage(),
    );
  }
}