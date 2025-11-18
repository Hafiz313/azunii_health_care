import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import '../../care_taker/dashboard/dashboard.dart';
import '../../patient/dashboard/patient_dashboard.dart';

class SplashController extends GetxController {
  /// Check login status and navigate accordingly
  Future<void> checkLoginAndNavigate(BuildContext context) async {
    try {
      // Check if user is logged in
      final isLoggedIn = StorageService().getData('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // Get user type and navigate to appropriate dashboard
        final userType = StorageService().getData('userType');

        if (userType == 'patient') {
          Navigator.of(context)
              .pushReplacementNamed(PatientDashboard.routeName);
        } else if (userType == 'caregiver') {
          Navigator.of(context)
              .pushReplacementNamed(CareTakerDashboard.routeName);
        } else {
          // Unknown user type, go to login
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
        }
      } else {
        // Not logged in, go to login
        Navigator.of(context).pushReplacementNamed(LoginView.routeName);
      }
    } catch (e) {
      // Error occurred, go to login as fallback
      Navigator.of(context).pushReplacementNamed(LoginView.routeName);
    }
  }
}
