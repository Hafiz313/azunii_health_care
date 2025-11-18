import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_dropdown.dart';
import 'package:Azunii_Health/views/widget/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import 'controller/advocacyController.dart';

class AddCaregiverView extends StatelessWidget {
  const AddCaregiverView({super.key});

  static const String routeName = '/add-caregiver';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvocacyController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Add Caregiver',
            ),
            Expanded(
              child: _buildAddCaregiverContent(controller),
            ),
          ],
        ),
      ),
    );
  }

  /// Add Caregiver Content
  Widget _buildAddCaregiverContent(AdvocacyController controller) {
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              subText5(
                fontSize: 14,
                'Add Caregiver',
                color: AppColors.headingTextColor,
                align: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: context.screenHeight * 0.04),

              // Email Field
              CustomTxtField(
                title: 'Email',
                textEditingController: controller.emailController,
                hintTxt: 'Enter Your Email',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textColor,
                  size: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Full Name Field
              CustomTxtField(
                title: 'Full Name',
                textEditingController: controller.fullNameController,
                hintTxt: 'Enter Your Full Name',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textColor,
                  size: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Relationship Dropdown
              SizedBox(
                width: double.infinity,
                child: Obx(() => CustomDropdown(
                      label: 'Relationship',
                      hintText: 'Select Relationship',
                      items: controller.relationships,
                      selectedValue:
                          controller.selectedRelationship.value.isEmpty
                              ? null
                              : controller.selectedRelationship.value,
                      onChanged: (value) => controller.setRelationship(value!),
                      prefixIcon: const Icon(
                        Icons.people_outline,
                        size: 18,
                        color: AppColors.textColor,
                      ),
                    )),
              ),

              const SizedBox(height: 32),

              // Permissions Section
              _buildPermissionsSection(context, controller),

              SizedBox(height: context.screenHeight * 0.05),

              // Action Buttons
              _buildActionButtons(controller),

              SizedBox(height: context.screenHeight * 0.025),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPermissionsSection(
      BuildContext context, AdvocacyController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // View Permission
        Obx(() => _buildPermissionToggle(
              context: context,
              icon: Icons.visibility_outlined,
              title: 'View',
              value: controller.viewPermission.value,
              onChanged: controller.toggleViewPermission,
            )),

        SizedBox(height: context.screenHeight * 0.02),

        // Add Notes Permission
        Obx(() => _buildPermissionToggle(
              context: context,
              icon: Icons.note_add_outlined,
              title: 'Add Notes',
              value: controller.addNotesPermission.value,
              onChanged: controller.toggleAddNotesPermission,
            )),
      ],
    );
  }

  Widget _buildPermissionToggle({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: context.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: subText5(
              title,
              fontSize: 14,
              color: AppColors.headingTextColor,
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            inactiveThumbColor: AppColors.textColor,
            inactiveTrackColor: AppColors.dividerGray,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AdvocacyController controller) {
    return Row(
      children: [
        Expanded(
          child: AppElevatedButton(
            onPressed: () {
              Get.back();
            },
            title: 'Cancel',
            textColor: AppColors.borderColor,
            backgroundColor: AppColors.cardGray,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppElevatedButton(
            onPressed: controller.handleSendInvitation,
            title: 'Send Invitation',
            backgroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
