import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/repositories/auth_repository.dart';
import 'package:Azunii_Health/core/repositories/Medicine_repo.dart';
import 'package:Azunii_Health/core/repositories/visits_repo.dart';
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

import '../../../auth/login/login_view.dart';
import '../../medicines/medicines_view.dart';
import '../../visits/visits_view.dart';

class HomeController extends BaseController {
  final RxString selectedDate =
      '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}'
          .obs;
  final RxString userName = ''.obs;
  final RxString userProfileImage = ''.obs;
  final RxList<Medicine> medicinesList = <Medicine>[].obs;
  final RxList<VisitModel> visitsList = <VisitModel>[].obs;
  final AuthRepository _authRepository = AuthRepository();
  final MedicineRepository _medicineRepository = MedicineRepository();
  final VisitsRepository _visitsRepository = VisitsRepository();

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

  void onDatePickerTap() {
    DateTime initialDate;
    try {
      final parts = selectedDate.value.split('-');
      initialDate = DateTime(
          int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (e) {
      initialDate = DateTime.now();
    }

    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingTextColor,
                ),
              ),
              Expanded(
                child: Theme(
                  data: Theme.of(Get.context!).copyWith(
                    colorScheme: Theme.of(Get.context!).colorScheme.copyWith(
                          primary: Colors.blue,
                          onPrimary: const Color.fromARGB(255, 31, 30, 30),
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: (DateTime date) {
                      selectedDate.value =
                          '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final result =
        await safeApiCall(() => _medicineRepository.getMedicinesList());

    if (result != null) {
      medicinesList.value = result;
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

  Future<void> logout() async {
    final result = await safeApiCall(() => _authRepository.logout());
    if (result != null) {
      await LocalStorageService.logout();
      Get.offAllNamed(LoginView.routeName);
    } else {
      print('logout api failed');
    }
  }
}
