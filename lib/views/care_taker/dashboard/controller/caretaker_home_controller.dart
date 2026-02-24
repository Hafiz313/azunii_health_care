import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Medication/controller/medication_controller.dart';
import '../../Notes/controller/notes_controller.dart';

class CareTakerHomeController extends GetxController {
  late PageController pageController;
  RxInt currentIndex = 0.obs;

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
    // Refresh the target page's data
    _onPageBecameVisible(index);
  }

  void onPageChanged(int index) {
    // Only update index — refresh is handled by changePage
    currentIndex.value = index;
  }
  
  /// Directly tell the target controller to refresh if needed
  void _onPageBecameVisible(int index) {
    switch (index) {
      case 1: // Medication tab
        if (Get.isRegistered<MedicationController>()) {
          Get.find<MedicationController>().refreshIfNeeded();
        }
        break;
      case 2: // Notes tab
        if (Get.isRegistered<NotesController>()) {
          Get.find<NotesController>().refreshIfNeeded();
        }
        break;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}