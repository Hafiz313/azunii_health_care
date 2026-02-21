import 'package:Azunii_Health/app_routes.dart';
import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/models/static_user_model.dart';
import 'package:Azunii_Health/core/repositories/auth_repository.dart';
import 'package:Azunii_Health/core/repositories/Medicine_repo.dart';
import 'package:Azunii_Health/core/repositories/visits_repo.dart';
import 'package:Azunii_Health/core/repositories/profile_repository.dart';
import 'package:Azunii_Health/core/models/Medicine_model.dart';
import 'package:Azunii_Health/core/models/visit_model.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/utils/snackbar_helper.dart';
import 'package:Azunii_Health/utils/details_dialogs.dart';
import 'package:Azunii_Health/views/patient/medicines/edit_medication.dart';
import 'package:Azunii_Health/views/patient/visits/all_visits_view.dart';
import 'package:Azunii_Health/views/patient/visits/edit_visits_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';

import '../../../auth/login/login_view.dart';
import '../../medicines/medicines_view.dart';
import '../../visits/visits_view.dart';

class HomeController extends BaseController {
  final RxString selectedDate = ''.obs;
  final RxString userName = ''.obs;
  final RxString userProfileImage = ''.obs;
  final RxList<Medicine> allMedicinesList = <Medicine>[].obs;
  final RxList<Medicine> medicinesList = <Medicine>[].obs;
  final RxList<VisitModel> visitsList = <VisitModel>[].obs;
  final AuthRepository _authRepository = AuthRepository();
  final MedicineRepository _medicineRepository = MedicineRepository();
  final VisitsRepository _visitsRepository = VisitsRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  // Profile update controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ==========================================
  // All Medicines Screen - Pagination State
  // ==========================================
  final RxList<Medicine> allMedPageList = <Medicine>[].obs;
  final RxInt allMedCurrentPage = 1.obs;
  final RxInt allMedLastPage = 1.obs;
  final RxInt allMedTotal = 0.obs;
  final RxString allMedSelectedDate = ''.obs;
  final RxBool allMedLoading = false.obs;

  // ==========================================
  // All Visits Screen - Pagination State
  // ==========================================
  final RxList<VisitModel> allVisitsPageList = <VisitModel>[].obs;
  final RxInt allVisitsCurrentPage = 1.obs;
  final RxInt allVisitsLastPage = 1.obs;
  final RxInt allVisitsTotal = 0.obs;
  final RxString allVisitsSelectedDate = ''.obs;
  final RxBool allVisitsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  void loadUserData() {
    userName.value = 'John Doe';
    userProfileImage.value = '';
  }

  void updateDate(String date) {
    selectedDate.value = date;
  }

