import 'package:Azunii_Health/consts/appconsts.dart';
import 'package:Azunii_Health/core/services/google_auth_service.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
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

  Future<void> login(String userType) async {
    if (!formKey.currentState!.validate()) return;

    final result = await safeApiCall(() => _authRepository.login(
          emailController.text.trim(),
          passwordController.text,
        ));

    if (result != null) {
      SnackbarHelper.showSuccess('Login successful!');
      if (userType == Appconsts.patient) {
        await LocalStorageService.setLoginStatus(true, userType: userType);
        Get.offAllNamed(PatientDashboard.routeName);
      } else {
        await LocalStorageService.setLoginStatus(true, userType: userType);
        Get.offAllNamed(CareTakerDashboard.routeName);
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> googleLogin(String userType) async {
    final result = await safeApiCall(() async {
      // Get Google sign-in data
      final googleData = await _googleAuthService.signInWithGoogle();

      if (googleData.isNotEmpty) {
        // Call Google login API with the data
        final apiResponse = await _authRepository.googleAuth(
          googleId: googleData['google_id'],
          email: googleData['email'],
          name: googleData['name'],
          deviceToken: googleData['device_token'],
        );

        await LocalStorageService.setLoginStatus(true, userType: userType);
        return apiResponse;
      }
      return null;
    });

    if (result != null) {
      SnackbarHelper.showSuccess('Google login successful!');

      if (userType == Appconsts.patient) {
        Get.offAllNamed(PatientDashboard.routeName);
      } else if (userType == Appconsts.caregiver) {
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
