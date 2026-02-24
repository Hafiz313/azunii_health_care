import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../text.dart';

class TodayTaskCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget icon;
  final String title;
  final bool isCompleted;
  final String? status;
  final Color? color;
  final VoidCallback? onTap;

  const TodayTaskCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.isCompleted,
    this.color,
    this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: backgroundColor.withOpacity(1),
              radius: 18,
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: subText5(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                title,
                color: AppColors.headingTextColor,
                align: TextAlign.start,
              ),
            ),
            subText5(
              fontWeight: FontWeight.w500,
              status ?? (isCompleted ? 'Active' : 'In Active'),
              fontSize: 12,
              color: isCompleted ? color ?? Colors.green : color ?? Colors.red,
              align: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
