import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // Variables
  final pageController = PageController();
  // Current state of current design, obs change design without stateful widget
  Rx<int> currentPageIndex = 0.obs;

  // Update the current Index when Page Scrolls
  void updatePageIndicator(index) {
    currentPageIndex.value = index;
  }

  // Jump to the specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Update Current Index & Jump to next page
  void nextPage() {
    // At the end of screen
    if (currentPageIndex.value == 3) {
      final storage = GetStorage();
      storage.write('isFirstTime', false);
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  // Update current Index & Jump to the last page
  void skipPage() {
    currentPageIndex.value = 3;
    pageController.jumpToPage(3);
  }
}
