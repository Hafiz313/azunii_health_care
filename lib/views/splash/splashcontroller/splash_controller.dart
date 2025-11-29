import 'package:Azunii_Health/consts/appconsts.dart';
import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/static_user_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/local_storage_service.dart';
import '../../care_taker/dashboard/dashboard.dart';
import '../../patient/dashboard/patient_dashboard.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  /// Check login status and navigate accordingly
  Future<void> checkLoginAndNavigate(BuildContext context) async {
    try {
      // Check if user is logged in
      final isLoggedIn = await LocalStorageService.getLoginStatus();

      if (isLoggedIn) {
        // Fetch profile info on app start
        try {
          final profileResult = await _authRepository.getProfileInfo();
          if (profileResult.status) {
            Staticdata.userModel = profileResult.user;
            print('✅ Profile info loaded from splash');
          }
        } catch (e) {
          print('⚠️ Failed to fetch profile info on splash: $e');
        }

        // Get user type and navigate to appropriate dashboard
        final userType = await LocalStorageService.getUserType();

        if (userType == Appconsts.patient) {
          Navigator.of(context)
              .pushReplacementNamed(PatientDashboard.routeName);
        } else if (userType == Appconsts.caregiver) {
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
