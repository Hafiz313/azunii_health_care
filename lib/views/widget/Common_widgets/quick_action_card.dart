import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../text.dart';

class QuickActionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textColor, width: 0.1),
          color: AppColors.cardGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: subText5(
                title,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.headingTextColor,
                align: TextAlign.start,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textColor,
            ),
          ],
        ),
      ),
    );
  }
}
