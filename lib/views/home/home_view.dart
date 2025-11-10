// import 'dart:async';
// import 'package:azunii_health_care/utils/percentage_size_ext.dart';
// import 'package:azunii_health_care/views/care_taker/home/widget/punchInWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../consts/colors.dart';
// import '../../base_view/base_scaffold.dart';
// import 'controller/home_controller.dart';
// import 'home_widget.dart';

// class HomeView extends StatefulWidget {
//   HomeView({super.key});
//   static const String routeName = '/HomeView';

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   HomeController homeController = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//         backgroundColor: AppColors.homeBG,
//         isBackArrow: false,
//         body: Obx(() => Container(
//               padding:
//                   EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
//               child: RefreshIndicator(
//                 onRefresh: () async {
//                   homeController.getDashboard(context,
//                       jobId: "${homeController.selectedJob.value.id}");
//                 },
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const PunchInWidget(),
//                       SizedBox(
//                         height: context.percentHeight * 1,
//                       ),
//                       leaveBalance(context,
//                           data: homeController.dashboardModel.value),
//                       SizedBox(
//                         height: context.percentHeight * 1,
//                       ),
//                       iconsWidget(context),
//                       SizedBox(
//                         height: context.percentHeight * 1,
//                       ),
//                       announcementsNotifications(context,
//                           data: homeController.dashboardModel.value),
//                       SizedBox(
//                         height: context.percentHeight * 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )));
//   }
// }
