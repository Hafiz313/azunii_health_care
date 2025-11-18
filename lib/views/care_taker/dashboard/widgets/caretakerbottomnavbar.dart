import 'package:Azunii_Health/views/care_taker/dashboard/controller/caretaker_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../consts/assets.dart';
import '../../../../utils/percentage_size_ext.dart';

import 'bottom_nav_item.dart';

class CareTakerBottomNav extends StatelessWidget {
  const CareTakerBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CareTakerHomeController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: context.screenWidth * 0.16,
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() => BottomNavItem1(
                    svgIcon: AppAssets.home,
                    label: 'Home',
                    isSelected: controller.currentIndex.value == 0,
                    onTap: () => controller.changePage(0),
                  )),
              Obx(() => BottomNavItem1(
                    svgIcon: AppAssets.pills,
                    label: 'Medication',
                    isSelected: controller.currentIndex.value == 1,
                    onTap: () => controller.changePage(1),
                  )),
              Obx(() => BottomNavItem1(
                    svgIcon: AppAssets.note,
                    label: 'Notes',
                    isSelected: controller.currentIndex.value == 2,
                    onTap: () => controller.changePage(2),
                  )),
              Obx(() => BottomNavItem1(
                    svgIcon: AppAssets.note2,
                    label: 'Feedback',
                    isSelected: controller.currentIndex.value == 3,
                    onTap: () => controller.changePage(3),
                  )),
              Obx(() => BottomNavItem1(
                    svgIcon: AppAssets.access,
                    label: 'FAQs',
                    isSelected: controller.currentIndex.value == 4,
                    onTap: () => controller.changePage(4),
                  )),
              Obx(() => BottomNavItem1(
                    svgIcon: AppAssets.categories,
                    label: 'Settings',
                    isSelected: controller.currentIndex.value == 5,
                    onTap: () => controller.changePage(5),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