  void onDatePickerTap() async {
    DateTime initialDate;
    try {
      if (selectedDate.value.isEmpty) {
        initialDate = DateTime.now();
      } else {
        final parts = selectedDate.value.split('-');
        initialDate = DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      selectedDate.value =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      filterMedicinesByDate();
    }
  }

  void clearDateFilter() {
    selectedDate.value = '';
    filterMedicinesByDate();
  }

  void onViewAllTap() {
    Get.toNamed('/all-visits');
  }

  void onViewTimelineTap() {
    Get.dialog(
      AlertDialog(
        title: const Text('Timeline'),
        content: const Text(
            'Timeline view will show your medical history chronologically.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void onReviewMedTap() {
    Get.dialog(
      AlertDialog(
        title: const Text('Review Medication'),
        content: const Text(
            'This will help you review your current medications and check for interactions.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> getMedicines() async {
    print('🔍 getMedicines called');
    final result =
        await safeApiCall(() => _medicineRepository.getMedicinesList());

    print('📦 API Result: ${result?.length ?? 0} medicines');
    if (result != null) {
      allMedicinesList.value = result;
      print('✅ allMedicinesList updated: ${allMedicinesList.length} medicines');
      filterMedicinesByDate();
    } else {
      print('❌ API returned null');
    }
  }

  void filterMedicinesByDate() {
    print('🔍 filterMedicinesByDate called');
    print('📅 Selected date: ${selectedDate.value}');
    print('📦 allMedicinesList count: ${allMedicinesList.length}');

    if (allMedicinesList.isEmpty) {
      print('⚠️ allMedicinesList is empty, setting medicinesList to empty');
      medicinesList.value = [];
      return;
    }

    if (selectedDate.value.isEmpty) {
      medicinesList.value = allMedicinesList;
      print('✅ No filter: showing all medicines (${medicinesList.length})');
      return;
    }

    try {
      final parts = selectedDate.value.split('-');
      final selectedDateTime = DateTime(
          int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

      print('📅 Filtering for date: ${selectedDateTime.toString()}');

      final filtered = allMedicinesList.where((medicine) {
        try {
          final updatedAt = DateTime.parse(medicine.updatedAt);
          print(
              '  Medicine: ${medicine.medicineName}, updatedAt: ${updatedAt.toString()}');
          final matches = updatedAt.year == selectedDateTime.year &&
              updatedAt.month == selectedDateTime.month &&
              updatedAt.day == selectedDateTime.day;
          print('    Matches: $matches');
          return matches;
        } catch (e) {
          print('  ❌ Error parsing date for ${medicine.medicineName}: $e');
          return false;
        }
      }).toList();

      medicinesList.value = filtered;
      print('✅ Filtered medicinesList count: ${medicinesList.length}');
    } catch (e) {
      print('❌ Error in filterMedicinesByDate: $e');
      medicinesList.value = allMedicinesList;
      print('⚠️ Fallback: showing all medicines (${medicinesList.length})');
    }
  }

  Future<void> getVisits() async {
    final result = await safeApiCall(() => _visitsRepository.getVisitsList());

    if (result != null) {
      visitsList.value = result;
    }
  }

  Future<void> showMedicineDetails(int medicineId) async {
    final medicine =
        medicinesList.firstWhereOrNull((med) => med.id == medicineId);
    if (medicine != null) {
      DetailsDialogs.showMedicineDetailsDialog(
        medicine,
        onEdit: editMedicine,
        onImagePreview: DetailsDialogs.showImagePreview,
      );
    }
  }

  Future<void> editMedicine(int medicineId) async {
    print('message id is ${medicineId}');
    final medicine =
        medicinesList.firstWhereOrNull((med) => med.id == medicineId);
    if (medicine != null) {
      print('📸 Medicine attachment: ${medicine.attachment}');
      Get.to(
          () => EditMedicineView(
                isOndashboard: false,
                medicineId: medicineId,
              ),
          arguments: {'medicine': medicine});
    }
  }

  Future<void> showVisitDetails(int visitId) async {
    final result =
        await safeApiCall(() => _visitsRepository.getVisitDetails(visitId));
    if (result != null) {
      DetailsDialogs.showVisitDetailsDialog(
        result.data,
        onEdit: editVisit,
        onImagePreview: DetailsDialogs.showImagePreview,
      );
    }
  }

  Future<void> editVisit(int visitId) async {
    print('print visit id is $visitId');
    final visit = visitsList.firstWhereOrNull((v) => v.id == visitId);
    if (visit != null) {
      Get.to(
          () => EditVisitsView(
                isOndashboard: false,
                visitId: visitId,
              ),
          arguments: {'visit': visit});
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      getMedicines(),
      getVisits(),
    ]);
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      CustomSnackbar.show('Please enter name', isSuccess: false);
      return;
    }

    if (emailController.text.trim().isEmpty) {
      CustomSnackbar.show('Please enter email', isSuccess: false);
      return;
    }

    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      CustomSnackbar.show('Passwords do not match', isSuccess: false);
      return;
    }

    setLoading(true);
    final result = await safeApiCall(() => _profileRepository.updateProfile(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.isNotEmpty
              ? passwordController.text
              : null,
          passwordConfirmation: confirmPasswordController.text.isNotEmpty
              ? confirmPasswordController.text
              : null,
        ));

    if (result != null) {
      // Refresh profile data
      final profileResult =
          await safeApiCall(() => _authRepository.getProfileInfo());
      if (profileResult != null && profileResult.status) {
        Staticdata.userModel = profileResult.user;
      }

      passwordController.clear();
      confirmPasswordController.clear();
      CustomSnackbar.show('Profile updated successfully!', isSuccess: true);
    }
    setLoading(false);
  }

  Future<void> logout() async {
    final result = await safeApiCall(() => _authRepository.logout());
    //if (result != null) {
    await LocalStorageService.logout();
    Get.offAllNamed(LoginView.routeName);

    /// } else {
    print('logout api failed');
    // }
  }

  Future<void> deleteAccount() async {
    try {
      setLoading(true);
      // TODO: Call delete account API when endpoint is available
      // final result = await safeApiCall(() => _authRepository.deleteAccount());
      // if (result != null) {
      //   await LocalStorageService.logout();
      //   Get.offAllNamed(LoginView.routeName);
      // }

      // For now, show a message that this feature will be available soon
      Get.snackbar(
        'Coming Soon',
        'Account deletion feature will be available soon.',
        snackPosition: SnackPosition.BOTTOM,
      );
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('Delete account error: $e');
    }
  }

  // ==========================================
  // All Medicines Screen Methods
  // ==========================================

  /// Fetch a specific page of medicines for the All Medicines screen
  Future<void> getAllMedicinesPage(int page) async {
    allMedLoading.value = true;
    try {
      final result =
          await safeApiCall(() => _medicineRepository.getMedicinesPage(page));
      if (result != null) {
        allMedPageList.value = result.medicines;
        allMedCurrentPage.value = result.currentPage;
        allMedLastPage.value = result.lastPage;
        allMedTotal.value = result.total;
      }
    } finally {
      allMedLoading.value = false;
    }
  }

  /// Date picker for All Medicines screen
  void onAllMedDatePickerTap() async {
    DateTime initialDate;
    try {
      if (allMedSelectedDate.value.isEmpty) {
        initialDate = DateTime.now();
      } else {
        final parts = allMedSelectedDate.value.split('-');
        initialDate = DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      allMedSelectedDate.value =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  /// Clear date filter for All Medicines screen
  void clearAllMedDateFilter() {
    allMedSelectedDate.value = '';
    // Reload unfiltered data
    getAllMedicinesPage(allMedCurrentPage.value);
  }

  /// Get filtered list for display (used in UI)
  List<Medicine> get filteredAllMedList {
    if (allMedSelectedDate.value.isEmpty) return allMedPageList;

    try {
      final parts = allMedSelectedDate.value.split('-');
      final selectedDateTime = DateTime(
          int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

      return allMedPageList.where((medicine) {
        try {
          final updatedAt = DateTime.parse(medicine.updatedAt);
          return updatedAt.year == selectedDateTime.year &&
              updatedAt.month == selectedDateTime.month &&
              updatedAt.day == selectedDateTime.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } catch (e) {
      return allMedPageList;
    }
  }

  /// Show medicine details from All Medicines screen
  Future<void> showAllMedicineDetails(int medicineId) async {
    final medicine =
        allMedPageList.firstWhereOrNull((med) => med.id == medicineId);
    if (medicine != null) {
      DetailsDialogs.showMedicineDetailsDialog(
        medicine,
        onEdit: editAllMedicine,
        onImagePreview: DetailsDialogs.showImagePreview,
      );
    }
  }

  /// Edit medicine from All Medicines screen
  Future<void> editAllMedicine(int medicineId) async {
    final medicine =
        allMedPageList.firstWhereOrNull((med) => med.id == medicineId);
    if (medicine != null) {
      Get.to(
          () => EditMedicineView(
                isOndashboard: false,
                medicineId: medicineId,
              ),
          arguments: {'medicine': medicine});
    }
  }

  /// Navigate to All Medicines screen
  void onViewAllMedicinesTap() {
    Get.toNamed(AppRoutes.allMedicinesView);
  }

  // ==========================================
  // All Visits Screen Methods
  // ==========================================

  /// Fetch a specific page of visits for the All Visits screen
  Future<void> getAllVisitsPage(int page) async {
    allVisitsLoading.value = true;
    try {
      final result =
          await safeApiCall(() => _visitsRepository.getVisitsPage(page));
      if (result != null) {
        allVisitsPageList.value = result.visits;
        allVisitsCurrentPage.value = result.data.currentPage;
        allVisitsLastPage.value = result.data.lastPage;
        allVisitsTotal.value = result.data.total;
      }
    } finally {
      allVisitsLoading.value = false;
    }
  }

  /// Date picker for All Visits screen
  void onAllVisitsDatePickerTap() async {
    DateTime initialDate;
    try {
      if (allVisitsSelectedDate.value.isEmpty) {
        initialDate = DateTime.now();
      } else {
        final parts = allVisitsSelectedDate.value.split('-');
        initialDate = DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      allVisitsSelectedDate.value =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  /// Clear date filter for All Visits screen
  void clearAllVisitsDateFilter() {
    allVisitsSelectedDate.value = '';
    getAllVisitsPage(allVisitsCurrentPage.value);
  }

  /// Get filtered list for display (used in UI)
  List<VisitModel> get filteredAllVisitsList {
    if (allVisitsSelectedDate.value.isEmpty) return allVisitsPageList;

    try {
      final parts = allVisitsSelectedDate.value.split('-');
      final selectedDateTime = DateTime(
          int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

      return allVisitsPageList.where((visit) {
        try {
          final visitDate = DateTime.parse(visit.visitDate);
          return visitDate.year == selectedDateTime.year &&
              visitDate.month == selectedDateTime.month &&
              visitDate.day == selectedDateTime.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } catch (e) {
      return allVisitsPageList;
    }
  }

  /// Show visit details from All Visits screen
  Future<void> showAllVisitDetails(int visitId) async {
    final result =
        await safeApiCall(() => _visitsRepository.getVisitDetails(visitId));
    if (result != null) {
      DetailsDialogs.showVisitDetailsDialog(
        result.data,
        onEdit: editAllVisit,
        onImagePreview: DetailsDialogs.showImagePreview,
      );
    }
  }

  /// Edit visit from All Visits screen
  Future<void> editAllVisit(int visitId) async {
    final visit = allVisitsPageList.firstWhereOrNull((v) => v.id == visitId);
    if (visit != null) {
      Get.to(
          () => EditVisitsView(
                isOndashboard: false,
                visitId: visitId,
              ),
          arguments: {'visit': visit});
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
