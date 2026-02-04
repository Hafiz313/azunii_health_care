import 'package:Azunii_Health/consts/appconsts.dart';
import 'package:Azunii_Health/core/services/google_auth_service.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/core/services/caregiver_state.dart';
import 'package:Azunii_Health/core/repositories/caregiver_dashboard.dart';
import 'package:Azunii_Health/services/fcm_service.dart';
import 'package:Azunii_Health/utils/localStorage/storage_service.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/static_user_model.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';
import '../../../patient/dashboard/patient_dashboard.dart';

class LoginController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isChecked = false.obs;
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final AuthRepository _authRepository = AuthRepository();
  final CaregiverDashboardRepository _caregiverRepository =
      CaregiverDashboardRepository();
  void toggleRememberMe(bool? value) {
    isChecked.value = value ?? false;
  }

  /// STEP 1: Standard login flow
  /// - Validates form
  /// - Gets FCM token (REQUIRED)
  /// - Calls login API with FCM token
  /// - Stores user data and token
  /// - For caregivers: fetches assigned patients before navigation
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    // Get FCM token before login - REQUIRED for notifications
    String? fcmToken;
    try {
      fcmToken = await FCMService.getToken();
      print('🔑 FCM Token for login: $fcmToken');

      // If token is null, try force refresh (handles corrupted token cache)
      if (fcmToken == null || fcmToken.isEmpty) {
        print('⚠️ Initial token fetch failed, trying force refresh...');
        fcmToken = await FCMService.forceRefreshToken();
      }

      // Final check after retry
      if (fcmToken == null || fcmToken.isEmpty) {
        CustomSnackbar.show(
          'Unable to initialize notification service. Please restart the app or check Google Play Services.',
          isSuccess: false,
        );
        return;
      }
    } catch (e) {
      print('❌ Failed to retrieve FCM token: $e');
      
      // Try one more time with force refresh
      try {
        print('🔄 Attempting force token refresh as last resort...');
        fcmToken = await FCMService.forceRefreshToken();
        
        if (fcmToken == null || fcmToken.isEmpty) {
          CustomSnackbar.show(
            'Notification service unavailable. Please restart your device and ensure Google Play Services is updated.',
            isSuccess: false,
          );
          return;
        }
      } catch (retryError) {
        CustomSnackbar.show(
          'Critical: Cannot initialize notifications. Please update Google Play Services.',
          isSuccess: false,
        );
        return;
      }
    }

    final result = await safeApiCall(() => _authRepository.login(
          emailController.text.trim(),
          passwordController.text,
          fcmToken!, // Pass the validated token
        ));

    if (result != null) {
      // Validate user role from API response
      final userRole = result.user?.role;
      if (userRole == null ||
          (userRole != 'patient' && userRole != 'caregiver')) {
        CustomSnackbar.show('Invalid user role received', isSuccess: false);
        return;
      }

      final userType =
          userRole == 'patient' ? Appconsts.patient : Appconsts.caregiver;

      await LocalStorageService.setLoginStatus(true,
          userType: userType, token: result.token);

      // Store user data from login response
      Staticdata.userModel = result.user;

      // STEP 2: Navigate based on user role
      // Patient → Direct to patient dashboard
      // Caregiver → Fetch patients list first, then navigate to caregiver dashboard
      if (userRole == 'patient') {
        Get.offAllNamed(PatientDashboard.routeName);
      } else {
        await _fetchCaregiverPatients();
        Get.offAllNamed(CareTakerDashboard.routeName);
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// STEP 1: Google OAuth login flow
  /// - Authenticates with Google
  /// - Gets FCM token (REQUIRED)
  /// - Calls backend API with Google credentials and FCM token
  /// - Stores user data and token
  /// - For caregivers: fetches assigned patients before navigation
  Future<void> googleLogin() async {
    // Get FCM token before Google login - REQUIRED for notifications
    String? fcmToken;
    try {
      fcmToken = await FCMService.getToken();
      print('🔑 FCM Token for Google login: $fcmToken');

      // If token is null, try force refresh (handles corrupted token cache)
      if (fcmToken == null || fcmToken.isEmpty) {
        print('⚠️ Initial token fetch failed, trying force refresh...');
        fcmToken = await FCMService.forceRefreshToken();
      }

      // Final check after retry
      if (fcmToken == null || fcmToken.isEmpty) {
        CustomSnackbar.show(
          'Unable to initialize notification service. Please restart the app or check Google Play Services.',
          isSuccess: false,
        );
        return;
      }
    } catch (e) {
      print('❌ Failed to retrieve FCM token: $e');
      
      // Try one more time with force refresh
      try {
        print('🔄 Attempting force token refresh as last resort...');
        fcmToken = await FCMService.forceRefreshToken();
        
        if (fcmToken == null || fcmToken.isEmpty) {
          CustomSnackbar.show(
            'Notification service unavailable. Please restart your device and ensure Google Play Services is updated.',
            isSuccess: false,
          );
          return;
        }
      } catch (retryError) {
        CustomSnackbar.show(
          'Critical: Cannot initialize notifications. Please update Google Play Services.',
          isSuccess: false,
        );
        return;
      }
    }

    final result = await safeApiCall(() async {
      final googleData = await _googleAuthService.signInWithGoogle();
      if (googleData.isNotEmpty && googleData['error'] == null) {
        final apiResponse = await _authRepository.googleAuth(
          googleId: googleData['google_id'],
          email: googleData['email'],
          name: googleData['name'],
          fcmToken: fcmToken ?? '', // Pass FCM token
        );
        return apiResponse;
      }
      return null;
    });

    if (result != null) {
      // Validate user role from API response
      final userRole = result.user?.role;
      if (userRole == null ||
          (userRole != 'patient' && userRole != 'caregiver')) {
        CustomSnackbar.show('Invalid user role received', isSuccess: false);
        return;
      }

      final userType =
          userRole == 'patient' ? Appconsts.patient : Appconsts.caregiver;

      await LocalStorageService.setLoginStatus(true,
          userType: userType, token: result.token);

      // Store user data from Google login response
      Staticdata.userModel = result.user;

      CustomSnackbar.show('Google signin successful!', isSuccess: true);

      // STEP 2: Navigate based on user role
      // Patient → Direct to patient dashboard
      // Caregiver → Fetch patients list first, then navigate to caregiver dashboard
      if (userRole == 'patient') {
        Get.offAllNamed(PatientDashboard.routeName);
      } else {
        await _fetchCaregiverPatients();
        Get.offAllNamed(CareTakerDashboard.routeName);
      }
    }
  }

  /// STEP 3: Fetch and store caregiver's assigned patients
  /// - Calls Get Patients API (/caregiver/patients)
  /// - Stores patients list in global CaregiverState
  /// - This list is used for patient selection in dashboard
  /// - Called only for caregiver role after successful login
  Future<void> _fetchCaregiverPatients() async {
    try {
      final result = await _caregiverRepository.getPatients();
      CaregiverState().setPatients(result.data);
    } catch (e) {
      print('Failed to fetch caregiver patients: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
