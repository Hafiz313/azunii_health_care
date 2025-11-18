import 'package:Azunii_Health/consts/assets.dart';
import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../care_taker/settings/notification/notification_view.dart';

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
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
    //child:
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.textColor, width: 0.02)),
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
              child: subText5(
                title,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                //fontWeight: FontWeight.w400,
                color: AppColors.headingTextColor,
              ),
            ),
          ),

          // Trailing icon (e.g. bell)
          GestureDetector(
            onTap: onIconTap ??
                () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationView()),
                    ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.11,
              height: MediaQuery.of(context).size.width * 0.11,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.notificationBing,
                  width: 21,
                  height: 21,
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
      //  ),
    );
  }
}
