import 'package:Azunii_Health/views/widget/Common_widgets/reset_email_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../utils/ApiExceptions.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';

class ForgetController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailTxtField = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  Future<void> forgotPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setLoading(true);
      final result = await _authRepository.forgotPassword(
        emailTxtField.text.trim(),
      );
      setLoading(false);
      
      final message = result['message'] ?? 'Email sent successfully';
      InfoDialog.show(
        title: 'Success',
        message: message,
        onPressed: () => Get.back(),
      );
    } on ApiException catch (e) {
      setLoading(false);
      InfoDialog.show(
        title: 'Error',
        message: e.message,
        onPressed: () {},
      );
    } catch (e) {
      setLoading(false);
      InfoDialog.show(
        title: 'Error',
        message: 'Something went wrong',
        onPressed: () {},
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
