import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../../core/models/timeline_model.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/overlayloader.dart';
import '../../widget/Common_widgets/timeline_task_card.dart';
import 'widgets/visitcardwidget.dart';
import 'controller/timelineController.dart';

class TimelineView extends GetView<TimelineController> {
  final bool? isOndashboard;
  const TimelineView({super.key, this.isOndashboard = false});

  static final List<Color> _cardColors = [
    Color(0xFFE8F5E8), // Mint Green
    Color(0xFFFFF2E8), // Peach
    Color(0xFFE8F0FF), // Soft Blue
    Color(0xFFFFF0F5), // Rose
    Color(0xFFF0E8FF), // Lavender
    Color(0xFFE8FFF8), // Aqua
    Color(0xFFFFF8E8), // Cream
    Color(0xFFFFE8F0), // Blush
    Color(0xFFE8E8FF), // Periwinkle
    Color(0xFFF8FFE8), // Light Lime
    Color(0xFFFFE8E8), // Light Coral
    Color(0xFFE8FFFF), // Ice Blue
    Color(0xFFF5F0FF), // Lilac
    Color(0xFFE8FFF0), // Sage
    Color(0xFFFFF5E8), // Vanilla
  ];

  static final List<IconData> _cardIcons = [
    Icons.medication,
    Icons.medical_services,
    Icons.vaccines,
    Icons.healing,
    Icons.local_pharmacy,
    Icons.health_and_safety,
    Icons.medication_liquid,
    Icons.science,
    Icons.biotech,
    Icons.bloodtype,
    Icons.coronavirus,
    Icons.emergency,
    Icons.favorite,
    Icons.monitor_heart,
    Icons.psychology,
    Icons.sanitizer,
    Icons.sick,
    Icons.water_drop,
    Icons.medical_information,
    Icons.masks,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => OverlayLoader(
            isLoading: controller.isLoading.value,
            child: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    title: Lang.timeline,
                    isOndashboard: false,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.fetchTimeline(1),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius:  BorderRadius.circular(12),
                            //       color: Colors.blue.withValues(alpha: 0.1),
                            //       border: Border.all(color: Colors.blue)),
                            //   child: Column(
                            //     children: [
                            _buildDateFilterSection(context),
                            const SizedBox(height: 8),
                            _buildTimelineContent(context),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 24),
                            _buildPagination(context),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildDateFilterSection(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                subText5(Lang.asOfToday,
                    fontWeight: FontWeight.w600,
                    color: AppColors.headingTextColor,
                    fontSize: 13),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _showDatePicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cardGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.calander,
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                AppColors.textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            subText5(
                              fontWeight: FontWeight.w400,
                              controller.selectedDate.value != null
                                  ? _formatDate(controller.selectedDate.value!)
                                  : 'Select Date',
                              fontSize: 13,
                              color: AppColors.headingTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => controller.resetFilter(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: controller.showAllDates.value
                              ? AppColors.primary
                              : AppColors.cardGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.all_inclusive,
                          size: 12,
                          color: controller.showAllDates.value
                              ? AppColors.white
                              : AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildTimelineContent(BuildContext context) {
    return Obx(() {
      if (controller.filteredList.isEmpty) {
        return _buildNoDataWidget();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.scheduleList.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 245, 247),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color.fromARGB(255, 219, 217, 217),
                      width: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // subText5('Medicine Schedule',
                  //     color: AppColors.headingTextColor, fontSize: 14),
                  // const SizedBox(height: 16),
                  ...controller.scheduleList.asMap().entries.map((entry) {
                    final random = Random(entry.value.medicineId);
                    final color =
                        _cardColors[random.nextInt(_cardColors.length)];
                    final icon = _cardIcons[random.nextInt(_cardIcons.length)];
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300 + (entry.key * 100)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TimelineTaskCard(
                          item: entry.value,
                          bgColor: color,
                          icon: icon,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (controller.eventsList
              .where((e) => e.type == 'visit')
              .isNotEmpty) ...[
            subText5(Lang.visitTimeline,
                color: AppColors.headingTextColor, fontSize: 14),
            const SizedBox(height: 16),
            ...controller.eventsList
                .where((e) => e.type == 'visit')
                .toList()
                .reversed
                .toList()
                .asMap()
                .entries
                .map((entry) {
              return AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 300 + (entry.key * 100)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: VisitCard(event: entry.value),
                ),
              );
            }),
          ],
        ],
      );
    });
  }

  Widget _buildPagination(BuildContext context) {
    return Obx(() {
      if (controller.totalPages.value <= 1) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            controller.totalPages.value > 5 ? 5 : controller.totalPages.value,
            (index) {
              final page = index + 1;
              final isSelected = controller.currentPage.value == page;
              return GestureDetector(
                onTap: () => controller.goToPage(page),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.cardGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: subText5(
                    page.toString(),
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.headingTextColor,
                  ),
                ),
              );
            },
          ),
          if (controller.currentPage.value < controller.totalPages.value)
            GestureDetector(
              onTap: () =>
                  controller.goToPage(controller.currentPage.value + 1),
              child: Container(
                margin: const EdgeInsets.only(left: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_forward_ios,
                    size: 14, color: AppColors.textColor),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_information_outlined,
              size: 80,
              color: AppColors.textColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            subText5(
              'No Data Found',
              fontSize: 16,
              color: AppColors.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.filterByDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
