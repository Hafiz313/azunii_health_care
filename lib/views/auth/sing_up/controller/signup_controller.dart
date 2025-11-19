import 'package:Azunii_Health/consts/appconsts.dart';
import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../patient/dashboard/patient_dashboard.dart';
import '../../../care_taker/dashboard/dashboard.dart';
import '../../Otp/otp_signup_view.dart';

class SignUpController extends BaseController {
  final nameTxtField = TextEditingController();
  final emailTxtField = TextEditingController();
  final passwordTxtField = TextEditingController();
  final confirmPasswordTxtField = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConformPasswordVisible = false.obs;
  final RxBool acceptTermsAndConditions = false.obs;

  final AuthRepository _authRepository = AuthRepository();

  Future<void> signup(String userType) async {
    if (!formKey.currentState!.validate()) return;

    if (!acceptTermsAndConditions.value) {
      SnackbarHelper.showWarning("Please accept Terms & Conditions");
      return;
    }

    if (passwordTxtField.text != confirmPasswordTxtField.text) {
      SnackbarHelper.showError("Password not match");
      return;
    }

    final result = await safeApiCall(() => _authRepository.register({
          "name": nameTxtField.text,
          "email": emailTxtField.text,
          "password": passwordTxtField.text,
          "password_confirmation": confirmPasswordTxtField.text,
        }));

    if (result != null) {
      SnackbarHelper.showSuccess('Registration successful! Please login.');
      Get.offAllNamed(LoginView.routeName);
    }
  }

  Future<void> googleSignup(String userType) async {
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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConformPasswordVisible.value = !isConformPasswordVisible.value;
  }

  void toggleTermsAndConditions(bool? value) {
    acceptTermsAndConditions.value = value ?? false;
  }

  @override
  void onClose() {
    nameTxtField.dispose();
    emailTxtField.dispose();
    passwordTxtField.dispose();
    confirmPasswordTxtField.dispose();
    super.onClose();
  }
}
