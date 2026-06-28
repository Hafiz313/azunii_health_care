import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../core/models/notes_model.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import '../../widget/Common_widgets/overlayloader.dart';
import '../../widget/Common_widgets/pagination_controls.dart';
import '../../widget/text.dart';
import 'controller/patient_notes_controller.dart';

class PatientNotesView extends StatelessWidget {
  const PatientNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientNotesController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const
            CustomAppBar(
              title: 'Notes',
              isOndashboard: true,
            ),
            Expanded(
              child: Obx(() => OverlayLoader(
                    isLoading: controller.isLoading.value,
                    child: RefreshIndicator(
                      onRefresh: () => controller.fetchNotes(controller.currentPage.value),
                      color: AppColors.primary,
                      child: controller.notesList.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: context.screenHeight * 0.22),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.note_outlined,
                                        size: 80,
                                        color: AppColors.textColor.withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 16),
                                      subText4(
                                        'No notes available',
                                        color: AppColors.textColor.withOpacity(0.6),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(context.screenWidth * 0.05),
                                    itemCount: controller.notesList.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: context.screenWidth * 0.04),
                                    itemBuilder: (context, index) {
                                      final note = controller.notesList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (note.id != null) {
                                            controller.viewNoteDetails(note.id!);
                                          }
                                        },
                                        child: _buildNoteCard(context, note),
                                      );
                                    },
                                  ),
                                ),
                                Obx(() {
                                  if (controller.lastPage.value <= 1) {
                                    return const SizedBox.shrink();
                                  }
                                  return PaginationControls(
                                    currentPage: controller.currentPage.value,
                                    lastPage: controller.lastPage.value,
                                    onPageChanged: (page) {
                                      controller.fetchNotes(page);
                                    },
                                  );
                                }),
                              ],
                            ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, NotesModel note) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                    width: context.screenWidth * 0.08,
                    height: context.screenWidth * 0.08,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.03),

                  subText4(
                    note.category,
                    color: AppColors.headingTextColor,
                    fontWeight: FontWeight.w600,
                    align: TextAlign.start,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.02,
                  vertical: context.screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: subText3(
                  'ID: ${note.id}',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: context.screenWidth * 0.03),
          subText5(
            fontSize: 14,
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
