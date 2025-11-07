import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  BottomNavigationBarItem _buildNavItem(
      String assetPath, int index, int selectedIndex) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        color:
            selectedIndex == index ? AppColors.primary : AppColors.blackColor,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomNavigationBar(
        items: [
          _buildNavItem(
            AppAssets.home,
            0,
            currentIndex,
          ),
          _buildNavItem(AppAssets.calander, 1, currentIndex),
          _buildNavItem(AppAssets.wallet, 2, currentIndex),
          _buildNavItem(AppAssets.bell, 3, currentIndex),
          _buildNavItem(AppAssets.remender, 4, currentIndex),
        ],
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        onTap: onTap,
      ),
    );
  }
}
