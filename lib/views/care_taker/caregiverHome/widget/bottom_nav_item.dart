import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../consts/colors.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.percentHeight * 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textColor,
              size: context.percentWidth * 5,
            ),
            SizedBox(height: context.percentHeight * 0.5),
            subText6(
              label,
              color: isSelected ? AppColors.primary : AppColors.textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}
