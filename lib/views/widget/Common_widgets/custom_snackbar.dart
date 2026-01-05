import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show(
    String message, {
    bool isSuccess = false,
  }) {
    if (Get.isSnackbarOpen) {
      Get.back(); // close previous snackbar
    }

    Get.snackbar(
      isSuccess ? 'Success' : 'Error',
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: isSuccess
          ? const Color.fromARGB(147, 76, 175, 79)
          : const Color.fromARGB(165, 244, 67, 54),
      colorText: Colors.white,
      borderRadius: 12,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 5),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
      icon: Icon(
        isSuccess ? Icons.check_circle : Icons.error,
        color: Colors.white,
      ),
      shouldIconPulse: false,
    );
  }
}
