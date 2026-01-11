import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';
import '../../../../consts/colors.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/notes_model.dart';
import '../../../../core/repositories/notes_repo.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';

class NotesController extends BaseController {
  final TextEditingController noteController = TextEditingController();
  final RxString selectedCategory = ''.obs;

  final List<String> categories = [
    Lang.generalHealth,
    'Medication',
    'Exercise',
    'Diet',
    'Mood',
  ];

  final RxList<NotesModel> previousNotes = <NotesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final result = await safeApiCall(
        () => _notesRepository.getNotesList(1)); // TODO: Replace with actual patient ID
    if (result != null) {
      previousNotes.value = result;
    }
  }

  void setCategory(String? category) {
    selectedCategory.value = category ?? '';
  }

  final NotesRepository _notesRepository = NotesRepository();

  Future<void> saveNote() async {
    if (selectedCategory.value.isEmpty) {
      CustomSnackbar.show('Please select a category', isSuccess: false);
      return;
    }

    if (noteController.text.trim().isEmpty) {
      CustomSnackbar.show('Please write a note', isSuccess: false);
      return;
    }

    final note = NotesModel(
      patientId: 1, // TODO: Replace with actual patient ID
      category: selectedCategory.value,
      note: noteController.text.trim(),
    );

    final result = await safeApiCall(() => _notesRepository.storeNote(note));

    if (result != null) {
      noteController.clear();
      selectedCategory.value = '';
      CustomSnackbar.show('Note saved successfully!', isSuccess: true);
      await fetchNotes();
    }
  }

  void viewAllNotes() {
    CustomSnackbar.show('Showing all ${previousNotes.length} notes', isSuccess: true);
  }

  void viewNoteDetails(NotesModel note) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(note.category),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${note.category}'),
            const SizedBox(height: 8),
            Text('Note: ${note.note}'),
          ],
        ),
        actions: [
          SizedBox(
            width: 100,
            height: 35,
            child: AppElevatedButton(
              onPressed: () => Get.back(),
              title: 'Close',
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
