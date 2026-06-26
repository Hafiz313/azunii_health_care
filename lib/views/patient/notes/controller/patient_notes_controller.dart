import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/notes_model.dart';
import '../../dashboard/controller/patient_home_controller.dart';
import '../repository/patient_notes_repository.dart';
import '../patient_note_detail_view.dart';

class PatientNotesController extends BaseController {
  final PatientNotesRepository _notesRepository = PatientNotesRepository();

  final RxList<NotesModel> notesList = <NotesModel>[].obs;

  // Pagination state variables
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt totalNotes = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch
    fetchNotes(1);

    // Set up active tab listener to re-fetch first page when user lands on Notes tab (index 3)
    try {
      final dashboardController = Get.find<PatientHomeController>();
      ever(dashboardController.currentIndex, (int index) {
        if (index == 3) {
          fetchNotes(1);
        }
      });
    } catch (e) {
      debugPrint('PatientHomeController not found: $e');
    }
  }

  // Fetch paginated notes
  Future<void> fetchNotes(int page) async {
    final response = await safeApiCall(() =>
        _notesRepository.getPatientCaregiverNotes(page: page, perPage: 15));

    if (response != null) {
      notesList.value = response.data.notes;
      currentPage.value = response.data.currentPage;
      lastPage.value = response.data.lastPage;
      totalNotes.value = response.data.total;
    }
  }

  // Open note details screen
  void viewNoteDetails(int noteId) {
    Get.to(() => PatientNoteDetailView(noteId: noteId));
  }
}
