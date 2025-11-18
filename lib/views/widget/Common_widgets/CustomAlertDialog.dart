import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/consts/lang.dart';
import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String text;
  final String subText;
  final VoidCallback onTap;
  final Widget? icon;

  const CustomAlertDialog({
    Key? key,
    required this.text,
    required this.subText,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon (custom or default)
            icon ??
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.redColor,
                  size: 48,
                ),

            const SizedBox(height: 16),

            // Title
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.borderColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              subText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.alertRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Ok",
                      style: TextStyle(color: AppColors.borderColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppElevatedButton(
                    onPressed: onTap,
                    title: Lang.reviewMedications,
                    backgroundColor: AppColors.primary,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
