import 'package:azunii_health_care/views/patient/home/controller/patient_home_controller.dart';
import 'package:azunii_health_care/views/patient/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import 'advocacy/advocacy_view.dart';

import '../care_taker/caregiverHome/widget/patient_bottom_nav.dart';
import 'medicines/medicines_view.dart';
import 'summary/summary_view.dart';
import 'timeline/timeline_view.dart';
import 'visits/visits_view.dart';

class PatientDashboard extends StatelessWidget {
  static const String routeName = '/patient-dashboard';

  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientHomeController());

    final List<Widget> pages = [
      const HomeView(),
      const MedicinesView(),
      AddVisitView(),
      const SummaryView(),
      const TimelineView(),
      const AdvocacyView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: const PatientBottomNav(),
    );
  }
}
