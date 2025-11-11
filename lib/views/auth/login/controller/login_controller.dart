import 'dart:convert';

import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/core/models/response/GetLoginInfoModel.dart';
import 'package:azunii_health_care/core/models/response/login_response.dart';
import 'package:azunii_health_care/core/models/response/DashBoardModel.dart';
import 'package:azunii_health_care/core/models/response/GetJobEmpModels.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../../main.dart';
import '../../../../networking/api_provider.dart';
import '../../../../networking/api_ref.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/localStorage/storage_consts.dart';
import '../../../../utils/localStorage/storage_service.dart';

import '../../../patient/home/home_view.dart';
import '../login_view.dart';

class LoginController extends GetxController {
  var isChecked = false.obs;
  var isSaveThisDevice = false.obs;
  TextEditingController emailTxtField = TextEditingController();
  TextEditingController passwordTxtField = TextEditingController();

  // RxBool loginLoading = false.obs;

  Rx<LoginResponse> loginResponse = LoginResponse().obs;
  // RxString userId = ''.obs;
  // RxString isEmail = ''.obs;

  final formKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = true.obs;

  void toggleRememberMe(bool? value) {
    isChecked.value = value ?? false;
  }

  void toggleSaveThisDevice(bool? value) {
    isSaveThisDevice.value = value ?? false;
  }

  void savePassword() {
    if (isChecked.value) {
      StorageService().saveData(StorageConsts.kUserEmail, emailTxtField.text);
      StorageService()
          .saveData(StorageConsts.kUserPassword, passwordTxtField.text);
    } else {
      StorageService().removeData(StorageConsts.kUserEmail);
      StorageService().removeData(StorageConsts.kUserPassword);
    }
  }

  fetchSaveData() {
    StorageService().saveData(StorageConsts.kAppRun, 'true');
    String? email;
    if (StorageService().containsKey(StorageConsts.kUserEmail)) {
      email = StorageService().getData(StorageConsts.kUserEmail);
      isChecked.value = true;
    } else {
      email = StorageService().containsKey(StorageConsts.kUserEmail)
          ? StorageService().getData(StorageConsts.kUserEmail)
          : '';
    }
    String? password = StorageService().containsKey(StorageConsts.kUserPassword)
        ? StorageService().getData(StorageConsts.kUserPassword)
        : '';
    emailTxtField.text = email!;
    passwordTxtField.text = password!;
  }

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      String email = emailTxtField.text;
      String paswwod = passwordTxtField.text;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/patient-dashboard',
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> isTenantAvailable(BuildContext context,
      {required String email, required String password}) async {
    // loginLoading.value = true;
    var url = Apis.isTenantAvailableApi;
    var helper = ApiProvider(context, url, {
      "tenantKey": "00000000-0000-0000-0000-000000000000",
      "userName": '$email',
      "companyId": 0
    });
    await helper
        .postApiWithoutHeader(
      showSuccess: false,
      showLoader: true,
      showLoaderDismiss: false,
    )
        .then(
      (res) async {
        try {
          if (!isNullString(res)) {
            Map<String, dynamic> decodedResponse = jsonDecode(res);
            var tenantId = decodedResponse['result']['tenantId'];
            if (tenantId != null) {
              StorageService()
                  .saveData(StorageConsts.kTenantId, tenantId.toString());

              loginApi(context, email: email, password: password);
            } else {
              EasyLoading.dismiss();
              mainLoading.value = false;
              await CustomDialog(
                stylishDialogType: StylishDialogType.ERROR,
                msg: Lang.emailNotFond,
              ).show(context);
            }
          }
        } catch (e) {
          EasyLoading.dismiss();
          mainLoading.value = false;
        }
      },
    );
  }

