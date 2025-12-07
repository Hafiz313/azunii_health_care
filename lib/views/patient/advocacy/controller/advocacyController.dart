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
    setLoading(true);
    try {
      final result =
          await safeApiCall(() => _caregiversRepository.getCaregivers());
      if (result != null) {
        caregivers.value = result;
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteCaregiver(int id) async {
    setLoading(true);
    try {
      await safeApiCall(() => _caregiversRepository.destroyCaregiver(id));
      await fetchCaregivers();
      CustomSnackbar.show('Caregiver removed successfully', isSuccess: true);
    } finally {
      setLoading(false);
    }
  }

  Future<void> showCaregiverDetails(int id) async {
    setLoading(true);
    try {
      final result =
          await safeApiCall(() => _caregiversRepository.getCaregiverDetail(id));
      if (result != null) {
        final caregiver = Caregiver.fromJson(result['data']);
        _showCaregiverDetailsDialog(caregiver);
      }
    } finally {
      setLoading(false);
    }
  }

  void _showCaregiverDetailsDialog(Caregiver caregiver) {
    Get.dialog(
      DetailDialog(
        title: 'Caregiver Details',
        details: [
          DetailRow(label: 'Full Name', value: caregiver.fullName),
          DetailRow(label: 'Email', value: caregiver.email),
          DetailRow(label: 'Relationship', value: caregiver.relationship),
          DetailRow(
              label: 'Can View', value: caregiver.canView == 1 ? 'Yes' : 'No'),
          DetailRow(
              label: 'Can Add Notes',
              value: caregiver.canAddNotes == 1 ? 'Yes' : 'No'),
          if (caregiver.addedDate != null)
            DetailRow(
                label: 'Added Date', value: caregiver.addedDate!.split('T')[0]),
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
      CustomSnackbar.show('Please fill in all required fields', isSuccess: false);
      return;
    }

    final caregiver = Caregiver(
      email: emailController.text.trim(),
      fullName: fullNameController.text.trim(),
      relationship: selectedRelationship.value,
      canView: viewPermission.value ? 1 : 0,
      canAddNotes: addNotesPermission.value ? 1 : 0,
    );

    setLoading(true);
    try {
      await safeApiCall(() => _caregiversRepository.storeCaregivers(caregiver));
      Get.back();
      // Get.snackbar(
      //   'Success',
      //   'Invitation sent successfully!',
      //   backgroundColor: AppColors.green,
      //   colorText: AppColors.white,
      //   snackPosition: SnackPosition.TOP,
      // );

      await fetchCaregivers();
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    } finally {
      setLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}
