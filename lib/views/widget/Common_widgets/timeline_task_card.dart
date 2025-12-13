import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../core/models/timeline_model.dart';
import '../text.dart';

class TimelineTaskCard extends StatelessWidget {
  final dynamic item;
  final Color? bgColor;
  final IconData? icon;

  const TimelineTaskCard(
      {super.key, required this.item, this.bgColor, this.icon});

  @override
  Widget build(BuildContext context) {
    final bool isSchedule = item is MedicineSchedule;
    final String type = isSchedule
        ? (item as MedicineSchedule).type
        : (item as TimelineEvent).type;
    final String title = isSchedule
        ? (item as MedicineSchedule).medicineName
        : (item as TimelineEvent).title;
    final String time = isSchedule
        ? _formatTime((item as MedicineSchedule).time)
        : _formatTimestamp((item as TimelineEvent).timestamp);
    final String status = isSchedule
        ? (item as MedicineSchedule).status
        : (item as TimelineEvent).status;
    final String? subtitle = isSchedule
        ? (item as MedicineSchedule).dosage
        : (item as TimelineEvent).subtitle;
    final String? frequency =
        isSchedule ? (item as MedicineSchedule).frequency : null;

    final cardStyle = _getCardStyle(type, status);
    final displayBgColor = bgColor ?? cardStyle['bgColor'];
    final displayIcon = icon ?? cardStyle['icon'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: displayBgColor, width: 1),
        color: displayBgColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: displayBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                displayIcon,
                color: cardStyle['iconColor'],
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subText5(
                  title,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                ),
                if (subtitle != null) ...[
                  subText5(
                    subtitle,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                    align: TextAlign.start,
                  ),
                ],
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 13,
                      color: AppColors.textColor,
                    ),
                    const SizedBox(width: 6),
                    subText5(
                      time,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                    if (frequency != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: subText5(
                          frequency,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.headingTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getCardStyle(String type, String status) {
    switch (type) {
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

  String _formatTime(String time) {
    if (time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    }
    return time;
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timestamp;
    }
  }
}
