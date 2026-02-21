import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';
import '../../../../consts/colors.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/notes_model.dart';
import '../../../../core/repositories/notes_repo.dart';
import '../../../../core/services/caregiver_state.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';
import '../../dashboard/controller/caretaker_home_controller.dart';

class NotesController extends BaseController {
  final TextEditingController noteController = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final NotesRepository _notesRepository = NotesRepository();
  final CaregiverState _state = CaregiverState();
  
  // Track the current patient ID to detect changes
  final RxInt currentPatientId = RxInt(0);
  
  // Track if we're currently fetching to prevent duplicate calls
  bool _isFetching = false;

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
    
    // Listen to text changes for character counter
    // Check if controller is not disposed before adding listener
    if (!noteController.hasListeners) {
      noteController.addListener(() {
        if (!noteController.text.isEmpty || noteController.text.isEmpty) {
          update();
        }
      });
    }
    
    // Listen to active patient changes
    ever(_state.activePatientId, (patientId) {
      if (patientId != null && patientId != currentPatientId.value) {
        print('🔄 [Notes] Patient changed from ${currentPatientId.value} to $patientId');
        currentPatientId.value = patientId;
        // Clear form when patient changes - check if not disposed
        try {
          if (noteController.text.isNotEmpty) {
            noteController.clear();
          }
        } catch (e) {
          print('⚠️ [Notes] Controller already disposed: $e');
        }
        selectedCategory.value = '';
        
        // Only fetch if we're on the notes page
        try {
          if (Get.isRegistered<CareTakerHomeController>()) {
            final dashboardController = Get.find<CareTakerHomeController>();
            if (dashboardController.currentIndex.value == 2) {
              print('📄 [Notes] On notes page - Fetching notes...');
              fetchNotes();
            } else {
              print('📄 [Notes] Not on notes page - Skipping auto-fetch');
            }
          }
        } catch (e) {
          print('⚠️ [Notes] Dashboard controller not found, fetching anyway: $e');
          fetchNotes();
        }
      }
    });
    
    // Listen to dashboard page changes
    try {
      if (Get.isRegistered<CareTakerHomeController>()) {
        final dashboardController = Get.find<CareTakerHomeController>();
        ever(dashboardController.refreshTrigger, (_) {
          // Check if we're on the notes page (index 2)
          if (dashboardController.currentIndex.value == 2) {
            print('📄 [Notes] Notes page became visible - Refreshing...');
            fetchNotes();
          }
        });
      }
    } catch (e) {
      print('⚠️ [Notes] Dashboard controller not found: $e');
    }
    
    // Initial load only if patient is already selected AND we're on notes page
    final patientId = _state.activePatientId.value;
    if (patientId != null) {
      print('📋 [Notes] Initial patient ID: $patientId');
      currentPatientId.value = patientId;
      // Don't auto-fetch on init, wait for page to be visible
    }
  }

  Future<void> fetchNotes() async {
    // Prevent duplicate calls
    if (_isFetching) {
      print('⏳ [Notes] Already fetching, skipping duplicate call');
      return;
    }
    
    final patientId = _state.activePatientId.value;
    
    print('🔍 [Notes] fetchNotes called - Patient ID: $patientId');
    
    if (patientId == null) {
      print('❌ [Notes] No active patient selected');
      // Clear notes if no patient is selected
      previousNotes.value = [];
      currentPatientId.value = 0;
      return;
    }

    // Update current patient ID
    currentPatientId.value = patientId;
    
    // Clear previous notes before fetching new ones
    previousNotes.value = [];
    
    print('📡 [Notes] Fetching notes for patient ID: $patientId');

    _isFetching = true;
    final result =
        await safeApiCall(() => _notesRepository.getNotesList(patientId));
    _isFetching = false;
    
    if (result != null) {
      print('✅ [Notes] Received ${result.length} notes');
      previousNotes.value = result;
    } else {
      print('❌ [Notes] Failed to fetch notes');
    }
  }

  void setCategory(String? category) {
    selectedCategory.value = category ?? '';
  }

  Future<void> saveNote() async {
    final patientId = _state.activePatientId.value;
    if (patientId == null) {
      CustomSnackbar.show('No active patient selected', isSuccess: false);
      return;
    }

    if (selectedCategory.value.isEmpty) {
      CustomSnackbar.show('Please select a category', isSuccess: false);
      return;
    }

    // Check if controller is disposed before accessing text
    String noteText;
    try {
      noteText = noteController.text.trim();
    } catch (e) {
      print('⚠️ [Notes] Controller disposed, cannot save note: $e');
      CustomSnackbar.show('Error: Please try again', isSuccess: false);
      return;
    }

    if (noteText.isEmpty) {
      CustomSnackbar.show('Please write a note', isSuccess: false);
      return;
    }

    if (noteText.length > 500) {
      CustomSnackbar.show('Note cannot exceed 500 characters', isSuccess: false);
      return;
    }

    final note = NotesModel(
      patientId: patientId,
      category: selectedCategory.value,
      note: noteText,
    );

    final result = await safeApiCall(() => _notesRepository.storeNote(note));

    if (result != null) {
      try {
        noteController.clear();
      } catch (e) {
        print('⚠️ [Notes] Could not clear controller: $e');
      }
      selectedCategory.value = '';
      CustomSnackbar.show('Note saved successfully!', isSuccess: true);
      await fetchNotes();
    }
  }

  void viewAllNotes() {
    Get.toNamed('/caregiver-all-notes', arguments: previousNotes.toList());
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    note.category,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Note Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Note: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    note.note,
                  ),
                ),
              ],
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
    // Only dispose if not already disposed
    try {
      noteController.dispose();
    } catch (e) {
      print('⚠️ [Notes] Controller already disposed in onClose: $e');
    }
    super.onClose();
  }
}
