import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/patient/home/controller/home_controller.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/appointment_card.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllVisitsView extends StatefulWidget {
  static const String routeName = '/all-visits';
  const AllVisitsView({super.key});

  @override
  State<AllVisitsView> createState() => _AllVisitsViewState();
}

class _AllVisitsViewState extends State<AllVisitsView> {
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoader(
      isLoading: controller.isLoading.value,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'All Visits',
                  isOndashboard: false,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: headline5(
                    'All Visits',
                    color: AppColors.headingTextColor,
                    fontWeight: FontWeight.w500,
                    context: context,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => controller.visitsList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: subText4(
                            'No visits found',
                            color: AppColors.textColor,
                            context: context,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.visitsList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final visit = controller.visitsList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: AppointmentCard(
                              date: visit.visitDate,
                              doctor: visit.providerName,
                              reason: visit.notes,
                              specialty: visit.specialty,
                              onTap: () =>
                                  controller.showVisitDetails(visit.id),
                            ),
                          );
                        },
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
