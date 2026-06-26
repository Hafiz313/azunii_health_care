import 'package:flutter/material.dart';
import '../../../../core/models/notes_model.dart';
import '../../../../core/models/notes_response.dart';
import '../../../../networking/api_client.dart';
import '../../../../networking/api_ref.dart';

class PatientNotesRepository {
  // Get Patient Caregiver Notes (paginated)
  Future<NotesResponse> getPatientCaregiverNotes({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      debugPrint('\n📋 GET PATIENT NOTES Request 📋 (page: $page)');
      final endpoint = '${Apis.getPatientCaregiverNotes}?page=$page&per_page=$perPage';
      final response = await ApiClient.getWithAuth(endpoint);
      debugPrint('📄 Patient Notes Response retrieved successfully (page: $page)\n');
      return NotesResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Patient Notes Error: $e');
      rethrow;
    }
  }

  // Get Single Caregiver Note
  Future<NoteDetailResponse> getSingleCaregiverNote(int id) async {
    try {
      debugPrint('\n📋 GET SINGLE CAREGIVER NOTE Request 📋 (id: $id)');
      final endpoint = '${Apis.showPatientCaregiverNote}/$id';
      final response = await ApiClient.getWithAuth(endpoint);
      debugPrint('📄 Single Caregiver Note Detail retrieved successfully (id: $id)\n');
      return NoteDetailResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Single Caregiver Note Error: $e');
      rethrow;
    }
  }
}
