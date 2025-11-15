import 'package:azunii_health_care/consts/colors.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final String title;
  final String time;
  final VoidCallback? onTap;

  const TaskCard({
    Key? key,
    required this.backgroundColor,
    required this.iconColor,
    this.iconBackgroundColor = Colors.white,
    required this.icon,
    required this.title,
    required this.time,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBackgroundColor.withOpacity(0.7),
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
                  subText5(
                    title,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(width: 6),
                      subText5(
                        time,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
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
      ),
    );
  }
}
