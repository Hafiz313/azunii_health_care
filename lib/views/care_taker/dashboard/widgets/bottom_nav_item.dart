import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../consts/colors.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';

class BottomNavItem1 extends StatelessWidget {
  final String svgIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavItem1({
    super.key,
    required this.svgIcon,
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
        padding: EdgeInsets.symmetric(
            vertical: context.screenWidth * 0.02,
            horizontal: context.screenWidth * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgIcon,
              width: context.screenWidth * 0.05,
              height: context.screenWidth * 0.05,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : AppColors.textColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: context.screenWidth * 0.01),
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
