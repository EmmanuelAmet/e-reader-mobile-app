import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/onboarding/onboarding_controller.dart';
import '../../util/constants/app_color.dart';
import '../../util/constants/app_pref.dart';
import '../dashboard/DashboardPage.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppPref appPref = Get.put(AppPref());

  final _controller = OnBoardingController();
  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(appPref.onBoardingPref, isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                  controller: _controller.pageNavigation,
                  onPageChanged: _controller.selectedPageIndex,
                  itemCount: _controller.onBoardingPages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              _controller.onBoardingPages[index].imageAsset
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _controller.onBoardingPages[index].title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColor.primary
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              _controller.onBoardingPages[index].description,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              Positioned(
                  bottom: 20,
                  left: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          _controller.onBoardingPages.length,
                              (index) => Obx(() {
                            return Container(
                              margin: const EdgeInsets.all(3),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                _controller.selectedPageIndex.value ==
                                    index
                                    ? AppColor.primaryAccent
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            );
                          })),
                    ),
                  )),
              Positioned(
                bottom: 20,
                right: 30,
                child: FloatingActionButton(
                  backgroundColor: AppColor.primaryAccent,
                  onPressed: () {
                    _controller.forwardAction();
                    _controller.isLastPage ? Get.to(() => const DashboardPage()) : null;
                    _storeOnboardInfo();
                  },
                  child: Obx(() {
                    return Text(
                      _controller.isLastPage ? 'Start' : 'Next',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: InkWell(
                    onTap: () {
                      _storeOnboardInfo();
                      Get.to(() => const DashboardPage());
                    },
                    child: Text('Skip'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 18,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ));
  }
}
