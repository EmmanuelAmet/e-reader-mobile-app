import 'package:e_reader_app/view/home/upload_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var currentIndex = 0;
  final pages = [
    Center(),
    UploadPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: AppColors.pageBg,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        //selectedItemColor: AppColors.primary,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cloud_upload),
            label: "Upload",
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }
}
