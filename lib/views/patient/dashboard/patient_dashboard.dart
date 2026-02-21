import 'package:Azunii_Health/views/patient/dashboard/controller/patient_home_controller.dart';
import 'package:Azunii_Health/views/patient/dashboard/widget/patient_bottom_nav.dart';
import 'package:Azunii_Health/views/patient/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../advocacy/advocacy_view.dart';
import '../advocacy/controller/advocacyController.dart';

import '../medicines/medicines_view.dart';
import '../summary/summary_view.dart';
import '../timeline/timeline_view.dart';
import '../timeline/controller/timelineController.dart';
import '../visits/visits_view.dart';

class PatientDashboard extends StatefulWidget {
  static const String routeName = '/patient-dashboard';

  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  late final PatientHomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PatientHomeController());
    Get.put(TimelineController());
    Get.put(AdvocacyController());
  }

  @override
  void dispose() {
    Get.delete<PatientHomeController>();
    Get.delete<TimelineController>();
    Get.delete<AdvocacyController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const AddMedicineView(),
      AddVisitView(),
      const SummaryView(),
      const TimelineView(
        isOndashboard: true,
      ),
      const AdvocacyView(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.homeBG,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: pages,
        ),
        bottomNavigationBar: const PatientBottomNav(),
      ),
    );
  }
}
