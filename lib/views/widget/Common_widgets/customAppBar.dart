import 'package:azunii_health_care/consts/assets.dart';
import 'package:azunii_health_care/consts/colors.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  final VoidCallback? onIconTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          // Title in center
          Expanded(
            child: Center(
              child: headline5(
                title,
                fontWeight: FontWeight.w400,
                color: AppColors.headingTextColor,
              ),
            ),
          ),

          // Trailing icon (e.g. bell)
          GestureDetector(
            onTap: onIconTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.09,
              height: MediaQuery.of(context).size.width * 0.09,
              decoration: const BoxDecoration(
                color: AppColors.bellBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.bell,
                  width: 15,
                  height: 15,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
