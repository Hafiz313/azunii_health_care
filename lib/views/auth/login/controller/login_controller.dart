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

  Future<void> login(String userType) async {
    if (!formKey.currentState!.validate()) return;

    // Commented out API call for testing
    final result = await safeApiCall(() => _authRepository.login(
          emailController.text.trim(),
          passwordController.text,
        ));

    print('Login api call result is this ${result}');

    if (result != null) {
      await LocalStorageService.setLoginStatus(true,
          userType: userType, token: result.token);

      // Store user data from login response
      Staticdata.userModel = result.user;
      print('✅ User data stored from login response');

      SnackbarHelper.showSuccess('Signin successful!');
      if (userType == Appconsts.patient) {
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

  Future<void> googleLogin(String userType) async {
    // Show loader for 2 seconds instead of API call
    setLoading(true);

    //Commented out API call for testing
    final result = await safeApiCall(() async {
      final googleData = await _googleAuthService.signInWithGoogle();
      if (googleData.isNotEmpty) {
        final apiResponse = await _authRepository.googleAuth(
          googleId: googleData['google_id'],
          email: googleData['email'],
          name: googleData['name'],
          deviceToken: googleData['device_token'],
        );
        await LocalStorageService.setLoginStatus(true,
            userType: userType, token: apiResponse.token);
        return apiResponse;
      }
      return null;
    });
    setLoading(false);
    if (result != null) {
      await LocalStorageService.setLoginStatus(true,
          userType: userType, token: result.token);

      // Store user data from Google login response
      Staticdata.userModel = result.user;
      print('✅ User data stored from Google login response');
    }
    SnackbarHelper.showSuccess('Google signin successful!');

    if (userType == Appconsts.patient) {
      setLoading(false);
      Get.offAllNamed(PatientDashboard.routeName);
    } else if (userType == Appconsts.caregiver) {
      setLoading(false);
      Get.offAllNamed(CareTakerDashboard.routeName);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
