import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../../consts/lang.dart';
import '../../../../networking/api_provider.dart';
import '../../../../networking/api_ref.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/localStorage/storage_consts.dart';
import '../../../../utils/localStorage/storage_service.dart';
import '../../Otp/otp_forget_view.dart';
import '../../Otp/otp_view.dart';
import '../../login/login_view.dart';
import '../rest_password_view.dart';

class ForgetController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTxtField = TextEditingController();

  final otpFormKey = GlobalKey<FormState>();
  final otpTxtField = TextEditingController();

  final restFormKey = GlobalKey<FormState>();
  final passwordTxtField = TextEditingController();
  final confirmPasswordTxtField = TextEditingController();
  RxBool isPasswordVisible = false.obs;

  // Add for OTP digit fields
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  String get otpCode => otpControllers.map((c) => c.text).join();

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }
    super.onClose();
  }

  Future<void> forget(BuildContext context, {bool moveToOtp = true}) async {
    var url = '${Apis.forgetApi}?emailAddress=${emailTxtField.text}';
    var helper = ApiProvider(context, url, null);
    await helper
        .postApiData(
      showSuccess: false,
      showLoader: true,
      showLoaderDismiss: true,
    )
        .then((res) async {
      if (!isNullString(res)) {
        debugPrint("=====res:${res}======");
        EasyLoading.dismiss();

        if (moveToOtp) {
          await CustomDialog(
            stylishDialogType: StylishDialogType.SUCCESS,
            msg: 'Please check your email.',
            callBack: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, OtpForgetView.routeName);
            },
          ).show(context);
        }
      }
    });
  }

  Future<void> verifyOtp(BuildContext context, {required String otp}) async {
    var url =
        '${Apis.forgetOtpApi}?emailAddress=${emailTxtField.text}&otpCode=$otp';
    var helper = ApiProvider(context, url, null);
    await helper
        .postApiData(
      showSuccess: false,
      showLoader: true,
      showLoaderDismiss: false,
    )
        .then((res) async {
      if (!isNullString(res)) {
        debugPrint("=====res:${res}======");
        EasyLoading.dismiss();
        Navigator.pushNamed(context, RestPasswordView.routeName);
      }
    });
  }

  Future<void> restPassword(BuildContext context,
      {bool moveToOtp = true}) async {
    var url = Apis.resetPasswordApi;

    var helper = ApiProvider(context, url, {
      "emailAddress": emailTxtField.text,
      "password": passwordTxtField.text,
    });

    await helper
        .postApiWithoutHeader(
      showSuccess: false,
      showLoader: true,
      showLoaderDismiss: true,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          String? email;
          if (StorageService().containsKey(StorageConsts.kUserEmail)) {
            email = StorageService().getData(StorageConsts.kUserEmail);
            if (emailTxtField.text == email) {
              StorageService().removeData(StorageConsts.kUserPassword);
            }
          }

          Get.offAllNamed(LoginView.routeName);
        }
      },
    );
  }
}
