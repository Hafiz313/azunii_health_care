import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/visit_model.dart';
import '../models/visit_responce.dart';
import '../models/Auth_model.dart';

class VisitsRepository {
  // Store Patient Visit
  Future<Map<String, dynamic>> storeVisit(
      StoreVisitRequest visitRequest) async {
    try {
      final fields = {
        'provider_name': visitRequest.providerName,
        'specialty': visitRequest.specialty,
        'visit_date': visitRequest.visitDate,
        'notes': visitRequest.notes,
      };

      final response = await ApiClient.postMultipartWithAuth(
        Apis.storePatientVisit,
        fields: fields,
        file: visitRequest.attachment,
        fileFieldName: 'attachment',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Patient Visits
  Future<VisitResponse> getVisits() async {
    try {
      print('\n📋 GET VISITS Request 📋');
      final response = await ApiClient.getWithAuth(Apis.getPatientVisits);
      print('📄 Visits Response: ${response.length} visits retrieved\n');
      return VisitResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Visits Error: $e');
      rethrow;
    }
  }

  // Get Visit Details
  Future<VisitDetailResponse> getVisitDetails(int visitId) async {
    try {
      print('\n📋 GET VISIT DETAILS Request 📋');
      print('🆔 Visit ID: $visitId');
      final response =
          await ApiClient.getWithAuth('${Apis.getVisitDetails}/$visitId');
      print('📄 Visit Detail Response: Retrieved details for visit $visitId\n');
      return VisitDetailResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Visit Details Error: $e');
      rethrow;
    }
  }

  // Update Patient Visit
  Future<Map<String, dynamic>> updateVisit(UpdateVisitRequest request) async {
    try {
      print('\n📝 UPDATE VISIT Request 📝');
      print('🆔 Visit ID: ${request.id}');
      print('🏥 Provider: ${request.providerName}');

      final jsonData = request.toJson();
      final fields = <String, String>{};

      // Separate string fields from file
      jsonData.forEach((key, value) {
        if (value is String) {
          fields[key] = value;
        }
      });

      final response = await ApiClient.postMultipartWithAuth(
        '${Apis.updatePatientVisit}/${request.id}',
        fields: fields,
        file: request.attachment,
        fileFieldName: 'attachment',
      );

      print('✅ Visit updated successfully for ID: ${request.id}\n');
      return response;
    } catch (e) {
      print('❌ Update Visit Error: $e');
      rethrow;
    }
  }

  // Delete Patient Visit
  // Future<Map<String, dynamic>> deleteVisit(int visitId) async {
  //   try {
  //     final response =
  //         await ApiClient.delete('${Apis.updatePatientVisit}/$visitId');
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
