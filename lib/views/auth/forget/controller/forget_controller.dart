import 'package:Azunii_Health/views/widget/Common_widgets/reset_email_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../utils/snackbar_helper.dart';

class ForgetController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailTxtField = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  Future<void> forgotPassword() async {
    if (!formKey.currentState!.validate()) return;

    final result = await safeApiCall(() => _authRepository.forgotPassword(
          emailTxtField.text.trim(),
        ));

    if (result != null) {
      InfoDialog.show(
        title: 'Email Sent',
        message:
            'Password reset email has been sent to ${emailTxtField.text}. Please check your Gmail to reset your password.',
        onPressed: () {
          Get.back(); // Navigate back to login
        },
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  void onClose() {
    emailTxtField.dispose();
    super.onClose();
  }
}
