import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../utils/localStorage/storage_service.dart';
import '../../../../utils/localStorage/storage_consts.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../auth/login/login_view.dart';

class HomeController_caregiver extends GetxController {
  final RxString selectedDate = '09-12-2025'.obs;
  final RxString userName = ''.obs;
  final RxString userProfileImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Static data - no storage needed
    userName.value = 'Dr. Sarah Wilson';
    userProfileImage.value = '';
  }

  List<Map<String, dynamic>> get todayTasks => [
        {
          'backgroundColor': const Color.fromARGB(255, 181, 218, 244),
          'icon': FaIcon(
            FontAwesomeIcons.pills,
            color: Colors.blue[600],
            size: 24,
          ),
          'title': Lang.takeMedDaily,
          'isCompleted': true,
        },
        {
          'backgroundColor': AppColors.lightOrange,
          'icon': Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange[300],
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'X',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          'title': Lang.doNotTakeMed,
          'isCompleted': true,
        },
        {
          'backgroundColor': AppColors.lightGreenCard,
          'icon': FaIcon(
            FontAwesomeIcons.clipboardList,
            color: AppColors.green,
            size: 24,
          ),
          'title': Lang.limitedExercise,
          'isCompleted': true,
        },
        {
          'backgroundColor': AppColors.lightPurple,
          'icon': FaIcon(
            FontAwesomeIcons.clipboardList,
            color: Colors.purple[600],
            size: 24,
          ),
          'title': Lang.limitedExercise,
          'isCompleted': true,
        },
      ];

  List<Map<String, String>> get appointments => [
        {
          'date': '09-12-2025',
          'doctor': 'Dr. James Ray',
          'reason': 'Headache',
          'specialty': 'Neurologist',
        },
        {
          'date': '10-12-2025',
          'doctor': 'Dr. Sarah Wilson',
          'reason': 'Check-up',
          'specialty': 'General Physician',
        },
        {
          'date': '15-12-2025',
          'doctor': 'Dr. Michael Brown',
          'reason': 'Blood Test',
          'specialty': 'Pathologist',
        },
      ];

  void updateDate(String date) {
    selectedDate.value = date;
  }

  void onDatePickerTap() {
    // Handle date picker logic
  }

  void onViewAllTap() {
    // Handle view all appointments
  }

  /// Logout functionality
  Future<void> logout() async {
    try {
      StorageService().removeData('isLoggedIn');
      StorageService().removeData('userType');
      Get.offAllNamed(LoginView.routeName);
    } catch (e) {
      // Handle logout error silently
    }
  }
}
