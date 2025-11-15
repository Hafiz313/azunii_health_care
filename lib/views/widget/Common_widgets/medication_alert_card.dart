import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../consts/colors.dart';
import '../text.dart';

class MedicationAlertCard extends StatelessWidget {
  final String message;

  const MedicationAlertCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.redColor, width: 0.1),
        color: AppColors.alertRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.redColor.withValues(alpha: 0.3),
            radius: 18,
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: AppColors.redColor,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: subText5(
              message,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.headingTextColor,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
