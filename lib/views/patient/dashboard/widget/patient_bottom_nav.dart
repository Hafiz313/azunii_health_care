import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../consts/assets.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../controller/patient_home_controller.dart';
import 'bottom_nav_item.dart';

class PatientBottomNav extends StatelessWidget {
  const PatientBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientHomeController>();

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
              Obx(() => BottomNavItem(
                    svgIcon: AppAssets.home,
                    label: Lang.home,
                    isSelected: controller.currentIndex.value == 0,
                    onTap: () => controller.changePage(0),
                  )),
              Obx(() => BottomNavItem(
                    svgIcon: AppAssets.pills,
                    label: Lang.medicines,
                    isSelected: controller.currentIndex.value == 1,
                    onTap: () => controller.changePage(1),
                  )),
              Obx(() => BottomNavItem(
                    svgIcon: AppAssets.note,
                    label: Lang.visits,
                    isSelected: controller.currentIndex.value == 2,
                    onTap: () => controller.changePage(2),
                  )),
              Obx(() => BottomNavItem(
                    svgIcon: AppAssets.note2,
                    label: Lang.summary,
                    isSelected: controller.currentIndex.value == 3,
                    onTap: () => controller.changePage(3),
                  )),
              Obx(() => BottomNavItem(
                    svgIcon: AppAssets.time,
                    label: Lang.timeline,
                    isSelected: controller.currentIndex.value == 4,
                    onTap: () => controller.changePage(4),
                  )),
              Obx(() => BottomNavItem(
                    svgIcon: AppAssets.messages,
                    label: Lang.advocacy,
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
