import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';

class AdvocacyController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  
  final RxString selectedRelationship = ''.obs;
  final RxBool viewPermission = true.obs;
  final RxBool addNotesPermission = true.obs;

  final List<String> relationships = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Friend',
    'Other Family Member',
    'Healthcare Provider',
  ];

  void setRelationship(String relationship) {
    selectedRelationship.value = relationship;
  }

  void toggleViewPermission(bool value) {
    viewPermission.value = value;
  }

  void toggleAddNotesPermission(bool value) {
    addNotesPermission.value = value;
  }

  void handleSendInvitation() {
    if (emailController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        selectedRelationship.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: AppColors.redColor,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Handle send invitation
    Get.snackbar(
      'Success',
      'Invitation sent successfully!',
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );

    // Go back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}