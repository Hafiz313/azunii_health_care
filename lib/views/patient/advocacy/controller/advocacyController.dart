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
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caregiver Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headingTextColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Full Name', caregiver.name),
              _buildDetailRow('Email', caregiver.email),
              if (caregiver.phone != null)
                _buildDetailRow('Phone', caregiver.phone!),
              if (caregiver.gender != null)
                _buildDetailRow('Gender', caregiver.gender!),
              _buildDetailRow('Relationship', caregiver.relationship),
              _buildDetailRow(
                  'Can View', caregiver.canView == '1' ? 'Yes' : 'No'),
              _buildDetailRow(
                  'Can Add Notes', caregiver.canAddNotes == '1' ? 'Yes' : 'No'),
              _buildDetailRow('Status', caregiver.status),
              _buildDetailRow('Added Date', caregiver.createdAt.split('T')[0]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Close'),
                  ),
                  const SizedBox(width: 0),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () => showUpdatePermissionsDialog(caregiver),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Update Permissions',
                          style:
                              TextStyle(color: AppColors.white, fontSize: 11),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: AppColors.textColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void showUpdatePermissionsDialog(CaregiverDetail caregiver) {
    // Initialize with current values
    updateViewPermission.value = caregiver.canView == '1';
    updateAddNotesPermission.value = caregiver.canAddNotes == '1';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Permissions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headingTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Update access permissions for ${caregiver.name}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => SwitchListTile(
                    title: Text('Can View Records'),
                    subtitle: Text('Allow caregiver to view patient records'),
                    value: updateViewPermission.value,
                    onChanged: (value) => updateViewPermission.value = value,
                    activeColor: AppColors.primary,
                  )),
              const SizedBox(height: 12),
              Obx(() => SwitchListTile(
                    title: Text('Can Add Notes'),
                    subtitle: Text('Allow caregiver to add notes'),
                    value: updateAddNotesPermission.value,
                    onChanged: (value) =>
                        updateAddNotesPermission.value = value,
                    activeColor: AppColors.primary,
                  )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => updateCaregiverPermissions(caregiver.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(color: AppColors.white),
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

  Future<void> updateCaregiverPermissions(int caregiverId) async {
    final result = await safeApiCall(
      () => _caregiversRepository.updateCaregiverAccess(
        caregiverId: caregiverId,
        canView: updateViewPermission.value ? 1 : 0,
        canAddNotes: updateAddNotesPermission.value ? 1 : 0,
      ),
    );

    if (result != null) {
      // Close update dialog
      Get.back();
      // Close details dialog
      Get.back();
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
