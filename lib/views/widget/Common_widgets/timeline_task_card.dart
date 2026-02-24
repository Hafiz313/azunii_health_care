import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../core/models/timeline_model.dart';
import '../../../utils/percentage_size_ext.dart';
import '../text.dart';

class TimelineTaskCard extends StatelessWidget {
  final MedicineSchedule item;
  final Color? bgColor;
  final IconData? icon;
  final VoidCallback? onTap;

  const TimelineTaskCard({
    super.key,
    required this.item,
    this.bgColor,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = _getCardStyle(item.type, item.status);
    final displayBgColor = bgColor ?? cardStyle['bgColor'];
    final displayIcon = icon ?? cardStyle['icon'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: context.screenHeight * 0.012,
            horizontal: context.screenWidth * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: displayBgColor, width: 1),
          color: displayBgColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(context.screenWidth * 0.03),
        ),
        child: Row(
          children: [
            Container(
              width: context.screenWidth * 0.09,
              height: context.screenWidth * 0.09,
              decoration: BoxDecoration(
                color: displayBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  displayIcon,
                  color: cardStyle['iconColor'],
                  size: context.screenWidth * 0.045,
                ),
              ),
            ),
            SizedBox(width: context.screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine name
                  subText5(
                    item.medicineName,
                    fontSize: context.screenWidth * 0.028,
                    fontWeight: FontWeight.w500,
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                  ),
                  // Dosage
                  if (item.dosage.isNotEmpty)
                    subText5(
                      item.dosage,
                      fontSize: context.screenWidth * 0.028,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                  // Status row
                  if (item.status.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          item.status == 'completed'
                              ? Icons.check_circle
                              : Icons.pending,
                          size: context.screenWidth * 0.033,
                          color: item.status == 'completed'
                              ? AppColors.green
                              : Colors.orange,
                        ),
                        SizedBox(width: context.screenWidth * 0.015),
                        subText5(
                          _formatFrequencyText(item.status),
                          fontSize: context.screenWidth * 0.025,
                          fontWeight: FontWeight.w400,
                          color: item.status == 'completed'
                              ? AppColors.green
                              : Colors.orange,
                          align: TextAlign.start,
                        ),
                      ],
                    ),
                  // Show ALL frequencies dynamically
                  ...item.frequencies.map((freq) {
                    final showTime =
                        freq.frequency.toLowerCase() != 'as_per_needed';
                    final freqLabel = _formatFrequencyText(freq.frequency);
                    return Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          if (showTime) ...[
                            Icon(
                              Icons.access_time,
                              size: context.screenWidth * 0.033,
                              color: AppColors.textColor,
                            ),
                            SizedBox(width: context.screenWidth * 0.015),
                            subText5(
                              _formatTime(freq.time),
                              fontSize: context.screenWidth * 0.028,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor,
                              align: TextAlign.start,
                            ),
                            SizedBox(width: context.screenWidth * 0.03),
                          ],
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.screenWidth * 0.02,
                                vertical: context.screenHeight * 0.002),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(
                                  context.screenWidth * 0.015),
                            ),
                            child: subText5(
                              freqLabel,
                              fontSize: context.screenWidth * 0.025,
                              fontWeight: FontWeight.w400,
                              color: AppColors.headingTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getCardStyle(String type, String status) {
    switch (type) {
      case 'medicine':
      case 'medicine_schedule':
        return {
          'bgColor': status == 'completed'
              ? AppColors.lightGreenCard
              : AppColors.lightBlue,
          'iconColor':
              status == 'completed' ? AppColors.green : Colors.blue[600]!,
          'icon': status == 'completed' ? Icons.check : Icons.medication,
        };
      case 'medicine_added':
        return {
          'bgColor': AppColors.lightBlue,
          'iconColor': Colors.blue[600]!,
          'icon': Icons.add_circle,
        };
      case 'medicine_updated':
        return {
          'bgColor': AppColors.lightYellow,
          'iconColor': Colors.orange[600]!,
          'icon': Icons.edit,
        };
      case 'visit':
        return {
          'bgColor': AppColors.lightGreenCard,
          'iconColor': AppColors.green,
          'icon': Icons.local_hospital,
        };
      default:
        return {
          'bgColor': AppColors.cardGray,
          'iconColor': AppColors.textColor,
          'icon': Icons.info,
        };
    }
  }

  String _formatFrequencyText(String raw) {
    switch (raw.toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      case 'every_other_day':
        return 'Every Other Day';
      case 'as_per_needed':
        return 'As Per Needed';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'missed':
        return 'Missed';
      case 'skipped':
        return 'Skipped';
      case 'active':
        return 'Active';
      default:
        return raw
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isEmpty
                ? w
                : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
            .join(' ');
    }
  }

  String _formatTime(String time) {
    if (time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        if (hour == 0) hour = 12;
        if (hour > 12) hour -= 12;
        return '$hour:$minute $period';
      }
    }
    return time;
  }
}
