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
  final CaregiverDashboardRepository _repository = CaregiverDashboardRepository();
  final CaregiverState _state = CaregiverState();

  // Dashboard data
  final Rx<CaregiverDashboardResponse?> dashboardData = Rx<CaregiverDashboardResponse?>(null);
  final RxList<MedicineQuery> filteredMedicines = <MedicineQuery>[].obs;

  RxList<CaregiverPatient> get patients => _state.patients;
  Rxn<CaregiverPatient> get activePatient => _state.activePatient;

  /// STEP 1: Initialize controller and load active patient
  /// Called when dashboard screen is created
  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _loadPatientsAndInitialize();
  }

  /// Load patients list and initialize active patient
  /// Ensures patients are available before selecting active patient
  Future<void> _loadPatientsAndInitialize() async {
    // If patients list is empty, fetch from API
    if (patients.isEmpty) {
      await _fetchPatients();
    }
    _initializeActivePatient();
  }

  /// Fetch patients from API
  Future<void> _fetchPatients() async {
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
      print('⚠️ No cached patient, using first: ${patients.first.patient.name}');
      _state.setActivePatient(patients.first);
    } else {
      print('❌ No patients available');
    }
    
    if (activePatient.value != null) {
      print('📡 Loading dashboard for patient: ${activePatient.value!.patient.name}');
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
  void selectPatient(CaregiverPatient patient) {
    print('\n🔄 Switching to patient: ${patient.patient.name} (ID: ${patient.userId})');
    _state.setActivePatient(patient);
    final patientId = _state.activePatientId.value;
    if (patientId != null) {
      loadDashboardData(patientId);
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
        final createdDate = DateTime.parse(medicine.createdAt);
        return createdDate.year == selected.year &&
               createdDate.month == selected.month &&
               createdDate.day == selected.day;
      } catch (e) {
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
