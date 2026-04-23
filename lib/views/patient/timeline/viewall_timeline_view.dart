import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../core/models/timeline_model.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/overlayloader.dart';
import '../../widget/Common_widgets/timeline_task_card.dart';
import '../../widget/Common_widgets/pagination_controls.dart';
import 'widgets/visitcardwidget.dart';
import 'widgets/timeline_details_dialogs.dart';
import 'controller/timelineController.dart';

class ViewAllTimelineView extends StatelessWidget {
  const ViewAllTimelineView({super.key});

  static final List<Color> _cardColors = [
    Color(0xFF80C680),
    Color(0xFFFFB380),
    Color(0xFF80A8FF),
    Color(0xFFFFB3CC),
    Color(0xFFB380FF),
    Color(0xFF80FFCC),
    Color(0xFFFFCC80),
    Color(0xFFFF80B3),
    Color(0xFF8080FF),
    Color(0xFFCCFF80),
    Color(0xFFFF8080),
    Color(0xFF80FFFF),
    Color(0xFFC6B3FF),
    Color(0xFF80FFB3),
    Color(0xFFFFCC80),
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
    // Re-use the existing controller
    final controller = Get.find<TimelineController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => OverlayLoader(
            isLoading: controller.isLoading.value,
            child: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'Full Timeline',
                    isOndashboard: false,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.fetchTimeline(1),
                      color: AppColors.primary,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildDateFilterSection(context, controller),
                            const SizedBox(height: 16),
                            _buildAllContent(context, controller),
                            const SizedBox(height: 16),
                            _buildPagination(controller),
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

  Widget _buildDateFilterSection(
      BuildContext context, TimelineController controller) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subText5(
              controller.isFilterChanged ? 'Filtered by date' : 'Full Timeline',
              fontWeight: FontWeight.w600,
              color: AppColors.headingTextColor,
              fontSize: 13,
            ),
            Row(
              children: [
                // Date Picker Button — matches DatePickerButton design
                InkWell(
                  onTap: () => _showDatePicker(context, controller),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.dividerGray,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.calander,
                            width: 13,
                            height: 13,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.selectedDate.value != null
                                ? _formatDate(controller.selectedDate.value!)
                                : 'Select Date',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                              fontWeight: FontWeight.normal,
                              color: AppColors.headingTextColor,
                              fontFamily: 'Satoshi',
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Close icon — only when date differs from today
                if (controller.isFilterChanged) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => controller.resetFilter(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ));
  }

  Widget _buildAllContent(
      BuildContext context, TimelineController controller) {
    return Obx(() {
      if (controller.scheduleList.isEmpty &&
          controller.visitsList.isEmpty &&
          controller.medicineUpdatesList.isEmpty) {
        return _buildNoDataWidget();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Schedule — ALL items
          if (controller.scheduleList.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.medication_outlined,
              title: 'Medicine Schedule',
              subtitle:
                  '${controller.scheduleList.length} medications',
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-3, -3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: controller.scheduleList
                    .asMap()
                    .entries
                    .map((entry) {
                  final random = Random(entry.value.medicineId);
                  final color =
                      _cardColors[random.nextInt(_cardColors.length)];
                  final icon =
                      _cardIcons[random.nextInt(_cardIcons.length)];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key !=
                              controller.scheduleList.length - 1
                          ? 10
                          : 0,
                    ),
                    child: TimelineTaskCard(
                      item: entry.value,
                      bgColor: color,
                      icon: icon,
                      onTap: () => TimelineDetailsDialogs
                          .showScheduleDetailsDialog(entry.value),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Visits — ALL items
          if (controller.visitsList.isNotEmpty) ...[
            _buildSectionHeaderWithSort(
              title: 'Visit Timeline',
              count: controller.visitsList.length,
            ),
            const SizedBox(height: 12),
            ...controller.visitsList.map((visit) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: VisitCard(
                  event: visit,
                  onDetailsTap: () =>
                      TimelineDetailsDialogs.showVisitDetailsDialog(visit),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],

          // Medicine Updates — ALL items
          if (controller.medicineUpdatesList.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.history,
              title: 'Medicine Updates',
              subtitle:
                  '${controller.medicineUpdatesList.length} updates',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildMedicineUpdatesTimeline(controller),
          ],
        ],
      );
    });
  }

  Widget _buildPagination(TimelineController controller) {
    return Obx(() {
      if (!controller.shouldShowPagination || controller.totalPages.value <= 1) {
        return const SizedBox.shrink();
      }

      return PaginationControls(
        currentPage: controller.currentPage.value,
        lastPage: controller.totalPages.value,
        onPageChanged: (page) => controller.goToPage(page),
      );
    });
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeaderWithSort({
    required String title,
    required int count,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerGray),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.headingTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.filter_list, size: 14, color: AppColors.textColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineUpdatesTimeline(TimelineController controller) {
    final items = controller.medicineUpdatesList;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(3, 3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            offset: const Offset(-3, -3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final event = entry.value;
          final isLast = entry.key == items.length - 1;
          return _buildEventItem(event, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildEventItem(TimelineEvent event, bool isLast) {
    final eventStyle = _getEventStyle(event.type);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: eventStyle['color'].withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: eventStyle['color'],
                    width: 2,
                  ),
                ),
                child: Icon(
                  eventStyle['icon'],
                  size: 16,
                  color: eventStyle['color'],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.textColor.withOpacity(0.15),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: eventStyle['color'].withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: eventStyle['color'].withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            color: AppColors.headingTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: eventStyle['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          eventStyle['label'],
                          style: TextStyle(
                            color: eventStyle['color'],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (event.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.subtitle!,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatEventTimestamp(event.timestamp),
                        style: TextStyle(
                          color: AppColors.textColor.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getEventStyle(String type) {
    switch (type) {
      case 'medicine_added':
        return {
          'color': Colors.green,
          'icon': Icons.add_circle_outline,
          'label': 'Added',
        };
      case 'medicine_updated':
        return {
          'color': Colors.orange,
          'icon': Icons.edit_outlined,
          'label': 'Updated',
        };
      case 'visit':
        return {
          'color': Colors.blue,
          'icon': Icons.local_hospital_outlined,
          'label': 'Visit',
        };
      default:
        return {
          'color': AppColors.textColor,
          'icon': Icons.info_outline,
          'label': 'Activity',
        };
    }
  }

  String _formatEventTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inDays == 0) {
        return 'Today at ${_formatTime12Hour(dt)}';
      } else if (diff.inDays == 1) {
        return 'Yesterday at ${_formatTime12Hour(dt)}';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} days ago';
      } else {
        return '${dt.day}/${dt.month}/${dt.year}';
      }
    } catch (e) {
      return timestamp;
    }
  }

  String _formatTime12Hour(DateTime dt) {
    final hour =
        dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
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

  Future<void> _showDatePicker(
      BuildContext context, TimelineController controller) async {
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
