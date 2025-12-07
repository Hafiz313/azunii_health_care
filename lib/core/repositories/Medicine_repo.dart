import 'dart:convert';
import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/Medicine_model.dart';

class MedicineRepository {
  // Get Patient Medicines
  Future<MedicineListResponse> getMedicines() async {
    try {
      print('\n💊 GET MEDICINES Request 💊');
      final response = await ApiClient.getWithAuth(Apis.getPatientMedicines);
      print('📄 Medicines Response: Retrieved patient medicines\n');
      return MedicineListResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Medicines Error: $e');
      rethrow;
    }
  }

  // Get Medicines List Only
  Future<List<Medicine>> getMedicinesList() async {
    try {
      final medicineResponse = await getMedicines();
      return medicineResponse.medicines;
    } catch (e) {
      print('❌ Get Medicines List Error: $e');
      rethrow;
    }
  }

  // Store Patient Medicine
  Future<Map<String, dynamic>> storeMedicine(
      StoreMedicineRequest medicineRequest) async {
    try {
      print('\n💾 STORE MEDICINE Request 💾');
      print('💊 Medicine: ${medicineRequest.medicineName}');
      print('📏 Dosage: ${medicineRequest.dosage}');

      final fields = <String, String>{};

      // Add basic fields
      fields['medicine_name'] = medicineRequest.medicineName;
      fields['dosage'] = medicineRequest.dosage;
      fields['status'] = medicineRequest.status;

      // Add frequencies in the format: frequencies[0][frequency], frequencies[0][time]
      for (int i = 0; i < medicineRequest.frequencies.length; i++) {
        fields['frequencies[$i][frequency]'] =
            medicineRequest.frequencies[i].frequency;
        fields['frequencies[$i][time]'] = medicineRequest.frequencies[i].time;
      }

      final response = await ApiClient.postMultipartWithAuth(
        Apis.storePatientMedicine,
        fields: fields,
        file: medicineRequest.attachment,
        fileFieldName: 'attachment',
      );

      print('✅ Medicine stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Medicine Error: $e');
      rethrow;
    }
  }

  // Get Medicine Details
  Future<Map<String, dynamic>> getMedicineDetails(int medicineId) async {
    try {
      print('\n📋 GET MEDICINE DETAILS Request 📋');
      print('🆔 Medicine ID: $medicineId');
      final response =
          await ApiClient.getWithAuth('${Apis.getMedicineDetails}/$medicineId');
      print(
          '📄 Medicine Detail Response: Retrieved details for medicine $medicineId\n');
      return response;
    } catch (e) {
      print('❌ Get Medicine Details Error: $e');
      rethrow;
    }
  }

  // Update Patient Medicine
  Future<Map<String, dynamic>> updateMedicine(
      UpdateMedicineRequest medicineRequest, int medicineId) async {
    try {
      final updateUrl = '${Apis.updatePatientMedicine}';
      print('\n📝 UPDATE MEDICINE Request 📝');
      print('🆔 Medicine ID: $medicineId');
      print('🔗 Update URL: $updateUrl');
      print('🔗 Full URL: ${Apis.baseUrl}$updateUrl');
      print('💊 Medicine: ${medicineRequest.medicineName}');

      final fields = <String, String>{};

      // Add method override for Laravel

      fields['id'] = medicineId.toString();
      fields['medicine_name'] = medicineRequest.medicineName;
      fields['dosage'] = medicineRequest.dosage;
      fields['status'] = medicineRequest.status;

      // Add frequencies in the format: frequencies[0][frequency], frequencies[0][time]
      for (int i = 0; i < medicineRequest.frequencies.length; i++) {
        fields['frequencies[$i][frequency]'] =
            medicineRequest.frequencies[i].frequency;
        fields['frequencies[$i][time]'] = medicineRequest.frequencies[i].time;
      }

      final response = await ApiClient.postMultipartWithAuth(
        updateUrl,
        fields: fields,
        file: medicineRequest.attachment,
        fileFieldName: 'attachment',
      );

      print('✅ Medicine updated successfully for ID: $medicineId\n');
      return response;
    } catch (e) {
      print('❌ Update Medicine Error: $e');
      rethrow;
    }
  }
}
