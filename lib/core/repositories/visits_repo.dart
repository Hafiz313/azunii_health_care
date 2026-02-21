import 'package:Azunii_Health/core/models/visit_responce.dart';
import 'package:flutter/material.dart';

import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/visit_model.dart';
import '../models/visit_responce.dart';

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

  // Get Patient Visits (with optional page parameter)
  Future<VisitResponse> getVisits({int page = 1}) async {
    try {
      debugPrint('\n📋 GET VISITS Request 📋 (page: $page)');
      final endpoint = '${Apis.getPatientVisits}?page=$page';
      final response = await ApiClient.getWithAuth(endpoint);
      debugPrint('📄 Visits Response: Retrieved patient visits (page: $page)\n');
      return VisitResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Visits Error: $e');
      rethrow;
    }
  }

  // Get Visits List Only (first page)
  Future<List<VisitModel>> getVisitsList() async {
    try {
      final visitResponse = await getVisits();
      return visitResponse.visits;
    } catch (e) {
      debugPrint('❌ Get Visits List Error: $e');
      rethrow;
    }
  }

  // Get Visits Page with full pagination response
  Future<VisitResponse> getVisitsPage(int page) async {
    try {
      return await getVisits(page: page);
    } catch (e) {
      debugPrint('❌ Get Visits Page Error: $e');
      rethrow;
    }
  }

  // Get Visit Details
  Future<VisitDetailResponse> getVisitDetails(int visitId) async {
    try {
      debugPrint('\n📋 GET VISIT DETAILS Request 📋');
      debugPrint('🆔 Visit ID: $visitId');
      final response =
          await ApiClient.getWithAuth('${Apis.getVisitDetails}/$visitId');
      debugPrint(
          '📄 Visit Detail Response: Retrieved details for visit $visitId\n');
      return VisitDetailResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Visit Details Error: $e');
      rethrow;
    }
  }

  // Update Patient Visit
  Future<Map<String, dynamic>> updateVisit(UpdateVisitRequest request) async {
    try {
      debugPrint('\n📝 UPDATE VISIT Request 📝');
      debugPrint('🆔 Visit ID: ${request.id}');
      debugPrint('🏥 Provider: ${request.providerName}');

      final fields = <String, String>{};

      fields['id'] = request.id.toString();
      fields['provider_name'] = request.providerName;
      fields['specialty'] = request.specialty;
      fields['visit_date'] = request.visitDate;
      fields['notes'] = request.notes;

      final response = await ApiClient.postMultipartWithAuth(
        '${Apis.updatePatientVisit}',
        fields: fields,
        file: request.attachment,
        fileFieldName: 'attachment',
      );

      debugPrint('✅ Visit updated successfully for ID: ${request.id}\n');
      return response;
    } catch (e) {
      debugPrint('❌ Update Visit Error: $e');
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
