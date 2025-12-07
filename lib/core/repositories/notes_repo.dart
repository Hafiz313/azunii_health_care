import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/notes_model.dart';

class NotesRepository {
  // Store Note
  Future<Map<String, dynamic>> storeNote(NotesModel note) async {
    try {
      print('\n📝 STORE NOTE Request 📝');
      print('Patient ID: ${note.patientId}');
      print('Category: ${note.category}');
      print('Note: ${note.note}');

      final response = await ApiClient.postMultipartWithAuth(
        Apis.notesCaregiver,
        fields: {
          'patient_id': note.patientId.toString(),
          'category': note.category,
          'note': note.note,
        },
      );

      print('✅ Note stored successfully\n');
      return response;
    } catch (e) {
      print('❌ Store Note Error: $e');
      rethrow;
    }
  }

  // Get Notes List
  Future<List<NotesModel>> getNotesList(int patientId) async {
    try {
      print('\n📋 GET NOTES LIST Request 📋');
      print('Patient ID: $patientId');
      
      final response = await ApiClient.postMultipartWithAuth(
        Apis.listCaregiver,
        fields: {
          'patient_id': patientId.toString(),
        },
      );
      
      final List<dynamic> notesData = response['data'] ?? [];
      final notes = notesData.map((json) => NotesModel.fromJson(json)).toList();
      
      print('✅ Retrieved ${notes.length} notes\n');
      return notes;
    } catch (e) {
      print('❌ Get Notes List Error: $e');
      rethrow;
    }
  }
}
