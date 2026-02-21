import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/care_taker/home/controller/care-giver-controller.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/appointment_card.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllVisitsView extends StatelessWidget {
  static const String routeName = '/caregiver-all-visits';
  
  const AllVisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController_caregiver>();
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'All Visits',
              isOndashboard: false,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final patientId = controller.activePatient.value?.userId;
                  if (patientId != null) {
                    await controller.loadDashboardData(int.parse(patientId));
                  }
                },
                color: AppColors.primary,
                child: Obx(() {
                  final dashboard = controller.dashboardData.value;
                  
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (dashboard == null || dashboard.upcomingVisits.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_note_outlined,
                                size: 80,
                                color: AppColors.textColor.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              subText4(
                                'No visits found',
                                color: AppColors.textColor.withOpacity(0.6),
                              ),
                              const SizedBox(height: 8),
                              subText5(
                                fontSize: 12,
                                'Pull down to refresh',
                                color: AppColors.textColor.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: dashboard.upcomingVisits.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final visit = dashboard.upcomingVisits[index];
                      return AppointmentCard(
                        date: visit.visitDate,
                        doctor: visit.providerName,
                        reason: visit.notes,
                        specialty: visit.specialty,
                        onTap: () => controller.showVisitDetails(visit.id),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