  Future<void> verifyOtp(BuildContext context, {required String otp}) async {
    // "======userId.value:${userId.value}====isEmail.value:${isEmail.value}=====");
    var url = Apis.otpVerifyAuthApi;
    var helper = ApiProvider(context, url, {
      "accessToken": null,
      "encryptedAccessToken": null,
      "expireInSeconds": loginResponse.value.result!.expireInSeconds,
      "userId": loginResponse.value.result!.userId,
      "isPhoneAuthentication":
          loginResponse.value.result!.isPhoneAuthentication,
      "isEmailAuthentication":
          loginResponse.value.result!.isEmailAuthentication,
      "phoneNumber": loginResponse.value.result!.phoneNumber,
      "emailAddress": loginResponse.value.result!.emailAddress,
      "viewPath": loginResponse.value.result!.viewPath,
      "isTwoFactorRequired": loginResponse.value.result!.isTwoFactorRequired,
      "isNewDevice": loginResponse.value.result!.isSaveNewDevice,
      "isSaveNewDevice": true,
      "otpCode": otp,
      // "deviceId": fcmToken,
      "deviceId": "sss ss s",
      "browerInfo": null,
      "deviceType": "Mobile"
    });

    await helper
        .postApiDataHeaderWithTenantId(
      showSuccess: false,
      showLoader: true,
      showLoaderDismiss: true,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          String email = emailTxtField.text;
          String paswwod = passwordTxtField.text;

          loginApi(
            context,
            email: email,
            password: paswwod,
          );
        }
      },
    );
  }

  Future<void> loginApi(BuildContext context,
      {required String email,
      required String password,
      bool moveToOtp = true}) async {
    var url = Apis.authenticateApi;
    var helper = ApiProvider(context, url, {
      "userNameOrEmailAddress": "$email",
      "password": "$password",
      "userId": 0,
      "rememberClient": isChecked.value,
      "isPhoneVerified": false,
      "isTwoFactorEnabled": false,
      "ipAddress": "string",
      // "deviceId": fcmToken,
      "deviceId": "sss ss s",
      "browerInfo": null,
      "isSaveNewDevice": true,
    });

    await helper
        .postApiDataHeaderWithTenantId(
      showSuccess: false,
      showLoader: true,
    )
        .then(
      (res) async {
        debugPrint("=====loginApi res:${res}=====");

        // loginLoading.value = false;
        if (!isNullString(res)) {
          loginResponse.value = LoginResponse.fromJson(jsonDecode(res));
          Map<String, dynamic> decodedResponse = jsonDecode(res);
          try {
            RxString userId = "${decodedResponse['result']['userId']}".obs;
            StorageService()
                .saveData(StorageConsts.kUserId, userId.value.toString());
          } catch (e) {}
          String accessToken = "${decodedResponse['result']['accessToken']}";
          debugPrint("========accessToken:${accessToken}========");

          if (accessToken != "null") {
            StorageService()
                .saveData(StorageConsts.kAccessToken, accessToken.toString());
            savePassword();
            afterLoginInfoApi(context);

            // Check company count for switch company feature

            Navigator.of(context).pushNamedAndRemoveUntil(
              '/patient-dashboard',
              (Route<dynamic> route) => false,
            );
          } else {
            EasyLoading.dismiss();
            mainLoading.value = false;
            if ("${decodedResponse['result']['isTwoFactorRequired']}" ==
                'true') {
              if (moveToOtp) {
                await CustomDialog(
                  stylishDialogType: StylishDialogType.ERROR,
                  msg: 'You have to authenticate your device',
                  callBack: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, OtpView.routeName);
                  },
                ).show(context);
              }
            } else {
              await CustomDialog(
                stylishDialogType: StylishDialogType.ERROR,
                msg: Lang.somethingWentWrong,
              ).show(context);
            }
          }
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.invalidUserNamePassword,
          ).show(context);
        }
      },
    ).catchError((error) async {
      EasyLoading.dismiss();
      mainLoading.value = false;

      // Handle network connectivity errors
      String errorMessage = Lang.somethingWentWrong;
      if (error.toString().contains('SocketException') ||
          error.toString().contains('Failed host lookup') ||
          error.toString().contains('No address associated with hostname')) {
        errorMessage =
            'Network connection failed. Please check your internet connection and try again.';
      }

      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: errorMessage,
      ).show(context);
    });
  }

  void logout(
      {bool isNavToLogin = true, String email = '', String password = ''}) {
    // Clear all data in GetStorage
    // final box = GetStorage();
    // box.erase();

    // Clear home controller data
    try {
      // final homeController = Get.find<HomeController>();

      // // Reset dashboard model
      // homeController.dashboardModel.value = DashBoardModel(
      //   result: DashBoardResult(
      //     workHoursDetails: WorkHoursDetails(),
      //     announcements: [],
      //     todayActivities: [],
      //     leaves: Leaves(),
      //   ),
      // );

      // // Clear job lists
      // homeController.jobEmpList.clear();
      // homeController.selectedJob.value = GetJobResult();

      // // Reset timer variables
      // homeController.hours.value = 0;
      // homeController.minutes.value = 0;
      // homeController.seconds.value = 0;

      // // Reset boolean flags
      // homeController.isPunchIn.value = true;
      // homeController.isMultiJob.value = true;

      // // Cancel timer if running
      // if (homeController.timer?.isActive == true) {
      //   homeController.timer?.cancel();
      // }
    } catch (e) {
      // HomeController might not be initialized, ignore error
      print('HomeController not found during logout: $e');
    }

    if (isNavToLogin) {
      Get.offAllNamed(LoginView.routeName);
    } else {
      isTenantAvailable(Get.context!, email: email, password: password);
    }
  }

  Future<void> afterLoginInfoApi(BuildContext context) async {
    var url = Apis.getCurrentLoginInformationsApi;
    var helper = ApiProvider(context, url, {});
    await helper.getApiData2().then(
      (res) async {
        debugPrint("======afterLoginInfoApi res:${res}======");
        if (!isNullString(res)) {
          Rx<GetLoginInfoModel> getLoginInfoModel = GetLoginInfoModel().obs;
          getLoginInfoModel.value = getLoginInfoModelFromJson(res);
          debugPrint(
              "======getLoginInfoModel user:${getLoginInfoModel.value.result!.user!.contractorId}======");
          saveUsersData(user: getLoginInfoModel.value);
        }
      },
    );
  }

  @override
  void onInit() {
    fetchSaveData();
    super.onInit();
  }

  @override
  void onClose() {
    // emailTxtField.dispose();
    // passwordTxtField.dispose();
    super.onClose();
  }

  void saveUsersData({required GetLoginInfoModel user}) {
    StorageService()
        .saveData(StorageConsts.kUserName, user.result!.user!.userName);
    StorageService()
        .saveData(StorageConsts.kUserSurName, user.result!.user!.surname);
    StorageService()
        .saveData(StorageConsts.kUserPassword, passwordTxtField.text);
    StorageService().saveData(StorageConsts.kName, user.result!.user!.name);
    StorageService()
        .saveData(StorageConsts.kEmail, user.result!.user!.emailAddress);
    StorageService()
        .saveData(StorageConsts.kEmail, user.result!.user!.emailAddress);
    StorageService()
        .saveData(StorageConsts.kEmployeeId, user.result!.user!.employeeId);
    StorageService()
        .saveData(StorageConsts.kTenantName, user.result!.tenant!.name);
    StorageService()
        .saveData(StorageConsts.kTenancyName, user.result!.tenant!.tenancyName);
    StorageService()
        .saveData(StorageConsts.kCompanyId, user.result!.tenant!.companyId);
  }
}
