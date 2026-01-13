import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/caregiver_patients_model.dart';
import '../models/caregiver_dashboard_model.dart';

/// CAREGIVER DASHBOARD REPOSITORY
/// Handles API calls for caregiver-specific endpoints
class CaregiverDashboardRepository {
  /// Get list of all patients assigned to this caregiver
  /// API: GET /caregiver/patients
  /// Returns: List of patients with relationship and permissions
  /// Called: After caregiver login
  Future<CaregiverPatientsResponse> getPatients() async {
    try {
      print('\n👥 GET CAREGIVER PATIENTS Request 👥');
      final response = await ApiClient.getWithAuth(Apis.getPatientsCaregiver);
      print('📄 Patients Response: Retrieved caregiver patients\n');
      return CaregiverPatientsResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Caregiver Patients Error: $e');
      rethrow;
    }
  }

  /// Get dashboard data for a specific patient
  /// API: POST /caregiver/dashboard
  /// Body: {patient_id: int}
  /// Returns: Dashboard data (upcoming visits, medicine queries)
  /// Called: When patient is selected or dashboard loads
  Future<CaregiverDashboardResponse> getDashboard(int patientId) async {
    try {
      print('\n📊 GET CAREGIVER DASHBOARD Request 📊');
      print('👤 Patient ID: $patientId');
      
      final response = await ApiClient.postWithAuth(
        Apis.caregiverDashboard,
        body: {'patient_id': patientId},
      );
      
      print('📄 Dashboard Response: Retrieved caregiver dashboard\n');
      return CaregiverDashboardResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Caregiver Dashboard Error: $e');
      rethrow;
    }
  }
}
