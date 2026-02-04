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
    Color(0xFF80C680), // Much Darker Mint Green
    Color(0xFFFFB380), // Much Darker Peach
    Color(0xFF80A8FF), // Much Darker Soft Blue
    Color(0xFFFFB3CC), // Much Darker Rose
    Color(0xFFB380FF), // Much Darker Lavender
    Color(0xFF80FFCC), // Much Darker Aqua
    Color(0xFFFFCC80), // Much Darker Cream
    Color(0xFFFF80B3), // Much Darker Blush
    Color(0xFF8080FF), // Much Darker Periwinkle
    Color(0xFFCCFF80), // Much Darker Light Lime
    Color(0xFFFF8080), // Much Darker Light Coral
    Color(0xFF80FFFF), // Much Darker Ice Blue
    Color(0xFFC6B3FF), // Much Darker Lilac
    Color(0xFF80FFB3), // Much Darker Sage
    Color(0xFFFFCC80), // Much Darker Vanilla
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
    // Initialize controller to ensure onInit is called
    final controller = Get.put(TimelineController());
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => OverlayLoader(
            isLoading: controller.isLoading.value,
            child: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    title: Lang.timeline,
                    isOndashboard: true,
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
          // Medicine Schedule Section
          if (controller.scheduleList.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.medication_outlined,
              title: 'Medicine Schedule',
              subtitle: '${controller.scheduleList.length} medications today',
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
                children: controller.scheduleList.asMap().entries.map((entry) {
                  final random = Random(entry.value.medicineId);
                  final color = _cardColors[random.nextInt(_cardColors.length)];
                  final icon = _cardIcons[random.nextInt(_cardIcons.length)];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key != controller.scheduleList.length - 1 ? 10 : 0,
                    ),
                    child: TimelineTaskCard(
                      item: entry.value,
                      bgColor: color,
                      icon: icon,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Activity History Section (Events)
          if (controller.eventsList.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.history,
              title: 'Activity History',
              subtitle: '${controller.eventsList.length} recent activities',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildEventsTimeline(context),
          ],
        ],
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

  Widget _buildEventsTimeline(BuildContext context) {
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
        children: controller.eventsList.asMap().entries.map((entry) {
          final event = entry.value;
          final isLast = entry.key == controller.eventsList.length - 1;
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
          // Timeline connector
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
          
          // Event content
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
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
