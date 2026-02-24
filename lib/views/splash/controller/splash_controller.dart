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
      
      print('🔍 Splash: isLoggedIn = $isLoggedIn');

      if (isLoggedIn) {
        // Verify token exists
        final token = await LocalStorageService.getToken();
        print('🔍 Splash: token exists = ${token != null && token.isNotEmpty}');
        
        if (token == null || token.isEmpty) {
          print('⚠️ Splash: No valid token found, going to login');
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
          return;
        }

        // Fetch profile info on app start to verify token is valid
        try {
          final profileResult = await _authRepository.getProfileInfo();
          if (profileResult.status) {
            Staticdata.userModel = profileResult.user;
            print('✅ Profile info loaded from splash: ${Staticdata.userModel?.name}');
          } else {
            print('⚠️ Profile fetch failed, going to login');
            // Profile fetch failed, token might be invalid
            await LocalStorageService.logout();
            Navigator.of(context).pushReplacementNamed(LoginView.routeName);
            return;
          }
        } catch (e) {
          print('⚠️ Failed to fetch profile info on splash: $e');
          // API call failed, token might be invalid
          await LocalStorageService.logout();
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
          return;
        }

        // Get user type and navigate to appropriate dashboard
        final userType = await LocalStorageService.getUserType();
        print('🔍 Splash: userType = $userType');

        if (userType == 'patient') {
          print('✅ Navigating to Patient Dashboard');
          Navigator.of(context)
              .pushReplacementNamed(PatientDashboard.routeName);
        } else if (userType == Appconsts.caregiver) {
          print('✅ Navigating to Caregiver Dashboard');
          Navigator.of(context)
              .pushReplacementNamed(CareTakerDashboard.routeName);
        } else {
          // Unknown user type, go to login
          print('⚠️ Unknown user type, going to login');
          await LocalStorageService.logout();
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
        }
      } else {
        // Not logged in, go to login
        print('✅ Not logged in, going to login');
        Navigator.of(context).pushReplacementNamed(LoginView.routeName);
      }
    } catch (e) {
      // Error occurred, go to login as fallback
      print('❌ Splash error: $e');
      await LocalStorageService.logout();
      Navigator.of(context).pushReplacementNamed(LoginView.routeName);
    }
  }
}
