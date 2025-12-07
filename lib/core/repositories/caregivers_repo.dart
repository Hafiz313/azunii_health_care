import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/care_givermodel.dart';

class CaregiversRepository {
  // Store Caregiver
  Future<Map<String, dynamic>> storeCaregivers(Caregiver caregiver) async {
    try {
      print('\n💾 STORE CAREGIVER Request 💾');
      print('📧 Email: ${caregiver.email}');
      print('👤 Full Name: ${caregiver.fullName}');
      final response = await ApiClient.postWithAuth(Apis.storeCaregivers, body: caregiver.toJson());
      print('✅ Caregiver stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Caregiver Error: $e');
      rethrow;
    }
  }

  // Get Caregivers
  Future<List<Caregiver>> getCaregivers() async {
    try {
      print('\n📋 GET CAREGIVERS Request 📋');
      final response = await ApiClient.getWithAuth(Apis.getCaregivers);
      print('📄 Caregivers Response: Retrieved caregivers list\n');
      final caregiverResponse = CaregiverListResponse.fromJson(response);
      return caregiverResponse.caregivers;
    } catch (e) {
      print('❌ Get Caregivers Error: $e');
      rethrow;
    }
  }

  // Get Caregiver Detail
  Future<Map<String, dynamic>> getCaregiverDetail(int id) async {
    try {
      print('\n📋 GET CAREGIVER DETAIL Request 📋');
      print('🆔 Caregiver ID: $id');
      final response = await ApiClient.getWithAuth('${Apis.caregiversDetail}/$id');
      print('📄 Caregiver Detail Response: Retrieved details for caregiver $id\n');
      return response;
    } catch (e) {
      print('❌ Get Caregiver Detail Error: $e');
      rethrow;
    }
  }

  // Destroy Caregiver
  Future<Map<String, dynamic>> destroyCaregiver(int id) async {
    try {
      print('\n🗑️ DESTROY CAREGIVER Request 🗑️');
      print('🆔 Caregiver ID: $id');
      final response = await ApiClient.deleteWithAuth('${Apis.caregiversDestroy}/$id');
      print('✅ Caregiver destroyed successfully for ID: $id\n');
      return response;
    } catch (e) {
      print('❌ Destroy Caregiver Error: $e');
      rethrow;
    }
  }

  // Store Caregiver Notes
  Future<Map<String, dynamic>> caregiverNotes(int patientId, String category, String note) async {
    try {
      print('\n📝 STORE CAREGIVER NOTES Request 📝');
      print('🆔 Patient ID: $patientId');
      print('📂 Category: $category');
      final response = await ApiClient.postWithAuth(Apis.caregiversNotes, body: {
        'patient_id': patientId.toString(),
        'category': category,
        'note': note,
      });
      print('✅ Caregiver notes stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Caregiver Notes Error: $e');
      rethrow;
    }
  }
}
