import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:Azunii_Health/views/widget/text_fields.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import 'controller/summary_controller.dart';
import '../feedback/feedback_view.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SummaryController());
    return Obx(() => OverlayLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  title: Lang.plainLanguageSummary,
                ),
                Expanded(
                  child: _buildPlainLanguageSummary(context),
                ),
              ],
            ),
          ),
        )));
  }

  /// App Bar with back button, title, and feedback button

  /// Plain Language Summary View
  Widget _buildPlainLanguageSummary(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          subText5('Plain-Language Summary',
              color: AppColors.headingTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 14),
          SizedBox(height: context.screenHeight * 0.015),
          subText5(
              'Write your medical instructions in simple, everyday language',
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              align: TextAlign.start,
              fontSize: 12),
          SizedBox(height: context.screenHeight * 0.01),
          subText5(
              'This summary helps you remember what your doctor told you in words you can easily understand. Include things like when to take medications, what to watch out for, and when to call your doctor.',
              color: AppColors.textColor,
              align: TextAlign.start,
              fontWeight: FontWeight.w400,
              fontSize: 12),

          SizedBox(height: context.screenHeight * 0.02),

          // Example Summary Section

          SizedBox(height: context.screenHeight * 0.01),
          _buildExampleSummaryCard(context),

          // Your Medical Instructions Section

          SizedBox(height: context.screenHeight * 0.02),
          _buildInstructionsForm(context),

          SizedBox(height: context.screenHeight * 0.04),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppElevatedButton(
                  onPressed: () {
                    Get.toNamed('/view-summaries');
                  },
                  title: 'View Summaries',
                  textColor: AppColors.borderColor,
                  backgroundColor: AppColors.cardGray,
                ),
              ),
              SizedBox(width: context.screenWidth * 0.04),
              Expanded(
                child: AppElevatedButton(
                  onPressed: () async {
                    final controller = Get.find<SummaryController>();
                    await controller.saveSummary();
                    // if (!controller.isLoading.value) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const FeedbackView()),
                    //   );
                    // }
                  },
                  title: 'Save Summary',
                  fontSize: 14,
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: context.screenHeight * 0.025),
        ],
      ),
    );
  }

  Widget _buildExampleSummaryCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardsColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subText5('Example Summary',
              color: AppColors.headingTextColor,
              align: TextAlign.start,
              fontWeight: FontWeight.w600,
              fontSize: 14),
          SizedBox(
            height: 5,
          ),
          subText5(
              '"Take blood pressure pill every morning with breakfast. Check your blood pressure at home twice a week. If the number is over 160 or you feel dizzy, call the doctor right away. Avoid eating too much salt. Come back in 2 weeks for a follow-up."',
              color: AppColors.textColor,
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ],
      ),
    );
  }

  Widget _buildInstructionsForm(BuildContext context) {
    final controller = Get.find<SummaryController>();
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.02),
      decoration: BoxDecoration(
        color: AppColors.cardsColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subText5('Summmary Instructions',
              color: AppColors.headingTextColor,
              align: TextAlign.start,
              fontWeight: FontWeight.w600,
              fontSize: 14),
          SizedBox(height: context.screenHeight * 0.02),
          CustomTxtField(
            textEditingController: controller.instructionsController,
            hintTxt:
                'Write your instructions here in simple, everyday language...',
            maxLines: 6,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          ),
        ],
      ),
    );
  }
}
