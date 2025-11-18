import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import 'widgets/visitcardwidget.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.timeline,
            ),
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

  /// As of Today Section
  Widget _buildAsOfTodaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with date and star icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subText5(Lang.asOfToday,
                color: AppColors.headingTextColor, fontSize: 14),
            const SizedBox(width: 12),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                    '09-12-2025',
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
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
            )
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subText4(
                  title,
                  fontWeight: FontWeight.w500,
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
            headline6(
              Lang.visitTimeline,
              color: AppColors.headingTextColor,
              //  textAlign: TextAlign.start,
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _getVisits().length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return VisitCard(visit: _getVisits()[index]);
          },
        ),
      ],
    );
  }

  List<Visit> _getVisits() {
    return [
      Visit(
        doctorName: 'Dr. P',
        specialty: Lang.cardiology,
        date: '09-12-2025',
        details: [
          VisitDetail(label: Lang.reason, value: Lang.chestPain),
          VisitDetail(label: Lang.findings, value: Lang.midIssue),
          VisitDetail(label: Lang.plan, value: Lang.midIssue),
        ],
        onDetailsPressed: () {
          // Handle details
        },
      ),
      Visit(
        doctorName: 'Dr. P',
        specialty: Lang.cardiology,
        date: '09-12-2025',
        details: [
          VisitDetail(label: Lang.reason, value: Lang.chestPain),
          VisitDetail(label: Lang.findings, value: Lang.midIssue),
          VisitDetail(label: Lang.plan, value: Lang.midIssue),
        ],
        onDetailsPressed: () {
          // Handle details
        },
      ),
    ];
  }
}
