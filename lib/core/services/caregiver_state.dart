import 'package:get/get.dart';
import 'dart:convert';
import '../models/caregiver_patients_model.dart';
import '../../utils/localStorage/storage_service.dart';

/// GLOBAL STATE MANAGER FOR CAREGIVER PATIENTS
/// Singleton pattern to manage patient list and active patient selection
/// 
/// RESPONSIBILITIES:
/// - Store list of all assigned patients
/// - Manage currently active patient
/// - Persist active patient selection to local storage
/// - Provide validation for cached patient selection
class CaregiverState {
  static final CaregiverState _instance = CaregiverState._internal();
  factory CaregiverState() => _instance;
  CaregiverState._internal();

  final RxList<CaregiverPatient> patients = <CaregiverPatient>[].obs;
  final Rxn<CaregiverPatient> activePatient = Rxn<CaregiverPatient>();
  final RxnInt activePatientId = RxnInt();

  static const String _activePatientKey = 'active_patient_id';

  /// Store the list of patients fetched from API
  /// Called after successful login
  void setPatients(List<CaregiverPatient> patientList) {
    patients.value = patientList;
  }

  /// Set active patient and persist to storage
  /// Called when user selects a patient from the list
  void setActivePatient(CaregiverPatient patient) {
    activePatient.value = patient;
    activePatientId.value = int.parse(patient.userId);
    print('💾 Saving patient ID to storage: ${patient.patient.id}');
    StorageService().saveData(_activePatientKey, patient.patient.id);
    print('✅ Patient ID saved successfully');
  }

  /// Retrieve last selected patient from storage
  /// Validates against current patients list
  /// Returns null if not found or invalid
  CaregiverPatient? getLastSelectedPatient() {
    final savedId = StorageService().getData(_activePatientKey);
    print('🔍 Retrieving saved patient ID: $savedId');
    print('📋 Available patients: ${patients.map((p) => '${p.patient.name}(${p.patient.id})').toList()}');
    
    if (savedId != null && patients.isNotEmpty) {
      final found = patients.firstWhereOrNull((p) => p.patient.id == savedId);
      if (found != null) {
        print('✅ Found matching patient: ${found.patient.name}');
      } else {
        print('❌ No matching patient found for ID: $savedId');
      }
      return found;
    }
    print('⚠️ No saved ID or patients list is empty');
    return null;
  }

  /// Clear active patient on logout
  /// Removes from memory and local storage
  void clearActivePatient() {
    activePatient.value = null;
    activePatientId.value = null;
    StorageService().removeData(_activePatientKey);
  }
}
