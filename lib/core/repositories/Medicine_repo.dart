import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/Medicine_model.dart';

class MedicineRepository {
  // Get Patient Medicines
  Future<Map<String, dynamic>> getMedicines() async {
    try {
      print('\n💊 GET MEDICINES Request 💊');
      final response = await ApiClient.getWithAuth(Apis.getPatientMedicines);
      print('📄 Medicines Response: Retrieved patient medicines\n');
      return response;
    } catch (e) {
      print('❌ Get Medicines Error: $e');
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

      final jsonData = medicineRequest.toJson();
      final fields = <String, String>{};
      List<Map<String, dynamic>>? frequenciesData;

      // Separate string fields from file and complex objects
      jsonData.forEach((key, value) {
        if (value is String) {
          fields[key] = value;
        } else if (key == 'frequencies' && value is List) {
          frequenciesData = List<Map<String, dynamic>>.from(value);
        }
      });

      // Add frequencies as JSON string if present
      if (frequenciesData != null) {
        fields['frequencies'] = frequenciesData.toString();
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
      UpdateMedicineRequest medicineRequest) async {
    try {
      print('\n📝 UPDATE MEDICINE Request 📝');
      print('🆔 Medicine ID: ${medicineRequest.id}');
      print('💊 Medicine: ${medicineRequest.medicineName}');

      final jsonData = medicineRequest.toJson();
      final fields = <String, String>{};
      List<Map<String, dynamic>>? frequenciesData;

      // Separate string fields from file and complex objects
      jsonData.forEach((key, value) {
        if (value is String) {
          fields[key] = value;
        } else if (key == 'frequencies' && value is List) {
          frequenciesData = List<Map<String, dynamic>>.from(value);
        }
      });

      // Add frequencies as JSON string if present
      if (frequenciesData != null) {
        fields['frequencies'] = frequenciesData.toString();
      }

      final response = await ApiClient.postMultipartWithAuth(
        '${Apis.updatePatientMedicine}/${medicineRequest.id}',
        fields: fields,
        file: medicineRequest.attachment,
        fileFieldName: 'attachment',
      );

      print('✅ Medicine updated successfully for ID: ${medicineRequest.id}\n');
      return response;
    } catch (e) {
      print('❌ Update Medicine Error: $e');
      rethrow;
    }
  }
}
