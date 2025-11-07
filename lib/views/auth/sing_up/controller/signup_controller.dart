import 'dart:convert';

import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/core/models/response/GetLoginInfoModel.dart';
import 'package:azunii_health_care/core/models/response/SignUpModels.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_signup_view.dart';
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
import '../../../home/controller/home_controller.dart';
import '../../../home/home_view.dart';
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
        // signUpModel.value = SignUpModels(
        //     result: SignUpResult(
        //         fullName: nameTxtField.text,
        //         registeredPhoneNumber: registerTxtField.text,
        //         ssn: ssnTxtField.text,
        //         companyEmailAddress: companyRegisteredTxtField.text,
        //         azunii_health_careEmailAddress: empRegisteredTxtField.text,
        //         password: passwordTxtField.text,
        //         employeeId: 130896,
        //         tenantId: 4109));
        // Navigator.pushNamed(context, OtpSignUpView.routeName);
        if (!isNullString(res)) {
          signUpModel.value = SignUpModels.fromJson(jsonDecode(res));
          if (moveToOtp) {
            Navigator.pushNamed(context, OtpSignUpView.routeName);
          }
        }
      },
    );
  }

  Future<void> verifyOtp(BuildContext context, {required String otp}) async {
    // "======userId.value:${userId.value}====isEmail.value:${isEmail.value}=====");
    var url = Apis.otpVerifySignUpApi;
    var helper = ApiProvider(context, url, {
      "fullName": signUpModel.value.result!.fullName,
      "registeredPhoneNumber": signUpModel.value.result!.registeredPhoneNumber,
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
    );
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
