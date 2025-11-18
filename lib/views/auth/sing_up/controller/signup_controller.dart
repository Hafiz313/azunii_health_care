import 'dart:convert';

import 'package:Azunii_Health/core/models/response/SignUpModels.dart';
import 'package:Azunii_Health/core/services/google_auth_service.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/views/auth/Otp/otp_signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../../networking/api_provider.dart';
import '../../../../networking/api_ref.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/localStorage/storage_consts.dart';
import '../../../../utils/localStorage/storage_service.dart';

import '../../../patient/home/home_view.dart';
import '../../Otp/otp_view.dart';
import '../../login/login_view.dart';

class SignUpController extends GetxController {
  final nameTxtField = TextEditingController();
  final registerTxtField = TextEditingController();
  final ssnTxtField = TextEditingController();
  // final companyRegisteredTxtField = TextEditingController();
  final empRegisteredTxtField = TextEditingController();
  final passwordTxtField = TextEditingController();
  final confirmPasswordTxtField = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = false.obs;
  RxBool isConformPasswordVisible = false.obs;
  RxBool acceptTermsAndConditions = false.obs;
  Rx<SignUpModels> signUpModel = SignUpModels().obs;
  Future<void> signup(BuildContext context, {bool moveToOtp = true}) async {
    if (formKey.currentState!.validate()) {
      if (!acceptTermsAndConditions.value) {
        await CustomDialog(
                stylishDialogType: StylishDialogType.ERROR,
                msg: "Please accept Terms & Conditions")
            .show(context);
        return;
      }
      if (passwordTxtField.text == confirmPasswordTxtField.text) {
        signupApi(context);
      } else {
        await CustomDialog(
                stylishDialogType: StylishDialogType.ERROR,
                msg: "Password not match")
            .show(context);
      }
    }
  }

  Future<void> signupApi(BuildContext context, {bool moveToOtp = true}) async {
    try {
      var url = Apis.signUpApi;

      var helper = ApiProvider(context, url, {
        "fullName": nameTxtField.text,
        "registeredPhoneNumber": registerTxtField.text,
        "ssn": ssnTxtField.text,
        "azunii_health_careEmailAddress": empRegisteredTxtField.text,
        "password": passwordTxtField.text,
        "id": 0
      });

      await helper
          .postApiWithoutHeader(
        showSuccess: true,
        showLoader: true,
        showLoaderDismiss: true,
      )
          .then(
        (res) async {
          if (!isNullString(res)) {
            signUpModel.value = SignUpModels.fromJson(jsonDecode(res));
            if (moveToOtp) {
              Navigator.pushNamed(context, OtpSignUpView.routeName);
            }
          }
        },
      ).catchError((error) async {
        await CustomDialog(
          stylishDialogType: StylishDialogType.ERROR,
          msg: 'Sign up failed: ${error.toString()}',
        ).show(context);
      });
    } catch (e) {
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: 'Sign up failed: ${e.toString()}',
      ).show(context);
    }
  }

  Future<void> verifyOtp(BuildContext context, {required String otp}) async {
    try {
      var url = Apis.otpVerifySignUpApi;
      var helper = ApiProvider(context, url, {
        "fullName": signUpModel.value.result!.fullName,
        "registeredPhoneNumber":
            signUpModel.value.result!.registeredPhoneNumber,
        "ssn": signUpModel.value.result!.ssn,
        "companyEmailAddress": signUpModel.value.result!.companyEmailAddress,
        "employeeEmailAddress": signUpModel.value.result!.employeeEmailAddress,
        "password": signUpModel.value.result!.password,
        "otpCode": otp,
        "tenantId": signUpModel.value.result!.tenantId,
        "employeeId": signUpModel.value.result!.employeeId,
        "id": 0
      });

      await helper
          .postApiWithoutHeader(
        showSuccess: true,
        showLoader: true,
        showLoaderDismiss: true,
      )
          .then(
        (res) async {
          debugPrint("======res:${res}=====");
          if (!isNullString(res)) {
            Get.offAllNamed(LoginView.routeName);
          }
        },
      ).catchError((error) async {
        await CustomDialog(
          stylishDialogType: StylishDialogType.ERROR,
          msg: 'OTP verification failed: ${error.toString()}',
        ).show(context);
      });
    } catch (e) {
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: 'OTP verification failed: ${e.toString()}',
      ).show(context);
    }
  }

  /// Google Sign-In as Patient
  Future<void> signInAsPatient(BuildContext context) async {
    try {
      mainLoading.value = true;

      final userModel = await GoogleAuthService.signInWithGoogle();

      if (userModel != null) {
        await LocalStorageService.setLoginStatus(true, userType: 'patient');

        mainLoading.value = false;
        Get.offAllNamed('/patient-dashboard');
      } else {
        mainLoading.value = false;
      }
    } catch (e) {
      mainLoading.value = false;

      if (!e.toString().contains('sign_in_canceled')) {
        Get.snackbar(
          'Sign-In Error',
          'Google Sign-In failed. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> signInAsCaregiver(BuildContext context) async {
    try {
      mainLoading.value = true;

      final userModel = await GoogleAuthService.signInWithGoogle();

      if (userModel != null) {
        await LocalStorageService.setLoginStatus(true, userType: 'caregiver');

        mainLoading.value = false;
        Get.offAllNamed('/care-taker-dashboard');
      } else {
        mainLoading.value = false;
      }
    } catch (e) {
      mainLoading.value = false;

      if (!e.toString().contains('sign_in_canceled')) {
        Get.offAllNamed('/care-taker-dashboard');
        // Get.snackbar(
        //   'Sign-In Error',
        //   'Google Sign-In failed. Please try again.',
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
      }
    }
  }

  Future<void> SignupAsPatient(BuildContext context) async {
    try {
      mainLoading.value = true;

      // final userModel = await GoogleAuthService.signInWithGoogle();

      //  if (userModel != null) {
      await LocalStorageService.setLoginStatus(true, userType: 'patient');

      //  mainLoading.value = false;
      Get.offAllNamed('/patient-dashboard');
      // }
      // else {
      mainLoading.value = false;
      // }
    } catch (e) {
      mainLoading.value = false;

      if (!e.toString().contains('sign_in_canceled')) {
        Get.offAllNamed('/patient-dashboard');
        Get.snackbar(
          'Sign-In Error',
          'Google Sign-In failed. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> SignupAsCaregiver(BuildContext context) async {
    try {
      mainLoading.value = true;

      await LocalStorageService.setLoginStatus(true, userType: 'caregiver');

      mainLoading.value = false;
      Get.offAllNamed('/care-taker-dashboard');
    } catch (e) {
      mainLoading.value = false;

      if (!e.toString().contains('sign_in_canceled')) {
        Get.offAllNamed('/care-taker-dashboard');
      }
    }
  }

  @override
  void onClose() {
    nameTxtField.dispose();
    registerTxtField.dispose();
    ssnTxtField.dispose();
    // companyRegisteredTxtField.dispose();
    empRegisteredTxtField.dispose();
    passwordTxtField.dispose();
    confirmPasswordTxtField.dispose();
    super.onClose();
  }
}
