import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/care_taker/FAQs/faqs_view.dart';
import 'package:Azunii_Health/views/care_taker/Medication/medication_caretaker_view.dart';
import 'package:Azunii_Health/views/care_taker/Notes/notes_view.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/controller/caretaker_home_controller.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/widgets/caretakerbottomnavbar.dart';
import 'package:Azunii_Health/views/care_taker/feedback/feedback_view.dart';
import 'package:Azunii_Health/views/care_taker/home/home_view_caregiver.dart.dart';
import 'package:Azunii_Health/views/care_taker/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareTakerDashboard extends StatelessWidget {
  static const String routeName = '/care-taker-dashboard';

  const CareTakerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CareTakerHomeController());

    final List<Widget> pages = [
      const HomeView_caregiver(),
      const Notesview(),
      const Medication_caretaker(),
      const FeedbackView(),
      const FAQsView(),
      const Settingsview(),
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
        bottomNavigationBar: const CareTakerBottomNav(),
      ),
    );
  }
}
