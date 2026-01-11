import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/caregiver_medicine_model.dart';
import '../models/caregiver_medicine_list_model.dart';
import '../../utils/localStorage/storage_service.dart';
import '../../utils/localStorage/storage_consts.dart';

class CaregiverMedicineRepository {
  // Get Caregiver Medicines
  Future<CaregiverMedicineListResponse> getMedicines() async {
    try {
      print('\n💊 GET CAREGIVER MEDICINES Request 💊');
      final response = await ApiClient.getWithAuth(Apis.getMedicineCaregiver);
      print('📄 Medicines Response: Retrieved caregiver medicines\n');
      return CaregiverMedicineListResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Caregiver Medicines Error: $e');
      rethrow;
    }
  }

  // Get Caregiver Medicines List (New API Response)
  Future<CaregiverMedicineListApiResponse> getMedicinesList() async {
    try {
      print('\n💊 GET CAREGIVER MEDICINES LIST Request 💊');
      
      final patientId = StorageService().getData(StorageConsts.kUserId);
      if (patientId == null) {
        throw Exception('Patient ID not found in storage');
      }
      
      final response = await ApiClient.postWithAuth(
        Apis.getMedicineCaregiver,
        body: {'patient_id': patientId.toString()},
      );
      
      print('📄 Medicines List Response: Retrieved caregiver medicines\n');
      return CaregiverMedicineListApiResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Caregiver Medicines List Error: $e');
      rethrow;
    }
  }

  // Store Caregiver Medicine
  Future<Map<String, dynamic>> storeMedicine(
      StoreCaregiverMedicineRequest medicineRequest) async {
    try {
      print('\n💾 STORE CAREGIVER MEDICINE Request 💾');
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
        Apis.storeMedicineCaregiver,
        fields: fields,
        file: medicineRequest.attachment,
        fileFieldName: 'attachment',
      );

      print('✅ Caregiver medicine stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Caregiver Medicine Error: $e');
      rethrow;
    }
  }
}
