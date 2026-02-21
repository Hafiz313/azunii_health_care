import 'dart:convert';
import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/Medicine_model.dart';

class MedicineRepository {
  // Get Patient Medicines (with optional page parameter)
  Future<MedicineListResponse> getMedicines({int page = 1}) async {
    try {
      print('\n💊 GET MEDICINES Request 💊 (page: $page)');
      final endpoint = '${Apis.getPatientMedicines}?page=$page';
      final response = await ApiClient.getWithAuth(endpoint);
      print('📄 Medicines Response: Retrieved patient medicines (page: $page)\n');
      return MedicineListResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Medicines Error: $e');
      rethrow;
    }
  }

  // Get Medicines List Only (first page)
  Future<List<Medicine>> getMedicinesList() async {
    try {
      final medicineResponse = await getMedicines();
      return medicineResponse.medicines;
    } catch (e) {
      print('❌ Get Medicines List Error: $e');
      rethrow;
    }
  }

  // Get Medicines Page with full pagination response
  Future<MedicineListResponse> getMedicinesPage(int page) async {
    try {
      return await getMedicines(page: page);
    } catch (e) {
      print('❌ Get Medicines Page Error: $e');
      rethrow;
    }
  }

  // Store Patient Medicine with start_date and end_date
  Future<Map<String, dynamic>> storeMedicine(
      StoreMedicineRequest medicineRequest) async {
    try {
      print('\n💾 STORE MEDICINE Request 💾');
      print('💊 Medicine: ${medicineRequest.medicineName}');
      print('📏 Dosage: ${medicineRequest.dosage}');
      print('📅 Start Date: ${medicineRequest.startDate}');
      print('📅 End Date: ${medicineRequest.endDate ?? "Not provided"}');

      final fields = <String, String>{};

      // Add basic fields
      fields['medicine_name'] = medicineRequest.medicineName;
      fields['dosage'] = medicineRequest.dosage;
      fields['status'] = medicineRequest.status;
      fields['start_date'] = medicineRequest.startDate;
      if (medicineRequest.endDate != null && medicineRequest.endDate!.isNotEmpty) {
        fields['end_date'] = medicineRequest.endDate!;
      }

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

  // Update Patient Medicine with start_date and end_date
  Future<Map<String, dynamic>> updateMedicine(
      UpdateMedicineRequest medicineRequest, int medicineId) async {
    try {
      final updateUrl = '${Apis.updatePatientMedicine}';
      print('\n📝 UPDATE MEDICINE Request 📝');
      print('🆔 Medicine ID: $medicineId');
      print('🔗 Update URL: $updateUrl');
      print('🔗 Full URL: ${Apis.baseUrl}$updateUrl');
      print('💊 Medicine: ${medicineRequest.medicineName}');
      print('📅 Start Date: ${medicineRequest.startDate}');
      print('📅 End Date: ${medicineRequest.endDate ?? "Not provided"}');

      final fields = <String, String>{};

      fields['id'] = medicineId.toString();
      fields['medicine_name'] = medicineRequest.medicineName;
      fields['dosage'] = medicineRequest.dosage;
      fields['status'] = medicineRequest.status;
      fields['start_date'] = medicineRequest.startDate;
      if (medicineRequest.endDate != null && medicineRequest.endDate!.isNotEmpty) {
        fields['end_date'] = medicineRequest.endDate!;
      }

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
