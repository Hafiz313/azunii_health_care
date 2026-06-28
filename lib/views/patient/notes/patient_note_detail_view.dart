import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/notes_model.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import '../../widget/Common_widgets/overlayloader.dart';
import '../../widget/text.dart';
import 'repository/patient_notes_repository.dart';

class PatientNoteDetailController extends BaseController {
  final PatientNotesRepository _notesRepository = PatientNotesRepository();
  final int noteId;
  final Rxn<NotesModel> note = Rxn<NotesModel>();

  PatientNoteDetailController(this.noteId);

  @override
  void onInit() {
    super.onInit();
    fetchNoteDetail();
  }

  Future<void> fetchNoteDetail() async {
    final response = await safeApiCall(() => _notesRepository.getSingleCaregiverNote(noteId));
    if (response != null) {
      note.value = response.data;
    }
  }
}

class PatientNoteDetailView extends StatelessWidget {
  final int noteId;
  const PatientNoteDetailView({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    // Unique tag for each noteId to allow multiple detail view controllers in memory
    final controller = Get.put(
      PatientNoteDetailController(noteId),
      tag: noteId.toString(),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
             CustomAppBar(
              title: 'Note Details',
              isOndashboard: false,
            ),
            Expanded(
              child: Obx(() => OverlayLoader(
                    isLoading: controller.isLoading.value,
                    child: controller.note.value == null
                        ? const SizedBox.shrink()
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.all(context.screenWidth * 0.05),
                            child: _buildNoteDetailCard(context, controller.note.value!),
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteDetailCard(BuildContext context, NotesModel note) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: context.screenWidth * 0.09,
                    height: context.screenWidth * 0.09,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.03),
                  subText4(
                    note.category,
                    color: AppColors.headingTextColor,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.start,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.025,
                  vertical: context.screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: subText3(
                  'ID: ${note.id}',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          subText5(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            note.note,
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
