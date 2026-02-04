import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareTakerHomeController extends GetxController {
  late PageController pageController;
  RxInt currentIndex = 0.obs;
  
  // Callback to refresh current page
  final RxInt refreshTrigger = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Trigger refresh when page changes
    _triggerPageRefresh();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    // Trigger refresh when page changes
    _triggerPageRefresh();
  }
  
  void _triggerPageRefresh() {
    // Increment to trigger refresh in pages that listen to this
    refreshTrigger.value++;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}