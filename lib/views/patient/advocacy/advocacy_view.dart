import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/patient/advocacy/widgets/caregiverCard.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../../core/models/care_givermodel.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import 'add_caregiver_view.dart';
import 'controller/advocacyController.dart';

class AdvocacyView extends GetView<AdvocacyController> {
  const AdvocacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoader(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'Caregiver Access',
                  ),
                  //   Expanded(

                  //child:
                  _buildCaregiverContent(controller),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

  /// Caregiver Content
  Widget _buildCaregiverContent(AdvocacyController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildAddCaregiverButton(),
                const SizedBox(height: 24),
                Obx(() => controller.caregivers.length > 0
                    ? subText2(
                        'Caregiver Access',
                        color: AppColors.headingTextColor,
                        align: TextAlign.start,
                        fontWeight: FontWeight.w600,
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => controller.caregivers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.textColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        subText4(
                          'No caregivers added yet',
                          color: AppColors.textColor,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.caregivers.length,
                    itemBuilder: (context, index) {
                      final caregiver = controller.caregivers[index];
                      return _buildCaregiverCard(controller, caregiver);
                    },
                  )),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCaregiverButton() {
    return Builder(builder: (context) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCaregiverView()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              subText5(
                fontSize: 13,
                'Add Caregiver ',
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.white,
                size: 20,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCaregiverCard(
      AdvocacyController controller, Caregiver caregiver) {
    return Builder(builder: (context) {
      final permissions = <String>[];
      if (caregiver.canView == '1') permissions.add('View Records');
      if (caregiver.canAddNotes == '1') permissions.add('Add Notes');

      return CaregiverCard(
        profileImage: caregiver.caregiver.avatar ?? '',
        name: caregiver.caregiver.name,
        role: caregiver.relationship,
        email: caregiver.caregiver.email,
        addedDate: caregiver.createdAt.split('T')[0],
        permissions: permissions,
        onDelete: () => _showDeleteDialog(context, controller, caregiver),
        onDetails: () =>
            controller.showCaregiverDetails(caregiver.caregiver.id),
      );
    });
  }

  void _showDeleteDialog(BuildContext context, AdvocacyController controller,
      Caregiver caregiver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.lightRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.redColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Remove Caregiver',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.headingTextColor,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to remove ${caregiver.caregiver.name} as a caregiver? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'Satoshi',
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: AppColors.dividerGray),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.headingTextColor,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await controller
                              .deleteCaregiver(caregiver.caregiver.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
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
      },
    );
  }
}
