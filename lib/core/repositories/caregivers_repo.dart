import 'package:flutter/material.dart';

import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/care_givermodel.dart';

class CaregiversRepository {
  // Store Caregiver
  Future<Map<String, dynamic>> storeCaregivers(
      Map<String, dynamic> caregiverData) async {
    try {
      debugPrint('\n💾 STORE CAREGIVER Request 💾');
      debugPrint('📧 Email: ${caregiverData['email']}');
      debugPrint('👤 Full Name: ${caregiverData['full_name']}');
      final response = await ApiClient.postWithAuth(Apis.storeCaregivers,
          body: caregiverData);
      debugPrint('✅ Caregiver stored successfully\n');
      return response;
    } catch (e) {
      debugPrint('❌ Store Caregiver Error: $e');
      rethrow;
    }
  }

  // Get Caregivers
  Future<CaregiverListResponse> getCaregivers() async {
    try {
      debugPrint('\n📋 GET CAREGIVERS Request 📋');
      final response = await ApiClient.getWithAuth(Apis.getCaregivers);
      debugPrint('📄 Caregivers Response: Retrieved caregivers list\n');
      return CaregiverListResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Caregivers Error: $e');
      rethrow;
    }
  }

  // Get Caregiver Detail
  Future<CaregiverDetailResponse> getCaregiverDetail(int id) async {
    try {
      debugPrint('\n📋 GET CAREGIVER DETAIL Request 📋');
      debugPrint('🆔 Caregiver ID: $id');
      final response =
          await ApiClient.getWithAuth('${Apis.caregiversDetail}/$id');
      debugPrint(
          '📄 Caregiver Detail Response: Retrieved details for caregiver $id\n');
      return CaregiverDetailResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Caregiver Detail Error: $e');
      rethrow;
    }
  }

  // Destroy Caregiver
  Future<Map<String, dynamic>> destroyCaregiver(int id) async {
    try {
      debugPrint('\n🗑️ DESTROY CAREGIVER Request 🗑️');
      debugPrint('🆔 Caregiver ID: $id');
      final response =
          await ApiClient.deleteWithAuth('${Apis.caregiversDestroy}/$id');
      debugPrint('✅ Caregiver destroyed successfully for ID: $id\n');
      return response;
    } catch (e) {
      debugPrint('❌ Destroy Caregiver Error: $e');
      rethrow;
    }
  }

  // Update Caregiver Access
  Future<Map<String, dynamic>> updateCaregiverAccess({
    required int caregiverId,
    required int canView,
    required int canAddNotes,
  }) async {
    try {
      debugPrint('\n🔄 UPDATE CAREGIVER ACCESS Request 🔄');
      debugPrint('🆔 Caregiver ID: $caregiverId');
      debugPrint('👁️ Can View: $canView');
      debugPrint('📝 Can Add Notes: $canAddNotes');
      final response = await ApiClient.postWithAuth(Apis.updatecaregiver, body: {
        'caregiver_id': caregiverId,
        'can_view': canView,
        'can_add_notes': canAddNotes,
      });
      debugPrint('✅ Caregiver access updated successfully\n');
      return response;
    } catch (e) {
      debugPrint('❌ Update Caregiver Access Error: $e');
      rethrow;
    }
  }

  // Store Caregiver Notes
  Future<Map<String, dynamic>> caregiverNotes(
      int patientId, String category, String note) async {
    try {
      debugPrint('\n📝 STORE CAREGIVER NOTES Request 📝');
      debugPrint('🆔 Patient ID: $patientId');
      debugPrint('📂 Category: $category');
      final response =
          await ApiClient.postWithAuth(Apis.caregiversNotes, body: {
        'patient_id': patientId.toString(),
        'category': category,
        'note': note,
      });
      debugPrint('✅ Caregiver notes stored successfully\n');
      return response;
    } catch (e) {
      debugPrint('❌ Store Caregiver Notes Error: $e');
      rethrow;
    }
  }
}
