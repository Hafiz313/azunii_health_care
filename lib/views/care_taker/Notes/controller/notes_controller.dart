import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';
import '../../../../consts/colors.dart';

class NotesController extends GetxController {
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

  void saveNote() {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a category',
        backgroundColor: AppColors.redColor,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (noteController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a note',
        backgroundColor: AppColors.redColor,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    previousNotes.insert(0, {
      'category': selectedCategory.value,
      'date': DateTime.now().toString().substring(0, 10),
      'note': noteController.text,
      'addedBy': 'Added by Current User',
    });

    noteController.clear();
    selectedCategory.value = '';

    Get.snackbar(
      'Success',
      'Note saved successfully!',
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void viewAllNotes() {
    Get.snackbar(
      'Info',
      'Showing all ${previousNotes.length} notes',
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void viewNoteDetails(Map<String, dynamic> note) {
    Get.dialog(
      AlertDialog(
        title: Text(note['category']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${note['date']}'),
            const SizedBox(height: 8),
            Text('Note: ${note['note']}'),
            const SizedBox(height: 8),
            Text('Added by: ${note['addedBy']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
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