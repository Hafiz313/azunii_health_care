import 'package:Azunii_Health/views/patient/home/controller/home_controller.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/date_picker_button.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/pagination_controls.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/today_task_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../utils/percentage_size_ext.dart';

class AllMedicinesView extends StatefulWidget {
  static const String routeName = '/all-medicines';
  const AllMedicinesView({super.key});

  @override
  State<AllMedicinesView> createState() => _AllMedicinesViewState();
}

class _AllMedicinesViewState extends State<AllMedicinesView> {
  final controller = Get.find<HomeController>();

  // Medicine colors and icons matching home screen
  final medicineColors = [
    const Color.fromARGB(255, 181, 218, 244),
    AppColors.lightOrange,
    AppColors.lightGreenCard,
    AppColors.lightPurple,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllMedicinesPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.getAllMedicinesPage(
            controller.allMedCurrentPage.value,
          ),
          child: Column(
            children: [
              CustomAppBar(
                title: 'All Medicines',
                isOndashboard: false,
              ),
              // Date filter bar
              _buildDateFilterBar(context),
              // List content
              Expanded(
                child: Obx(() {
                  if (controller.allMedLoading.value) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  final medicines = controller.filteredAllMedList;

                  if (medicines.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medication_outlined,
                            size: 64,
                            color: AppColors.textColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No medicines found',
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
                    itemCount: medicines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final medicine = medicines[index];
                      final colorIndex = index % medicineColors.length;

                      return TodayTaskCard(
                        backgroundColor: medicineColors[colorIndex],
                        icon: _getMedicineIcon(index, context),
                        title: medicine.medicineName,
                        isCompleted: medicine.status != 'active',
                        status: medicine.status == 'active'
                            ? 'Active'
                            : 'In Active',
                        onTap: () =>
                            controller.showAllMedicineDetails(medicine.id),
                      );
                    },
                  );
                }),
              ),
              // Pagination controls - hide when date filter is active
              Obx(() {
                // Hide pagination when date filter is active
                if (controller.allMedSelectedDate.value.isNotEmpty) {
                  return const SizedBox.shrink();
                }
                return PaginationControls(
                  currentPage: controller.allMedCurrentPage.value,
                  lastPage: controller.allMedLastPage.value,
                  onPageChanged: (page) {
                    controller.getAllMedicinesPage(page);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilterBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                'Total: ${controller.allMedTotal.value}',
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Satoshi',
                ),
              )),
          Row(
            children: [
              Obx(() => controller.allMedSelectedDate.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: InkWell(
                        onTap: controller.clearAllMedDateFilter,
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
                    date: controller.allMedSelectedDate.value.isEmpty
                        ? 'Select Date'
                        : controller.allMedSelectedDate.value,
                    onTap: controller.onAllMedDatePickerTap,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getMedicineIcon(int index, BuildContext context) {
    final icons = [
      FaIcon(FontAwesomeIcons.pills,
          color: Colors.blue[600], size: context.percentWidth * 5),
      FaIcon(FontAwesomeIcons.capsules,
          color: Colors.orange[600], size: context.percentWidth * 5),
      FaIcon(FontAwesomeIcons.tablets,
          color: AppColors.green, size: context.percentWidth * 5),
      FaIcon(FontAwesomeIcons.syringe,
          color: Colors.purple[600], size: context.percentWidth * 5),
    ];
    return icons[index % icons.length];
  }
}
