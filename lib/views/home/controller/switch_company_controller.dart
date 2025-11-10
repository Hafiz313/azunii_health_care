// import 'dart:async';
// import 'dart:convert';

// import 'package:azunii_health_care/consts/lang.dart';
// import 'package:azunii_health_care/core/models/response/CompanyListModel.dart';
// import 'package:azunii_health_care/views/auth/login/controller/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stylish_dialog/stylish_dialog.dart';
// import '../../../../networking/api_provider.dart';
// import '../../../../networking/api_ref.dart';
// import '../../../../utils/custom_dialog.dart';
// import '../../../../utils/helper.dart';
// import '../../../../utils/localStorage/storage_consts.dart';
// import '../../../../utils/localStorage/storage_service.dart';
// import '../../../../consts/colors.dart';
// import 'home_controller.dart';

// class SwitchCompanyController extends GetxController {
//   Rx<CompanyListModel?> companyList = CompanyListModel(result: []).obs;
//   RxBool isLoading = false.obs;

//   Future<void> getCompanyList(BuildContext context,
//       {bool isShowDialog = true}) async {
//     isLoading.value = true;

//     String email = StorageService().getData(StorageConsts.kEmail).toString();

//     String userId = StorageService().getData(StorageConsts.kUserId).toString();

//     debugPrint("========userId:${userId}======");
//     var url = "${Apis.getSwitchCompanyList}?emailAddress=$email";
//     var helper = ApiProvider(context, url, {});
//     await helper.getApiData2().then(
//       (res) async {
//         debugPrint(
//             "===== getCompanyListApi.value (${companyList.value!.result!.length < 2}) : -- ${res}=====");
//         if (!isNullString(res)) {
//           try {
//             companyList.value = CompanyListModel.fromJson(jsonDecode(res));

//             if (isShowDialog) {
//               if (companyList.value?.success == true &&
//                   companyList.value?.result != null &&
//                   companyList.value!.result!.isNotEmpty) {
//                 _showCompanySelectionDialog(context);
//               } else {
//                 await CustomDialog(
//                   stylishDialogType: StylishDialogType.INFO,
//                   msg: 'No companies available to switch to.',
//                 ).show(context);
//               }
//             }
//           } catch (e) {
//             debugPrint("Error parsing company list: $e");
//             if (isShowDialog) {
//               await CustomDialog(
//                 stylishDialogType: StylishDialogType.ERROR,
//                 msg: 'Error loading company list.',
//               ).show(context);
//             }
//           }
//         } else {
//           await CustomDialog(
//             stylishDialogType: StylishDialogType.ERROR,
//             msg: Lang.somethingWentWrong,
//           ).show(context);
//         }
//         isLoading.value = false;
//       },
//     );
//   }

//   void _showCompanySelectionDialog(BuildContext context) {
//     if (companyList.value?.result == null) return;

