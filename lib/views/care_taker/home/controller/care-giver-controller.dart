import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/localStorage/storage_service.dart';
import '../../../../utils/localStorage/storage_consts.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/caregiver_state.dart';
import '../../../../core/repositories/caregiver_dashboard.dart';
import '../../../../core/models/caregiver_patients_model.dart';
import '../../../../core/models/caregiver_dashboard_model.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../auth/login/login_view.dart';
import '../../Medication/controller/medication_controller.dart';
import '../../Notes/controller/notes_controller.dart';

/// CAREGIVER DASHBOARD CONTROLLER
/// Manages caregiver dashboard state and patient selection
///
/// KEY RESPONSIBILITIES:
/// - Initialize and validate active patient on load
/// - Handle patient switching
/// - Load dashboard data for selected patient
/// - Manage reactive state for UI updates
class HomeController_caregiver extends BaseController {
  final RxString selectedDateString = ''.obs;
  final RxString userName = ''.obs;
  final RxString userProfileImage = ''.obs;
  final CaregiverDashboardRepository _repository =
      CaregiverDashboardRepository();
  final CaregiverState _state = CaregiverState();

  // Dashboard data
  final Rx<CaregiverDashboardResponse?> dashboardData =
      Rx<CaregiverDashboardResponse?>(null);
  final RxList<MedicineQuery> filteredMedicines = <MedicineQuery>[].obs;

  RxList<CaregiverPatient> get patients => _state.patients;
  Rxn<CaregiverPatient> get activePatient => _state.activePatient;

