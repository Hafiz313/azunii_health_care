import 'package:azunii_health_care/networking/api_provider.dart';
import 'package:azunii_health_care/utils/my_loader.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../core/models/response/DashBoardModel.dart';
import '../../../core/models/response/GetEmpModels.dart';
import '../../widget/buttonsV1.dart';
import '../../widget/text.dart';
import '../controller/home_controller.dart';
import '../home_widget.dart';
import 'PunchInDialog.dart';

class PunchInWidget extends StatelessWidget {
  // final DashBoardModel data;
  // final VoidCallback onPressPunchIn;
  // final bool isPunchIn;
  // final int hour;
  // final int mint;
  // final int sec;

  const PunchInWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: context.percentHeight * 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(
              () => mainLoading.value
                  ? const SizedBox(
                      height: 200,
                      child: MyLoader(
                        color: AppColors.white,
                      ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.percentHeight * 1),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.percentHeight * 1),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(FontAwesomeIcons.calendarDays,
                                          color: AppColors.white,
                                          size: context.percentWidth * 4.0),
                                      SizedBox(width: context.percentWidth * 1),
                                      subText4(
                                          DateFormat('MM/dd/yyyy')
                                              .format(DateTime.now()),
                                          color: AppColors.white),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: _buildRollTypeInfo(
                                          context, controller)),
                                  Expanded(
                                      flex: 1,
                                      child: _buildPunchInButton(
                                          context, controller)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.percentHeight * 1),
                        _divider(context),
                        SizedBox(height: context.percentHeight * 1),
                        _buildPunchInTime(context, controller),
                        SizedBox(height: context.percentHeight * 1),
                        _divider(context),
                        SizedBox(height: context.percentHeight * 1),
                        hoursWidget(context,
                            data: controller.dashboardModel.value),
                      ],
                    ),
            )),
        subText4("", color: AppColors.redColor)
      ],
    );
  }

  /// **Profile Information**
  Widget _buildProfileInfo(BuildContext context, HomeController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 1.0),
      padding: EdgeInsets.only(
        left: context.percentWidth * 4.0,
        right: context.percentWidth * 4.0,
      ),
      child: Row(
        children: [
          _buildProfileImage(context),
          SizedBox(width: context.percentWidth * 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subText5(Lang.welcome, color: AppColors.white),
              subText1(controller.dashboardModel.value.result?.name ?? "---",
                  color: AppColors.white, fontWeight: FontWeight.bold),
              subText5(
                  controller.dashboardModel.value.result?.designation ?? '--',
                  color: AppColors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRollTypeInfo(BuildContext context, HomeController controller) {
    return InkWell(
      onTap: () async {
        if (controller.isMultiJob.value) {
          controller.getJobDialog(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(7)),
        margin: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 1.0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: context.percentWidth * 2.0,
          horizontal: context.percentWidth * 2.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Obx(() {
                  final selectedJob = controller.jobEmpList
                      .firstWhereOrNull((job) => job.selected);
                  return subText4(
                    controller.selectedJob.value.jobDescription ??
                        '${controller.dashboardModel.value.result!.name}',
                    // controller.selectedJob.value.jobDescription ?? 'Select Job',
                    color: AppColors.blackColor,
                  );
                }),
              ),
            ),
            if (controller.isMultiJob.value) const Icon(Icons.expand_more)
          ],
        ),
      ),
    );
  }

  /// **Profile Image**
  Widget _buildProfileImage(BuildContext context) {
    return Container(
      height: context.percentHeight * 10,
      width: context.percentWidth * 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 1),
        image: const DecorationImage(
          image: AssetImage(AppAssets.profile),
        ),
      ),
    );
  }

  /// **Punch In Button & Date**
  Widget _buildPunchInButton(BuildContext context, HomeController controller) {
    return Container(
      // margin: EdgeInsets.only(
      //   top: context.percentWidth * 2,
      //   right: context.percentHeight * 1,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppElevatedButtonV1(
            backgroundColor: controller.isPunchIn.value
                ? AppColors.green
                : AppColors.redColor,

            onPressed: () {
              // Use the new controller method for handling punch in/out
              controller.handlePunchInOut(context);
            },
            title: controller.isPunchIn.value ? Lang.punchIn : Lang.punchOut,
          ),
        ],
      ),
    );
  }

  /// **Punch In Time & Timer**
  Widget _buildPunchInTime(BuildContext context, HomeController con) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPunchInDetails(context, con),
        _buildTimer(context, con),
      ],
    );
  }

  /// **Punch In Details**
  Widget _buildPunchInDetails(BuildContext context, HomeController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 1.5),
      padding: EdgeInsets.symmetric(
        horizontal: context.percentWidth * 2.0,
        vertical: context.percentHeight * 1.0,
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.clock,
              color: AppColors.white, size: context.percentWidth * 6.0),
          SizedBox(width: context.percentWidth * 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subText4(Lang.punchInAt,
                  color: AppColors.white, fontWeight: FontWeight.w600),
              subText5(
                _formatPunchInTime(controller),
                color: AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// **Punch In Time Formatting**
  String _formatPunchInTime(HomeController controller) {
    if (controller.dashboardModel.value.result?.punchInTime == null)
      return "--";
    DateTime punchInTime = DateTime.parse(
        controller.dashboardModel.value.result!.punchInTime.toString());
    // return controller.dashboardModel.value.result!.punchInTime.toString();
    return '${DateFormat('hh:mm a').format(punchInTime)} '
        '${DateFormat('EEEE').format(punchInTime)} '
        '${DateFormat('MM/dd/yyyy').format(punchInTime)}';
  }

  /// **Timer Display**
  Widget _buildTimer(BuildContext context, HomeController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          timeCard(context,
              time: _formatTime(controller.hours.value), title: Lang.hours),
          SizedBox(width: context.percentWidth * 2),
          timeCard(context,
              time: _formatTime(controller.minutes.value), title: Lang.minutes),
          SizedBox(width: context.percentWidth * 2),
          timeCard(context,
              time: _formatTime(controller.seconds.value), title: Lang.seconds),
        ],
      ),
    );
  }

  /// **Format Time (Ensure 2 Digits)**
  String _formatTime(int value) => value.toString().padLeft(2, '0');

  /// **Divider**
  Widget _divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
      height: 0.8,
      color: AppColors.borderColor,
    );
  }
}

class SwitchJobConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to\nswitch the job?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF), // purple
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
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