//     // Get current user ID from storage to pre-select the current company
//     String currentUserId =
//         StorageService().getData(StorageConsts.kUserId).toString();
//     debugPrint("======currentUserId:${currentUserId}=======");
//     int? selectedUserId = int.tryParse(currentUserId);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 8,
//               backgroundColor: AppColors.white,
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 constraints: const BoxConstraints(
//                   maxWidth: 400,
//                   minWidth: 300,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header with icon and title
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.business,
//                             color: AppColors.primary,
//                             size: 28,
//                           ),
//                           SizedBox(width: 12),
//                           Text(
//                             'Switch Company',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Subtitle
//                     const Text(
//                       'Choose a company to switch to:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: AppColors.textColor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 24),

//                     // Company list
//                     Container(
//                       constraints: const BoxConstraints(
//                         maxHeight: 300,
//                       ),
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: companyList.value!.result!.length,
//                         separatorBuilder: (context, index) =>
//                             const SizedBox(height: 8),
//                         itemBuilder: (context, index) {
//                           final company = companyList.value!.result![index];
//                           final isCurrentCompany =
//                               company.userId == selectedUserId;

//                           return Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: isCurrentCompany
//                                     ? AppColors.primary
//                                     : AppColors.borderColor.withOpacity(0.2),
//                                 width: isCurrentCompany ? 2 : 1,
//                               ),
//                               color: isCurrentCompany
//                                   ? AppColors.primary.withOpacity(0.05)
//                                   : AppColors.white,
//                             ),
//                             child: RadioListTile<int>(
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               title: Text(
//                                 // '${company.companyName} ${company.userId}',
//                                 company.companyName ?? 'Unknown Company',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: isCurrentCompany
//                                       ? FontWeight.bold
//                                       : FontWeight.w500,
//                                   color: isCurrentCompany
//                                       ? AppColors.primary
//                                       : AppColors.headingTextColor,
//                                 ),
//                               ),
//                               subtitle: isCurrentCompany
//                                   ? Container(
//                                       margin: const EdgeInsets.only(top: 4),
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: AppColors.primary,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: const Text(
//                                         'Current Company',
//                                         style: TextStyle(
//                                           color: AppColors.white,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     )
//                                   : null,
//                               value: company.userId ?? 0,
//                               groupValue: selectedUserId,
//                               activeColor: AppColors.primary,
//                               onChanged: (int? value) {
//                                 setState(() {
//                                   selectedUserId = value;
//                                 });
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Action buttons

//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             height: 48,
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 side: const BorderSide(
//                                   color: AppColors.primary,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   color: AppColors.primary,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         if (companyList.value!.result!.length > 1)
//                           const SizedBox(width: 16),
//                         if (companyList.value!.result!.length > 1)
//                           Expanded(
//                             child: Container(
//                               height: 48,
//                               child: ElevatedButton(
//                                 onPressed: selectedUserId != null
//                                     ? () {
//                                         // Check if selected company is the same as current company
//                                         String currentUserId = StorageService()
//                                             .getData(StorageConsts.kUserId)
//                                             .toString();
//                                         if (selectedUserId.toString() ==
//                                             currentUserId) {
//                                           Navigator.of(context).pop();
//                                           Get.snackbar(
//                                             'Info',
//                                             'You are already in the selected company.',
//                                             snackPosition: SnackPosition.TOP,
//                                             backgroundColor: Colors.orange,
//                                             colorText: Colors.white,
//                                             duration:
//                                                 const Duration(seconds: 2),
//                                           );
//                                         } else {
//                                           Navigator.of(context).pop();
//                                           switchCompanyByUserId(context,
//                                               userID:
//                                                   selectedUserId.toString());
//                                         }
//                                       }
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: selectedUserId != null
//                                       ? AppColors.primary
//                                       : AppColors.textColor.withOpacity(0.3),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   elevation: 2,
//                                 ),
//                                 child: const Text(
//                                   'Switch',
//                                   style: TextStyle(
//                                     color: AppColors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> switchCompanyByUserId(BuildContext context,
//       {required String userID}) async {
//     isLoading.value = true;

//     try {
//       var url = "${Apis.getSwitchCompanyById}?userId=$userID";
//       var helper = ApiProvider(context, url, {});

//       await helper
//           .postApiWithoutHeader(
//         showSuccess: false,
//         showLoader: false,
//         showLoaderDismiss: false,
//       )
//           .then(
//         (res) async {
//           debugPrint("===== switchCompanyByUserId response : -- ${res}=====");
//           if (!isNullString(res)) {
//             try {
//               // Parse the response to check if it's successful
//               Map<String, dynamic> responseData = jsonDecode(res);
//               if (responseData['success'] == true) {
//                 // Close the drawer first
//                 Get.back();
//                 try {
//                   String email =
//                       StorageService().getData(StorageConsts.kEmail).toString();
//                   String password = StorageService()
//                       .getData(StorageConsts.kUserPassword)
//                       .toString();

//                   var controller = Get.put(LoginController());
//                   controller.logout(
//                       isNavToLogin: false, email: email, password: password);

//                   var homeController = Get.find<HomeController>();
//                   if (!homeController.isPunchIn.value) {
//                     homeController.handlePunchInOut(context);
//                   }

//                   // controller.loginApi(Get.context!,
//                   //     email: email, password: password);
//                   // debugPrint(
//                   //     "==1===user:${StorageService().getData(StorageConsts.kUserId).toString()}=====");
//                   // StorageService().saveData(StorageConsts.kUserId, userID);
//                   // debugPrint(
//                   //     "==2===user:${StorageService().getData(StorageConsts.kUserId).toString()}=====");
//                   //
//                   // controller.loginApi(currentContext, email: email, password: password);
//                 } catch (e) {}
//                 // Use Get.snackbar instead of CustomDialog to avoid context issues
//                 Get.snackbar(
//                   'Success',
//                   'Successfully switched to the selected company!',
//                   snackPosition: SnackPosition.TOP,
//                   backgroundColor: Colors.green,
//                   colorText: Colors.white,
//                   duration: const Duration(seconds: 3),
//                 );

//                 // You might want to refresh the app state or navigate to a different screen here
//                 // For example, you could refresh the dashboard or go to home
//                 // Get.offAllNamed('/home'); // Uncomment if you want to navigate
//               } else {
//                 // Use Get.snackbar for error messages as well
//                 Get.snackbar(
//                   'Error',
//                   responseData['error'] ?? 'Failed to switch company.',
//                   snackPosition: SnackPosition.TOP,
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                   duration: const Duration(seconds: 3),
//                 );
//               }
//             } catch (e) {
//               debugPrint("Error parsing switch company response: $e");
//               Get.snackbar(
//                 'Error',
//                 'Error processing company switch response.',
//                 snackPosition: SnackPosition.TOP,
//                 backgroundColor: Colors.red,
//                 colorText: Colors.white,
//                 duration: const Duration(seconds: 3),
//               );
//             }
//           } else {
//             Get.snackbar(
//               'Error',
//               'Failed to switch company. Please try again.',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//               colorText: Colors.white,
//               duration: const Duration(seconds: 3),
//             );
//           }
//         },
//       );
//     } catch (e) {
//       debugPrint("Error in switchCompanyByUserId: $e");
//       Get.snackbar(
//         'Error',
//         'An error occurred while switching companies.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