  /// STEP 1: Initialize controller and load active patient
  /// Called when dashboard screen is created
  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadPatientsAndInitialize();
  }

  /// Load patients list and initialize active patient
  /// Ensures patients are available before selecting active patient
  Future<void> loadPatientsAndInitialize() async {
    // If patients list is empty, fetch from API
    if (patients.isEmpty) {
      await fetchPatients();
    }
    _initializeActivePatient();
  }

  /// Fetch patients from API
  Future<void> fetchPatients() async {
    try {
      final result = await _repository.getPatients();
      _state.setPatients(result.data);
    } catch (e) {
      print('Failed to fetch patients: $e');
    }
  }

  /// STEP 2: Initialize active patient from storage or default to first
  /// - Retrieves last selected patient from local storage
  /// - Validates against fresh patients list from API
  /// - Falls back to first patient if cached one is invalid
  /// - Loads dashboard data for the active patient
  void _initializeActivePatient() {
    print('\n🔄 Initializing active patient...');
    print('📋 Total patients available: ${patients.length}');

    final lastSelected = _state.getLastSelectedPatient();
    if (lastSelected != null) {
      print('✅ Using cached patient: ${lastSelected.patient.name}');
      _state.setActivePatient(lastSelected);
    } else if (patients.isNotEmpty) {
      print(
          '⚠️ No cached patient, using first: ${patients.first.patient.name}');
      _state.setActivePatient(patients.first);
    } else {
      print('❌ No patients available');
    }

    if (activePatient.value != null) {
      print(
          '📡 Loading dashboard for patient: ${activePatient.value!.patient.name}');
      final patientId = _state.activePatientId.value;
      if (patientId != null) {
        loadDashboardData(patientId);
      }
    }
  }

  /// STEP 3: Switch to a different patient
  /// - Updates global active patient state
  /// - Persists selection to local storage
  /// - Loads fresh dashboard data for new patient
  /// - Triggers reactive UI updates across all widgets
  /// - Directly refreshes medication and notes controllers
  void selectPatient(CaregiverPatient patient) {
    print(
        '\n🔄 Switching to patient: ${patient.patient.name} (ID: ${patient.userId})');
    _state.setActivePatient(patient);
    final patientId = _state.activePatientId.value;
    if (patientId != null) {
      loadDashboardData(patientId);

      // Directly refresh medication controller if registered
      // try {
      //   if (Get.isRegistered<MedicationController>()) {
      //     print('🔄 [HomeController] Refreshing MedicationController...');
      //     final medicationController = Get.find<MedicationController>();
      //     medicationController.getMedications();
      //   } else {
      //     print('⚠️ [HomeController] MedicationController not registered');
      //   }
      // } catch (e) {
      //   print('❌ [HomeController] Error refreshing MedicationController: $e');
      // }

      // // Directly refresh notes controller if registered
      // try {
      //   if (Get.isRegistered<NotesController>()) {
      //     print('🔄 [HomeController] Refreshing NotesController...');
      //     final notesController = Get.find<NotesController>();
      //     notesController.fetchNotes();
      //   } else {
      //     print('⚠️ [HomeController] NotesController not registered');
      //   }
      // } catch (e) {
      //   print('❌ [HomeController] Error refreshing NotesController: $e');
      // }
    }
  }

  /// STEP 4: Load dashboard data for specific patient
  /// - Calls dashboard API with patient ID (int)
  /// - Updates dashboard widgets (visits, medications)
  /// - Handles loading states via BaseController
  Future<void> loadDashboardData(int patientId) async {
    try {
      setLoading(true);
      final result = await _repository.getDashboard(patientId);
      dashboardData.value = result;
      filterMedicinesByDate();
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('❌ Dashboard load error: $e');
    }
  }

  void filterMedicinesByDate() {
    final dashboard = dashboardData.value;
    if (dashboard == null) {
      filteredMedicines.value = [];
      return;
    }

    if (selectedDateString.value.isEmpty) {
      filteredMedicines.value = dashboard.medicineQueries;
      return;
    }

    final selected = DateTime.parse(selectedDateString.value);
    filteredMedicines.value = dashboard.medicineQueries.where((medicine) {
      try {
        // Parse start date
        if (medicine.startDate == null || medicine.startDate!.isEmpty) {
          return false; // Skip if no start date
        }

        final startDate = DateTime.parse(medicine.startDate!);

        // If medication has an end date
        if (medicine.endDate != null && medicine.endDate!.isNotEmpty) {
          final endDate = DateTime.parse(medicine.endDate!);

          // Check if selected date is between start and end date (inclusive)
          return (selected
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              selected.isBefore(endDate.add(const Duration(days: 1))));
        } else {
          // If no end date, medication is ongoing - check if selected date is on or after start date
          return selected.isAfter(startDate.subtract(const Duration(days: 1)));
        }
      } catch (e) {
        print('Error filtering medication: $e');
        return false;
      }
    }).toList();
  }

  void loadUserData() {
    // Static data - no storage needed
    userName.value = 'Dr. Sarah Wilson';
    userProfileImage.value = '';
  }

  void updateDate(String date) {
    selectedDateString.value = DateTime.now().toString().split(' ')[0];
  }

  Future<void> onDatePickerTap() async {
    final initialDate = selectedDateString.value.isNotEmpty
        ? DateTime.parse(selectedDateString.value)
        : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      selectedDateString.value = picked.toString().split(' ')[0];
      filterMedicinesByDate();
    }
  }

  void clearDateFilter() {
    selectedDateString.value = '';
    filterMedicinesByDate();
  }

  void onViewAllTap() {
    Get.toNamed('/caregiver-all-visits');
  }

  void showMedicineDetails(int medicineId) {
    final dashboard = dashboardData.value;
    if (dashboard == null) return;

    final medicine =
        dashboard.medicineQueries.firstWhereOrNull((m) => m.id == medicineId);
    if (medicine != null) {
      _showCaregiverMedicineDialog(medicine);
    }
  }

  void showVisitDetails(int visitId) {
    final dashboard = dashboardData.value;
    if (dashboard == null) return;

    final visit =
        dashboard.upcomingVisits.firstWhereOrNull((v) => v.id == visitId);
    if (visit != null) {
      _showCaregiverVisitDialog(visit);
    }
  }

  void _showCaregiverMedicineDialog(MedicineQuery medicine) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
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
                    const Text(
                      'Medicine Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Color(0xFF6B6B6B)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Name', medicine.medicineName),
                _buildDetailRow('Dosage', medicine.dosage),
                _buildDetailRow('Status', medicine.status),
                if (medicine.startDate != null &&
                    medicine.startDate!.isNotEmpty)
                  _buildDetailRow(
                      'Start Date', _formatDate(medicine.startDate!)),
                if (medicine.endDate != null && medicine.endDate!.isNotEmpty)
                  _buildDetailRow('End Date', _formatDate(medicine.endDate!))
                else
                  _buildDetailRow('End Date', 'Ongoing'),
                if (medicine.interactionMessage != null)
                  _buildDetailRow('Interaction', medicine.interactionMessage!),
                if (medicine.frequencies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Frequencies:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...medicine.frequencies.map((freq) {
                    if (freq.frequency.toLowerCase() == 'as_per_needed') {
                      return _buildDetailRow('Frequency', 'As per needed');
                    }
                    return _buildDetailRow(
                      freq.frequency[0].toUpperCase() +
                          freq.frequency.substring(1),
                      _formatTime(freq.time),
                    );
                  }),
                ],
                if (medicine.attachment != null &&
                    medicine.attachment!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Attachment:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showImagePreview(medicine.attachment!),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          medicine.attachment!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF5F5F5),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Color(0xFF9E9E9E),
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to preview',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCaregiverVisitDialog(UpcomingVisit visit) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
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
                    const Text(
                      'Visit Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Color(0xFF6B6B6B)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Provider', visit.providerName),
                _buildDetailRow('Specialty', visit.specialty),
                _buildDetailRow('Visit Date', _formatDate(visit.visitDate)),
                _buildDetailRow('Notes', visit.notes),
                if (visit.createdBy.name.isNotEmpty)
                  _buildDetailRow('Created By', visit.createdBy.name),
                if (visit.updatedBy.name.isNotEmpty)
                  _buildDetailRow('Updated By', visit.updatedBy.name),
                _buildDetailRow('Created At', _formatDate(visit.createdAt)),
                _buildDetailRow('Updated At', _formatDate(visit.updatedAt)),
                if (visit.attachment != null &&
                    visit.attachment!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Attachment:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showImagePreview(visit.attachment!),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          visit.attachment!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF5F5F5),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Color(0xFF9E9E9E),
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to preview',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1C1C1E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.9),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 60,
                                    color: Colors.white54,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Failed to load',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  /// Logout and clear patient state
  /// - Clears active patient from global state
  /// - Removes all local storage data
  /// - Navigates to login screen
  Future<void> logout() async {
    try {
      _state.clearActivePatient();
      StorageService().removeData('isLoggedIn');
      StorageService().removeData('userType');
      Get.offAllNamed(LoginView.routeName);
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
