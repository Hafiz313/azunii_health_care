import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';

class FeedbackController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  final RxInt selectedRating = 1.obs;

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  void handleSubmitFeedback() {
    if (noteController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a note before submitting',
        backgroundColor: AppColors.redColor,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Thank you for your feedback!',
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}