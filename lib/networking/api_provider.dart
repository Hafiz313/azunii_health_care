// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:stylish_dialog/stylish_dialog.dart';
// import '../consts/lang.dart';
// import '../utils/custom_dialog.dart';
// import '../utils/localStorage/storage_consts.dart';
// import '../utils/localStorage/storage_service.dart';
// import '../views/widget/customer_Loader.dart';
// import 'api_ref.dart';

// enum RequestMethod { get, post, put, delete }

// RxBool mainLoading = false.obs;

// int time = 60;

// class ApiProvider {
//   var context;
//   var url;
//   var bodyData;
//   var imagePath;

//   ApiProvider(
//     this.context,
//     this.url,
//     this.bodyData,
//   );

//   getApiData2() async {
//     try {
//       print("=======wwww:${Apis.baseUrl + url}=======");
//       String tenantId =
//           StorageService().getData(StorageConsts.kTenantId).toString();
//       String token =
//           StorageService().getData(StorageConsts.kAccessToken).toString();
//       var headers = {
//         'Abp.TenantId': '$tenantId',
//         'Authorization': 'bearer ${token}',
//         'Content-Type': 'application/json'
//       };
//       print("=======headers:${headers}=======");
//       var request = http.Request('GET', Uri.parse(Apis.baseUrl + url));
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request
//           .send()
//           .timeout(Duration(seconds: time), // Set the timeout duration
//               onTimeout: () async {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//         await CustomDialog(
//           stylishDialogType: StylishDialogType.ERROR,
//           msg: Lang.timedOutMsg.tr,
//         ).show(context);
//         throw TimeoutException("The request timed out. Please try again.");
//       });

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return await response.stream.bytesToString();
//       } else {}
//     } catch (exception, s) {
//       debugPrint("======Error: ${exception},${s}=======");

//       // Re-throw network errors so they can be handled by the calling code
//       if (exception.toString().contains('SocketException') ||
//           exception.toString().contains('Failed host lookup') ||
//           exception
//               .toString()
//               .contains('No address associated with hostname') ||
//           exception.toString().contains('Connection refused') ||
//           exception.toString().contains('Network is unreachable')) {
//         rethrow;
//       }
//     }

//     return "";
//   }

//   getApiData(
//       {bool showLoader = true,
//       bool showSuccess = true,
//       bool showLoaderDismiss = true,
//       String successMsg = ""}) async {
//     try {
//       if (showLoader) showCustomLoader();
//       String tenantId =
//           StorageService().getData(StorageConsts.kTenantId).toString();
//       String userId =
//           StorageService().getData(StorageConsts.kUserId).toString();
//       String EmpId =
//           StorageService().getData(StorageConsts.kEmployeeId).toString();
//       String token =
//           StorageService().getData(StorageConsts.kAccessToken).toString();
//       var headers = {
//         'Abp.TenantId': '$tenantId',
//         'Abp.UserId': '$userId',
//         'Abp.EmployeeId': '$EmpId',
//         'Authorization': 'bearer ${token}',
//         'Content-Type': 'application/json'
//       };
//       print("=====url:${Apis.baseUrl + url}=======");
//       print("=======header:${headers}=======");
//       print("=======body Send:${bodyData}=======");
//       var request = http.Request('GET', Uri.parse(Apis.baseUrl + url));
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request
//           .send()
//           .timeout(Duration(seconds: time), // Set the timeout duration
//               onTimeout: () async {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//         await CustomDialog(
//           stylishDialogType: StylishDialogType.ERROR,
//           msg: Lang.timedOutMsg.tr,
//         ).show(context);
//         throw TimeoutException("The request timed out. Please try again.");
//       });

//       print("=======statusCode:${response.statusCode}======url:$url====");
//       // print("=======reponse :${await response.stream.bytesToString()}=======");

