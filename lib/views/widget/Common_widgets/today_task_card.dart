import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../text.dart';

class TodayTaskCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget icon;
  final String title;
  final bool isCompleted;

  const TodayTaskCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            radius: 18,
            child: Center(child: icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: subText5(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              title,
              color: AppColors.headingTextColor,
              align: TextAlign.start,
            ),
          ),
          if (isCompleted)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 20,
                ),
                const SizedBox(width: 6),
                subText5(
                  fontWeight: FontWeight.w500,
                  Lang.completed,
                  fontSize: 12,
                  color: AppColors.green,
                  align: TextAlign.start,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
