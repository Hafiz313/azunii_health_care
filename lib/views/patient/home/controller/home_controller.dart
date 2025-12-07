import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/repositories/auth_repository.dart';
import 'package:Azunii_Health/core/repositories/Medicine_repo.dart';
import 'package:Azunii_Health/core/repositories/visits_repo.dart';
import 'package:Azunii_Health/core/models/Medicine_model.dart';
import 'package:Azunii_Health/core/models/visit_model.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/utils/snackbar_helper.dart';
import 'package:Azunii_Health/utils/DateForm.dart';
import 'package:Azunii_Health/views/patient/medicines/edit_medication.dart';
import 'package:Azunii_Health/views/patient/visits/all_visits_view.dart';
import 'package:Azunii_Health/views/patient/visits/edit_visits_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    // Static data - no storage needed
    userName.value = 'John Doe';
    userProfileImage.value = '';
  }

  // List<Map<String, dynamic>> get todayTasks => [
  //       {
  //         'backgroundColor': const Color.fromARGB(255, 181, 218, 244),
  //         'icon': FaIcon(
  //           FontAwesomeIcons.pills,
  //           color: Colors.blue[600],
  //           size: 24,
  //         ),
  //         'title': Lang.takeMedDaily,
  //         'isCompleted': true,
  //       },
  //       {
  //         'backgroundColor': AppColors.lightOrange,
  //         'icon': Container(
  //           width: 32,
  //           height: 32,
  //           decoration: BoxDecoration(
  //             color: Colors.orange[300],
  //             shape: BoxShape.circle,
  //           ),
  //           child: const Center(
  //             child: Text(
  //               'X',
  //               style: TextStyle(
  //                 color: AppColors.white,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //         'title': Lang.doNotTakeMed,
  //         'isCompleted': true,
  //       },
  //       {
  //         'backgroundColor': AppColors.lightGreenCard,
  //         'icon': FaIcon(
  //           FontAwesomeIcons.clipboardList,
  //           color: AppColors.green,
  //           size: 24,
  //         ),
  //         'title': Lang.limitedExercise,
  //         'isCompleted': true,
  //       },
  //       {
  //         'backgroundColor': AppColors.lightPurple,
  //         'icon': FaIcon(
  //           FontAwesomeIcons.clipboardList,
  //           color: Colors.purple[600],
  //           size: 24,
  //         ),
  //         'title': Lang.limitedExercise,
  //         'isCompleted': true,
  //       },
  //     ];

  void updateDate(String date) {
    selectedDate.value = date;
  }

  void onDatePickerTap() {
    // Parse current selected date
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

  /// Get Medicines
  Future<void> getMedicines() async {
    final result =
        await safeApiCall(() => _medicineRepository.getMedicinesList());

    if (result != null) {
      medicinesList.value = result;
    }
  }

  /// Get Visits
  Future<void> getVisits() async {
    final result = await safeApiCall(() => _visitsRepository.getVisitsList());

    if (result != null) {
      visitsList.value = result;
    }
  }

  /// Get Medicine Details
  Future<void> showMedicineDetails(int medicineId) async {
    final medicine =
        medicinesList.firstWhereOrNull((med) => med.id == medicineId);
    if (medicine != null) {
      _showMedicineDetailsDialog(medicine);
    }
  }

  /// Edit Medicine
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

  /// Show Visit Details
  Future<void> showVisitDetails(int visitId) async {
    final result =
        await safeApiCall(() => _visitsRepository.getVisitDetails(visitId));
    if (result != null) {
      _showVisitDetailsDialog(result.data);
    }
  }

  /// Edit Visit
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

  void _showVisitDetailsDialog(VisitModel visit) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Visit Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headingTextColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Provider', visit.providerName),
                _buildDetailRow('Specialty', visit.specialty),
                _buildDetailRow('Visit Date', formatDate(visit.visitDate)),
                _buildDetailRow('Notes', visit.notes),
                if (visit.createdBy != null)
                  _buildDetailRow('Created By', visit.createdBy!.name),
                if (visit.updatedBy != null)
                  _buildDetailRow('Updated By', visit.updatedBy!.name),
                _buildDetailRow('Created At', formatDate(visit.createdAt)),
                _buildDetailRow('Updated At', formatDate(visit.updatedAt)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          editVisit(visit.id.toInt());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(color: AppColors.white),
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

  void _showMedicineDetailsDialog(Medicine medicine) {
    print('medicine details are ${medicine.id}');
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medicine Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headingTextColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Name', medicine.medicineName),
                _buildDetailRow('Dosage', medicine.dosage),
                _buildDetailRow('Status', medicine.status),
                _buildDetailRow('Interaction Flag', medicine.interactionFlag),
                if (medicine.interactionMessage != null)
                  _buildDetailRow(
                      'Interaction Message', medicine.interactionMessage!),
                if (medicine.interactionDetails != null)
                  _buildDetailRow(
                      'Interaction Details', medicine.interactionDetails!),
                if (medicine.updatedBy != null)
                  _buildDetailRow('Updated By', medicine.updatedBy!),
                _buildDetailRow('Created At', formatDate(medicine.createdAt)),
                _buildDetailRow('Updated At', formatDate(medicine.updatedAt)),
                if (medicine.frequencies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Frequencies:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...medicine.frequencies.map((freq) =>
                      _buildDetailRow('${freq.frequency}', freq.time)),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          editMedicine(medicine.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(color: AppColors.white),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      getMedicines(),
      getVisits(),
    ]);
  }

  /// Logout functionality
  Future<void> logout() async {
    // Show loader for 1 second instead of API call

    // Commented out API call for testing
    final result = await safeApiCall(() => _authRepository.logout());
    if (result != null) {
      await LocalStorageService.logout();
      Get.offAllNamed(LoginView.routeName);
      // SnackbarHelper.showSuccess('Logged out successfully');
    } else {
      print('logout api failed');
    }
  }
}
