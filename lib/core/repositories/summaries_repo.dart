import 'dart:math';
import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';

class SummariesRepository {
  // Get Patient Summary
  Future<Map<String, dynamic>> getSummary() async {
    try {
      print('\n📋 GET SUMMARY Request 📋');
      final response = await ApiClient.getWithAuth(Apis.getPatientSummary);
      print('📄 Summary Response: Retrieved patient summary\n');
      return response;
    } catch (e) {
      print('❌ Get Summary Error: $e');
      rethrow;
    }
  }

  // Store Patient Summary
  Future<Map<String, dynamic>> storeSummary(String summaryText) async {
    try {
      print('\n💾 STORE SUMMARY Request 💾');
      print(
          '📝 Summary Text: ${summaryText.substring(0, min(50, summaryText.length))}...');

      final response =
          await ApiClient.postWithAuth(Apis.storePatientSummary, body: {
        'summary_text': summaryText,
      });

      print('✅ Summary stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Summary Error: $e');
      rethrow;
    }
  }

  // Update Patient Summary
  Future<Map<String, dynamic>> updateSummary(int id, String summaryText) async {
    try {
      print('\n📝 UPDATE SUMMARY Request 📝');
      print('🆔 Summary ID: $id');
      print(
          '📝 Summary Text: ${summaryText.substring(0, min(50, summaryText.length))}...');

      final response =
          await ApiClient.postWithAuth('${Apis.updatePatientSummary}', body: {
        'id': id,
        'summary_text': summaryText,
      });

      print('✅ Summary updated successfully for ID: $id\n');
      return response;
    } catch (e) {
      print('❌ Update Summary Error: $e');
      rethrow;
    }
  }

  // Store Patient Feedback
  Future<Map<String, dynamic>> storeFeedback(int rating, String note) async {
    try {
      print('\n💬 STORE FEEDBACK Request 💬');
      print('⭐ Rating: $rating');
      print('📝 Note: $note');

      final response = await ApiClient.postWithAuth(Apis.storeFeedback, body: {
        'rating': rating.toString(),
        'note': note,
      });

      print('✅ Feedback stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Feedback Error: $e');
      rethrow;
    }
  }
}
