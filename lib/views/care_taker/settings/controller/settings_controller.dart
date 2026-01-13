import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/repositories/auth_repository.dart';
import 'package:Azunii_Health/core/repositories/profile_repository.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/core/models/static_user_model.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_snackbar.dart';
import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends BaseController {
  final AuthRepository _authRepository = AuthRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  // Profile update controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      CustomSnackbar.show('Please enter name', isSuccess: false);
      return;
    }

    if (emailController.text.trim().isEmpty) {
      CustomSnackbar.show('Please enter email', isSuccess: false);
      return;
    }

    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      CustomSnackbar.show('Passwords do not match', isSuccess: false);
      return;
    }

    setLoading(true);
    final result = await safeApiCall(() => _profileRepository.updateProfile(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.isNotEmpty
              ? passwordController.text
              : null,
          passwordConfirmation: confirmPasswordController.text.isNotEmpty
              ? confirmPasswordController.text
              : null,
        ));

    if (result != null) {
      // Refresh profile data
      final profileResult =
          await safeApiCall(() => _authRepository.getProfileInfo());
      if (profileResult != null && profileResult.status) {
        Staticdata.userModel = profileResult.user;
      }

      passwordController.clear();
      confirmPasswordController.clear();
      CustomSnackbar.show('Profile updated successfully!', isSuccess: true);
    }
    setLoading(false);
  }

  Future<void> logout() async {
    final result = await safeApiCall(() => _authRepository.logout());

    if (result != null) {
      await LocalStorageService.logout();
      Get.offAllNamed(LoginView.routeName);
      CustomSnackbar.show('Logged out successfully', isSuccess: true);
    }
  }

  Future<void> deleteAccount() async {
    final result = await safeApiCall(() => _authRepository.deleteAccount());

    if (result != null) {
      await LocalStorageService.logout();
      Get.offAllNamed(LoginView.routeName);
      CustomSnackbar.show('Account deleted successfully', isSuccess: true);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
