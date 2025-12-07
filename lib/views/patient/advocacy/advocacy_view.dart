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

class AdvocacyView extends StatelessWidget {
  const AdvocacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvocacyController());
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
                subText2(
                  'Caregiver Access',
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                  fontWeight: FontWeight.w600,
                ),
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
      if (caregiver.canView == 1) permissions.add('View Records');
      if (caregiver.canAddNotes == 1) permissions.add('Add Notes');

      return CaregiverCard(
        profileImage: '',
        name: caregiver.fullName,
        role: caregiver.relationship,
        email: caregiver.email,
        addedDate: caregiver.addedDate?.split('T')[0] ?? 'N/A',
        permissions: permissions,
        onDelete: () => _showDeleteDialog(context, controller, caregiver),
        onDetails: () {
          if (caregiver.id != null) {
            controller.showCaregiverDetails(caregiver.id!);
          }
        },
      );
    });
  }

  void _showDeleteDialog(BuildContext context, AdvocacyController controller,
      Caregiver caregiver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Caregiver'),
          content: Text(
              'Are you sure you want to remove ${caregiver.fullName} as a caregiver?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (caregiver.id != null) {
                  await controller.deleteCaregiver(caregiver.id!);
                }
              },
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.redColor)),
            ),
          ],
        );
      },
    );
  }
}
