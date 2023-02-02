
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/onboarding/onboarding_info.dart';
import '../../util/constants/assets_constants.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onBoardingPages.length - 1;
  var pageNavigation = PageController();
  forwardAction() {
    if (!isLastPage) {
      pageNavigation.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    } else {
      pageNavigation.page;
    }
  }

  List<OnBoardingInfo> onBoardingPages = [
    OnBoardingInfo('E-Reader', 'Awesome E-Reader App', AssetsConstants.logo),
    OnBoardingInfo('Offline Read', 'Offline support is provided', AssetsConstants.logo),
    OnBoardingInfo('Preview File', 'Upload and previews file', AssetsConstants.logo),
  ];
}
