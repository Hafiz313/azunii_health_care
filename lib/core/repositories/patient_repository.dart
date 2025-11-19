import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';

class PatientRepository {
  
  // Store Patient Visit
  Future<Map<String, dynamic>> storeVisit(Map<String, dynamic> visitData) async {
    try {
      final response = await ApiClient.post(Apis.storePatientVisit, body: visitData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Patient Visits
  Future<Map<String, dynamic>> getVisits() async {
    try {
      final response = await ApiClient.get(Apis.getPatientVisits);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Visit Details
  Future<Map<String, dynamic>> getVisitDetails(int visitId) async {
    try {
      final response = await ApiClient.get('${Apis.getVisitDetails}/$visitId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update Patient Visit
  Future<Map<String, dynamic>> updateVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      final response = await ApiClient.put('${Apis.updatePatientVisit}/$visitId', body: visitData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Patient Visit
  Future<Map<String, dynamic>> deleteVisit(int visitId) async {
    try {
      final response = await ApiClient.delete('${Apis.updatePatientVisit}/$visitId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}