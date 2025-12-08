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
      DetailDialog(
        title: 'Caregiver Details',
        details: [
          DetailRow(label: 'Full Name', value: caregiver.name),
          DetailRow(label: 'Email', value: caregiver.email),
          if (caregiver.phone != null)
            DetailRow(label: 'Phone', value: caregiver.phone!),
          if (caregiver.gender != null)
            DetailRow(label: 'Gender', value: caregiver.gender!),
          DetailRow(label: 'Relationship', value: caregiver.relationship),
          DetailRow(
              label: 'Can View',
              value: caregiver.canView == '1' ? 'Yes' : 'No'),
          DetailRow(
              label: 'Can Add Notes',
              value: caregiver.canAddNotes == '1' ? 'Yes' : 'No'),
          DetailRow(label: 'Status', value: caregiver.status),
          DetailRow(
              label: 'Added Date', value: caregiver.createdAt.split('T')[0]),
        ],
      ),
    );
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

    await safeApiCall(
        () => _caregiversRepository.storeCaregivers(caregiverData));
    Get.back();
    await fetchCaregivers();
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}
