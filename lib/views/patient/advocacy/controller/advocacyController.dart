import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/care_givermodel.dart';
import '../../../../core/repositories/caregivers_repo.dart';
import '../../../widget/Common_widgets/detail_dialog.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';

class AdvocacyController extends BaseController {
  final CaregiversRepository _caregiversRepository = CaregiversRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final RxString selectedRelationship = ''.obs;
  final RxBool viewPermission = true.obs;
  final RxBool addNotesPermission = true.obs;
  final RxList<Caregiver> caregivers = <Caregiver>[].obs;

  // Update permissions dialog variables
  final RxBool updateViewPermission = true.obs;
  final RxBool updateAddNotesPermission = true.obs;

  final List<String> relationships = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Friend',
    'Family Member',
    'Healthcare Provider',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCaregivers();
  }

  Future<void> fetchCaregivers() async {
    final result =
        await safeApiCall(() => _caregiversRepository.getCaregivers());
    if (result != null) {
      caregivers.value = result.caregivers;
    }
  }

  Future<void> deleteCaregiver(int id) async {
    final result =
        await safeApiCall(() => _caregiversRepository.destroyCaregiver(id));
    await fetchCaregivers();
    if (result != null) {
      CustomSnackbar.show('Caregiver removed successfully', isSuccess: true);
    }
  }

  Future<void> showCaregiverDetails(int id) async {
    final result =
        await safeApiCall(() => _caregiversRepository.getCaregiverDetail(id));
    if (result != null) {
      _showCaregiverDetailsDialog(result.caregiver);
    }
  }

  void _showCaregiverDetailsDialog(CaregiverDetail caregiver) {
    final permissions = <String>[];
    if (caregiver.canView == '1') permissions.add('View Records');
    if (caregiver.canAddNotes == '1') permissions.add('Add Notes');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile header
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    caregiver.name.isNotEmpty
                        ? caregiver.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  caregiver.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.headingTextColor,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  caregiver.relationship,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const SizedBox(height: 20),

                // Details section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.email_outlined, 'Email', caregiver.email),
                      if (caregiver.phone != null) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(Icons.phone_outlined, 'Phone', caregiver.phone!),
                      ],
                      if (caregiver.gender != null) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(Icons.person_outline, 'Gender', caregiver.gender!),
                      ],
                      const SizedBox(height: 12),
                      _buildDetailRow(Icons.calendar_today_outlined, 'Added', caregiver.createdAt.split('T')[0]),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.circle,
                        'Status',
                        caregiver.status,
                        valueColor: caregiver.status.toLowerCase() == 'active'
                            ? AppColors.green
                            : AppColors.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Permissions section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permissions',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.headingTextColor,
                          fontFamily: 'Satoshi',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPermissionBadge(
                        'View Records',
                        caregiver.canView == '1',
                      ),
                      const SizedBox(height: 8),
                      _buildPermissionBadge(
                        'Add Notes',
                        caregiver.canAddNotes == '1',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: AppColors.dividerGray),
                        ),
                        child: Text(
                          'Close',
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
                        onPressed: () => showUpdatePermissionsDialog(caregiver),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Edit Permissions',
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                  fontFamily: 'Satoshi',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? AppColors.headingTextColor,
                  fontFamily: 'Satoshi',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionBadge(String label, bool isGranted) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isGranted ? AppColors.lightGreen : AppColors.lightRed,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            isGranted ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: isGranted ? AppColors.green : AppColors.redColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.headingTextColor,
            fontFamily: 'Satoshi',
          ),
        ),
        const Spacer(),
        Text(
          isGranted ? 'Allowed' : 'Denied',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isGranted ? AppColors.green : AppColors.redColor,
            fontFamily: 'Satoshi',
          ),
        ),
      ],
    );
  }

  void showUpdatePermissionsDialog(CaregiverDetail caregiver) {
    // Initialize with current values
    updateViewPermission.value = caregiver.canView == '1';
    updateAddNotesPermission.value = caregiver.canAddNotes == '1';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.security_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Permissions',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.headingTextColor,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          caregiver.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textColor,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Permission toggles
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Obx(() => _buildPermissionToggle(
                      icon: Icons.visibility_outlined,
                      title: 'View Records',
                      subtitle: 'Access patient records',
                      value: updateViewPermission.value,
                      onChanged: (v) => updateViewPermission.value = v,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: AppColors.dividerGray),
                    ),
                    Obx(() => _buildPermissionToggle(
                      icon: Icons.note_add_outlined,
                      title: 'Add Notes',
                      subtitle: 'Create patient notes',
                      value: updateAddNotesPermission.value,
                      onChanged: (v) => updateAddNotesPermission.value = v,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
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
                      onPressed: () => updateCaregiverPermissions(caregiver.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save Changes',
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
      ),
    );
  }

  Widget _buildPermissionToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingTextColor,
                  fontFamily: 'Satoshi',
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textColor,
                  fontFamily: 'Satoshi',
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Future<void> updateCaregiverPermissions(int caregiverId) async {
    // Close update permissions dialog
    Get.back();
    // Close details dialog
    Get.back();

    final result = await safeApiCall(
      () => _caregiversRepository.updateCaregiverAccess(
        caregiverId: caregiverId,
        canView: updateViewPermission.value ? 1 : 0,
        canAddNotes: updateAddNotesPermission.value ? 1 : 0,
      ),
    );

    if (result != null) {
      // Refresh caregivers list
      await fetchCaregivers();
      // Show success message
      final message =
          result['message'] ?? 'Caregiver permissions updated successfully';
      CustomSnackbar.show(message, isSuccess: true);
    }
  }

  void setRelationship(String relationship) {
    selectedRelationship.value = relationship;
  }

  void toggleViewPermission(bool value) {
    viewPermission.value = value;
  }

  void toggleAddNotesPermission(bool value) {
    addNotesPermission.value = value;
  }

  Future<void> handleSendInvitation() async {
    if (emailController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        selectedRelationship.value.isEmpty) {
      CustomSnackbar.show('Please fill in all required fields',
          isSuccess: false);
      return;
    }

    final caregiverData = {
      'email': emailController.text.trim(),
      'full_name': fullNameController.text.trim(),
      'relationship': selectedRelationship.value,
      'can_view': viewPermission.value ? 1 : 0,
      'can_add_notes': addNotesPermission.value ? 1 : 0,
    };

    final result = await safeApiCall(
        () => _caregiversRepository.storeCaregivers(caregiverData));

    if (result != null) {
      // Show success message from API
      final message = result['message'] ?? 'Caregiver invited successfully';

      // Clear fields after successful API call
      emailController.clear();
      fullNameController.clear();
      selectedRelationship.value = '';
      viewPermission.value = true;
      addNotesPermission.value = true;
      Get.back();
      CustomSnackbar.show(message, isSuccess: true);
    }

    await fetchCaregivers();
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    Get.delete<AdvocacyController>();
    super.dispose();
  }
}
