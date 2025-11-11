import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildAsOfTodaySection(context),
                    const SizedBox(height: 32),
                    _buildVisitTimelineSection(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar with back button, title, and notification bell
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          // Title
          Expanded(
            child: Center(
              child: headline3(
                Lang.timeline,
                color: AppColors.headingTextColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.bellBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.bell,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// As of Today Section
  Widget _buildAsOfTodaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with date and star icon
        Row(
          children: [
            headline3(
              Lang.asOfToday,
              color: AppColors.headingTextColor,
              textAlign: TextAlign.start,
            ),
            const SizedBox(width: 12),
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
            subText3(
              '09-12-2025',
              color: AppColors.headingTextColor,
              align: TextAlign.start,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Task Card 1 - Blue (Take eye drops)
        _buildTaskCard(
          context,
          backgroundColor: AppColors.lightBlue,
          iconColor: Colors.blue[600]!,
          icon: Icons.check,
          title: Lang.takeEyeDrops,
          time: '10:00 AM',
        ),
        const SizedBox(height: 12),
        // Task Card 2 - Yellow (Walk 15 minutes)
        _buildTaskCard(
          context,
          backgroundColor: AppColors.lightYellow,
          iconColor: Colors.orange[600]!,
          icon: Icons.remove,
          title: Lang.walkMinutes,
          time: '10:50 AM',
        ),
        const SizedBox(height: 12),
        // Task Card 3 - Green (Pause statins)
        _buildTaskCard(
          context,
          backgroundColor: AppColors.lightGreenCard,
          iconColor: AppColors.green,
          icon: Icons.warning,
          title: Lang.pauseStatins,
          time: '10:50 AM',
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    BuildContext context, {
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subText2(
                  title,
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textColor,
                    ),
                    const SizedBox(width: 6),
                    subText3(
                      time,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Visit Timeline Section
  Widget _buildVisitTimelineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Sort By button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headline3(
              Lang.visitTimeline,
              color: AppColors.headingTextColor,
              textAlign: TextAlign.start,
            ),
            InkWell(
              onTap: () {
                // Handle sort
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.filter_list,
                      size: 16,
                      color: AppColors.textColor,
                    ),
                    const SizedBox(width: 6),
                    subText3(
                      Lang.sortBy,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Visit Cards
        _buildVisitCard(
          context,
          doctorName: 'Dr. P',
          specialty: Lang.cardiology,
          date: '09-12-2025',
          reason: Lang.chestPain,
          findings: Lang.midIssue,
          plan: Lang.midIssue,
        ),
        const SizedBox(height: 12),
        _buildVisitCard(
          context,
          doctorName: 'Dr. P',
          specialty: Lang.cardiology,
          date: '09-12-2025',
          reason: Lang.chestPain,
          findings: Lang.midIssue,
          plan: Lang.midIssue,
        ),
      ],
    );
  }

  Widget _buildVisitCard(
    BuildContext context, {
    required String doctorName,
    required String specialty,
    required String date,
    required String reason,
    required String findings,
    required String plan,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with doctor and date
          Row(
            children: [
              // Doctor profile picture
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.cardGray,
                backgroundImage: const AssetImage(AppAssets.profile),
              ),
              const SizedBox(width: 12),
              // Doctor name and specialty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headline5(
                      '$doctorName ($specialty)',
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              // Date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.calander,
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    subText3(
                      date,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Reason, Findings, Plan
          _buildVisitDetailRow(Lang.reason, reason),
          const SizedBox(height: 8),
          _buildVisitDetailRow(Lang.findings, findings),
          const SizedBox(height: 8),
          _buildVisitDetailRow(Lang.plan, plan),
          const SizedBox(height: 16),
          // Bottom row with Active status and Details button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Active status
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  subText3(
                    Lang.active,
                    color: AppColors.green,
                    align: TextAlign.start,
                  ),
                ],
              ),
              // Details button
              SizedBox(
                height: 36,
                child: AppElevatedButton(
                  onPressed: () {
                    // Handle details
                  },
                  title: Lang.details,
                  backgroundColor: AppColors.primary,
                  width: 100,
                  height: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisitDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: subText3(
            label,
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
        ),
        Expanded(
          child: subText2(
            value,
            color: AppColors.headingTextColor,
            align: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
