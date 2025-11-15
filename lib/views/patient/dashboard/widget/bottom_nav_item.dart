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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textColor,
              size: 20,
            ),
            const SizedBox(height: 4),
            subText5(
              label,
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.textColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}
