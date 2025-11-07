import 'dart:async';
import 'dart:convert';

import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/core/models/response/DashBoardModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import '../../../networking/api_provider.dart';
import '../../../networking/api_ref.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/customer_Loader.dart';
import '../../../utils/helper.dart';
import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import 'package:http/http.dart' as http;

import '../../auth/login/login_view.dart';

class GenralController extends GetxController {
  Future<void> deleteAccount() async {
    debugPrint("=====dd===");
    mainLoading.value = true;

    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String userId = StorageService().getData(StorageConsts.kUserId).toString();
    String EmpId = StorageService().getData(StorageConsts.kUserId).toString();
    String token =
        StorageService().getData(StorageConsts.kAccessToken).toString();
    var headers = {
      'Abp.TenantId': '$tenantId',
      'Abp.UserId': '$userId',
      'Abp.EmployeeId': '$EmpId',
      'Authorization': 'bearer ${token}',
      'Content-Type': 'application/json'
    };

    debugPrint("======headers:${headers}======");
    var request = await http.Request(
        'DELETE',
        Uri.parse(
            'https://staging.app.eworkforcepayroll.com:618/api/services/app/EmployeeUser/DeleteEmployeeUser?userId=${userId}'));
    request.body = json.encode({"userId": userId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      mainLoading.value = false;
      final box = GetStorage();
      box.erase();
      Get.offAllNamed(LoginView.routeName);
    } else {
      mainLoading.value = false;
      print(response.reasonPhrase);
    }
    mainLoading.value = false;
  }
}
