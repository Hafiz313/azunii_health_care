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

  final RxList<Map<String, dynamic>> previousNotes = <Map<String, dynamic>>[
    {
      'category': Lang.generalHealth,
      'date': '09-12-2025',
      'note': Lang.patientReportedFeeling,
      'addedBy': Lang.addedBySarahJohnson,
    },
    {
      'category': Lang.generalHealth,
      'date': '09-12-2025',
      'note': Lang.patientReportedFeeling,
      'addedBy': Lang.addedBySarahJohnson,
    },
  ].obs;

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
      previousNotes.insert(0, {
        'category': selectedCategory.value,
        'date': DateTime.now().toString().substring(0, 10),
        'note': noteController.text,
        'addedBy': 'Added by Current User',
      });

      noteController.clear();
      selectedCategory.value = '';

      CustomSnackbar.show('Note saved successfully!', isSuccess: true);
    }
  }

  void viewAllNotes() {
    CustomSnackbar.show('Showing all ${previousNotes.length} notes', isSuccess: true);
  }

  void viewNoteDetails(Map<String, dynamic> note) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(note['category']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${note['date']}'),
            const SizedBox(height: 8),
            Text('Note: ${note['note']}'),
            const SizedBox(height: 8),
            Text(
              'Added by: ${note['addedBy']}',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
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
