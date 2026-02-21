import 'package:Azunii_Health/views/patient/home/controller/home_controller.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/date_picker_button.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/pagination_controls.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/appointment_card.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';

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
      controller.getAllVisitsPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoader(
      isLoading: controller.isLoading.value,
      child: Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.getAllVisitsPage(
            controller.allVisitsCurrentPage.value,
          ),
          child: Column(
            children: [
              // Custom App Bar
              const CustomAppBar(title: 'All Visits', isOndashboard: false),
              // Date filter bar
              _buildDateFilterBar(context),
              // List content
              Expanded(
                child: Obx(() {
                  if (controller.allVisitsLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  final visits = controller.filteredAllVisitsList;

                  if (visits.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: AppColors.textColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No visits found',
                            style: TextStyle(
                              color: AppColors.textColor.withOpacity(0.5),
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: visits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final visit = visits[index];

                      return AppointmentCard(
                        date: visit.visitDate,
                        doctor: visit.providerName,
                        reason: visit.notes,
                        specialty: visit.specialty,
                        onTap: () =>
                            controller.showAllVisitDetails(visit.id),
                      );
                    },
                  );
                }),
              ),
              // Pagination controls
              Obx(() => PaginationControls(
                    currentPage: controller.allVisitsCurrentPage.value,
                    lastPage: controller.allVisitsLastPage.value,
                    onPageChanged: (page) {
                      controller.getAllVisitsPage(page);
                    },
                  )),
            ],
          ),
        ),
      ),
      ),
    ));
  }

  Widget _buildDateFilterBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                'Total: ${controller.allVisitsTotal.value}',
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Satoshi',
                ),
              )),
          Row(
            children: [
              Obx(() => controller.allVisitsSelectedDate.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: InkWell(
                        onTap: controller.clearAllVisitsDateFilter,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              Obx(() => DatePickerButton(
                    date: controller.allVisitsSelectedDate.value.isEmpty
                        ? 'Select Date'
                        : controller.allVisitsSelectedDate.value,
                    onTap: controller.onAllVisitsDatePickerTap,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
