import 'package:Azunii_Health/consts/appconsts.dart';
import 'package:Azunii_Health/core/services/google_auth_service.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/utils/localStorage/storage_service.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/static_user_model.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../patient/dashboard/patient_dashboard.dart';

class LoginController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isChecked = false.obs;
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final AuthRepository _authRepository = AuthRepository();
  void toggleRememberMe(bool? value) {
    isChecked.value = value ?? false;
  }

  Future<void> login() async {
    print('Login api call result is this ');
    if (!formKey.currentState!.validate()) return;

    final result = await safeApiCall(() => _authRepository.login(
          emailController.text.trim(),
          passwordController.text,
        ));
    print('Login api call result is this ${result}');

    if (result != null) {
      // Get user role from API response
      final userRole = result.user?.role ?? 'patient';
      final userType =
          userRole == 'patient' ? Appconsts.patient : Appconsts.caregiver;

      await LocalStorageService.setLoginStatus(true,
          userType: userType, token: result.token);

      // Store user data from login response
      Staticdata.userModel = result.user;
      print('✅ User data stored from login response');

      SnackbarHelper.showSuccess('Login successful');

      // Navigate based on user role from API
      if (userRole == 'patient') {
        Get.offAllNamed(PatientDashboard.routeName);
      } else {
        Get.offAllNamed(CareTakerDashboard.routeName);
      }
    } else {
      print('Api call failed on login section');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> googleLogin() async {
    final result = await safeApiCall(() async {
      final googleData = await _googleAuthService.signInWithGoogle();
      if (googleData.isNotEmpty) {
        final apiResponse = await _authRepository.googleAuth(
          googleId: googleData['google_id'],
          email: googleData['email'],
          name: googleData['name'],
          deviceToken: googleData['device_token'],
        );
        return apiResponse;
      }
      return null;
    });

    if (result != null) {
      // Get user role from API response
      final userRole = result.user?.role ?? 'patient';
      final userType =
          userRole == 'patient' ? Appconsts.patient : Appconsts.caregiver;

      await LocalStorageService.setLoginStatus(true,
          userType: userType, token: result.token);

      // Store user data from Google login response
      Staticdata.userModel = result.user;
      print('✅ User data stored from Google login response');

      SnackbarHelper.showSuccess('Google signin successful!');

      // Navigate based on user role from API
      if (userRole == 'patient') {
        Get.offAllNamed(PatientDashboard.routeName);
      } else {
        Get.offAllNamed(CareTakerDashboard.routeName);
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