//       if (showLoaderDismiss) {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//       }
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (showSuccess) {
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.SUCCESS,
//             msg: successMsg,
//           ).show(context);
//         }

//         return await response.stream.bytesToString();
//       } else {
//         if (showLoaderDismiss) {
//           EasyLoading.dismiss();
//           mainLoading.value = false;
//         }
//       }
//     } catch (exception, s) {
//       EasyLoading.dismiss();
//       mainLoading.value = false;
//       debugPrint("======Error: ${exception},${s}=======");
//     }

//     return "";
//   }

//   deleteApiData(
//       {bool showLoader = true,
//       bool showSuccess = true,
//       bool showLoaderDismiss = true,
//       String successMsg = ""}) async {
//     try {
//       if (showLoader) showCustomLoader();
//       String tenantId =
//           StorageService().getData(StorageConsts.kTenantId).toString();
//       String userId =
//           StorageService().getData(StorageConsts.kUserId).toString();
//       String EmpId =
//           StorageService().getData(StorageConsts.kEmployeeId).toString();
//       String token =
//           StorageService().getData(StorageConsts.kAccessToken).toString();
//       var headers = {
//         'Abp.TenantId': '$tenantId',
//         'Abp.UserId': '$userId',
//         'Abp.EmployeeId': '$EmpId',
//         'Authorization': 'bearer ${token}',
//         'Content-Type': 'application/json'
//       };
//       // print("=======url:${Apis.baseUrl + url}=======");
//       print("=======header:${headers}=======");
//       // print("=======body Send:${bodyData}=======");
//       var request = http.Request('DELETE', Uri.parse(Apis.baseUrl + url));
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request
//           .send()
//           .timeout(Duration(seconds: time), // Set the timeout duration
//               onTimeout: () async {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//         await CustomDialog(
//           stylishDialogType: StylishDialogType.ERROR,
//           msg: Lang.timedOutMsg.tr,
//         ).show(context);
//         throw TimeoutException("The request timed out. Please try again.");
//       });

//       print("=======statusCode:${response.statusCode}======url:$url=");
//       // print("=======reponse :${await response.stream.bytesToString()}=======");

//       if (showLoaderDismiss) {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//       }
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (showSuccess) {
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.SUCCESS,
//             msg: successMsg,
//           ).show(context);
//         }

//         return await response.stream.bytesToString();
//       } else {
//         if (showLoaderDismiss) {
//           EasyLoading.dismiss();
//           mainLoading.value = false;
//         }
//       }
//     } catch (exception, s) {
//       EasyLoading.dismiss();
//       mainLoading.value = false;
//       debugPrint("======Error: ${exception},${s}=======");
//     }

//     return "";
//   }

//   Future postApiData(
//       {bool showLoader = true,
//       bool showSuccess = true,
//       bool auth = true,
//       bool showLoaderDismiss = true,
//       String successMsg = ""}) async {
//     try {
//       // if (await checkInternetConnection()) {
//       if (showLoader) showCustomLoader();
//       var headers;

//       if (auth) {
//         String tenantId =
//             StorageService().getData(StorageConsts.kTenantId).toString();
//         String token =
//             StorageService().getData(StorageConsts.kAccessToken).toString();
//         String userId =
//             StorageService().getData(StorageConsts.kUserId).toString();
//         String EmpId =
//             StorageService().getData(StorageConsts.kEmployeeId).toString();
//         headers = {
//           'Content-Type': 'application/json',
//           'Abp.UserId': '$userId',
//           'Abp.TenantId': '$tenantId',
//           'Abp.EmployeeId': '$EmpId',
//           'Authorization': 'bearer ${token}',
//         };
//       }

//       var request = http.Request(
//         'POST',
//         Uri.parse(
//           Apis.baseUrl + url,
//         ),
//       );
//       request.body = json.encode(bodyData);
//       if (auth) {
//         request.headers.addAll(headers);
//       }

//       debugPrint("=======headers:${headers}======");
//       debugPrint("=======url:${Apis.baseUrl + url}======");
//       // debugPrint("=======headers:${headers}======");
//       debugPrint("=======bodyData:${bodyData}======");
//       http.StreamedResponse response = await request
//           .send()
//           .timeout(Duration(seconds: time), // Set the timeout duration
//               onTimeout: () async {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//         await CustomDialog(
//           stylishDialogType: StylishDialogType.ERROR,
//           msg: Lang.timedOutMsg.tr,
//         ).show(context);
//         throw TimeoutException("The request timed out. Please try again.");
//       });
//       debugPrint("=======response.statusCode :${response.statusCode}======");
//       if (showLoaderDismiss) {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//       }
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (showSuccess) {
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.SUCCESS,
//             msg: successMsg,
//           ).show(context);
//         }
//         return await response.stream.bytesToString();
//       } else {
//         if (showLoaderDismiss) {
//           EasyLoading.dismiss();
//           mainLoading.value = false;
//         }
//       }
//       EasyLoading.dismiss();
//       mainLoading.value = false;
//       // else {
//       //   EasyLoading.dismiss();
//       //   await CustomDialog(
//       //     stylishDialogType: StylishDialogType.ERROR,
//       //     msg: Lang.pleaseCheckYourInternet,
//       //   ).show(context);
//       // }
//     } catch (e, s) {
//       EasyLoading.dismiss();
//       mainLoading.value = false;
//       debugPrint("======Error: ${e},${s}=======");
//     }
//     return "";
//   }

//   Future postApiWithoutHeader(
//       {bool showLoader = true,
//       bool showSuccess = true,
//       bool showLoaderDismiss = true,
//       String successMsg = ""}) async {
//     try {
//       // if (await checkInternetConnection()) {
//       if (showLoader) showCustomLoader();

//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request('POST', Uri.parse(Apis.baseUrl + url));

//       debugPrint("====url:${Apis.baseUrl + url}======");
//       debugPrint("====headers:${headers}======");
//       debugPrint("====bodyData:${bodyData}======");
//       request.body = json.encode(bodyData);
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request
//           .send()
//           .timeout(Duration(seconds: time), // Set the timeout duration
//               onTimeout: () async {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//         await CustomDialog(
//           stylishDialogType: StylishDialogType.ERROR,
//           msg: Lang.timedOutMsg.tr,
//         ).show(context);
//         throw TimeoutException("The request timed out. Please try again.");
//       });
//       print("=======statusCode:${response.statusCode}======url:$url=");
//       if (showLoaderDismiss) {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//       }
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (showSuccess) {
//           // Fluttertoast.showToast(
//           //     msg: successMsg,
//           //     toastLength: Toast.LENGTH_SHORT,
//           //     gravity: ToastGravity.SNACKBAR,
//           //     timeInSecForIosWeb: 2,
//           //     backgroundColor: AppColors.primary,
//           //     textColor: AppColors.white,
//           //     fontSize: 16.0);
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.SUCCESS,
//             msg: successMsg,
//           ).show(context);
//         }
//         return await response.stream.bytesToString();
//       } else if (response.statusCode == 500) {
//         if (showSuccess) {
//           // Fluttertoast.showToast(
//           //     msg: successMsg,
//           //     toastLength: Toast.LENGTH_SHORT,
//           //     gravity: ToastGravity.SNACKBAR,
//           //     timeInSecForIosWeb: 2,
//           //     backgroundColor: AppColors.primary,
//           //     textColor: AppColors.white,
//           //     fontSize: 16.0);

//           String responseBody = await response.stream.bytesToString();
//           debugPrint("==== Response Body: $responseBody ====");
//           Map<String, dynamic> data = json.decode(responseBody);
//           String errorMessage = data['error']['message'];
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.ERROR,
//             msg: errorMessage ?? Lang.somethingWentWrong,
//           ).show(context);
//         }
//         if (showLoaderDismiss) {
//           EasyLoading.dismiss();
//           mainLoading.value = false;
//         }
//       } else {
//         EasyLoading.dismiss();
//         mainLoading.value = false;

//         if (showSuccess) {
//           // Fluttertoast.showToast(
//           //     msg: successMsg,
//           //     toastLength: Toast.LENGTH_SHORT,
//           //     gravity: ToastGravity.SNACKBAR,
//           //     timeInSecForIosWeb: 2,
//           //     backgroundColor: AppColors.primary,
//           //     textColor: AppColors.white,
//           //     fontSize: 16.0);

//           try {
//             String responseBody = await response.stream.bytesToString();
//             Map<String, dynamic> data = json.decode(responseBody);
//             String errorMessage = data['error']['message'];
//           } catch (e) {}
//         }
//         if (showLoaderDismiss) {
//           EasyLoading.dismiss();
//           mainLoading.value = false;
//         }
//       }
//       // } else {
//       //   await CustomDialog(
//       //     stylishDialogType: StylishDialogType.ERROR,
//       //     msg: Lang.pleaseCheckYourInternet,
//       //   ).show(context);
//       // }
//     } catch (e, s) {
//       // if (showLoaderDismiss) {
//       EasyLoading.dismiss();
//       mainLoading.value = false;
//       // }
//       debugPrint("======Error: ${e}=======");
//       debugPrint("======ssss: ${s}=======");

//       // Re-throw network errors so they can be handled by the calling code
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Failed host lookup') ||
//           e.toString().contains('No address associated with hostname') ||
//           e.toString().contains('Connection refused') ||
//           e.toString().contains('Network is unreachable')) {
//         rethrow;
//       }
//     }
//     return "";
//   }

//   Future postApiDataHeaderWithTenantId(
//       {bool showLoader = true,
//       bool showSuccess = true,
//       bool showLoaderDismiss = true,
//       String successMsg = ""}) async {
//     try {
//       // if (await checkInternetConnection()) {
//       if (showLoader) showCustomLoader();
//       String tenantId =
//           StorageService().getData(StorageConsts.kTenantId).toString();
//       var headers = {
//         'Abp.TenantId': '$tenantId',
//         'Content-Type': 'application/json',
//       };
//       var request = http.Request('POST', Uri.parse(Apis.baseUrl + url));

//       debugPrint("====url:${Apis.baseUrl + url}======");
//       debugPrint("====headers:${headers}======");
//       debugPrint("====bodyData Send:${bodyData}======");
//       request.body = json.encode(bodyData);
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request
//           .send()
//           .timeout(Duration(seconds: time), // Set the timeout duration
//               onTimeout: () async {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//         await CustomDialog(
//           stylishDialogType: StylishDialogType.ERROR,
//           msg: Lang.timedOutMsg.tr,
//         ).show(context);
//         throw TimeoutException("The request timed out. Please try again.");
//       });

//       print("=======statusCode:${response.statusCode}======url:$url=");

//       if (showLoaderDismiss) {
//         EasyLoading.dismiss();
//         mainLoading.value = false;
//       }
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (showSuccess) {
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.SUCCESS,
//             msg: successMsg,
//           ).show(context);
//         }

//         String responseBody = await response.stream.bytesToString();

//         debugPrint("=======responseBody:${responseBody}========");
//         return responseBody;
//       } else {
//         if (showSuccess) {
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.ERROR,
//             msg: Lang.somethingWentWrong,
//           ).show(context);
//         }
//         if (showLoaderDismiss) {
//           EasyLoading.dismiss();
//           mainLoading.value = false;
//         }
//       }
//     } catch (e, s) {
//       // if (showLoaderDismiss) {
//       EasyLoading.dismiss();
//       mainLoading.value = false;
//       // }
//       debugPrint("======Error: ${e},${s}=======");

//       // Re-throw network errors so they can be handled by the calling code
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Failed host lookup') ||
//           e.toString().contains('No address associated with hostname') ||
//           e.toString().contains('Connection refused') ||
//           e.toString().contains('Network is unreachable')) {
//         rethrow;
//       }
//     }
//     return "";
//   }
// }
