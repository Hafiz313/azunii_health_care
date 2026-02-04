import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/core/models/notes_model.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllNotesView extends StatelessWidget {
  static const String routeName = '/caregiver-all-notes';

  const AllNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the notes list passed from the previous screen
    final List<NotesModel> notes = Get.arguments ?? [];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'All Notes',
              isOndashboard: false,
            ),
            Expanded(
              child: notes.isEmpty
                  ? Center(
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
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(context.screenWidth * 0.05),
                      itemCount: notes.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: context.screenWidth * 0.04),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return _buildNoteCard(context, note);
                      },
                    ),
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
          // if (note. != null) ...[
          //   SizedBox(height: context.screenWidth * 0.03),
          //   Row(
          //     children: [
          //       Icon(
          //         Icons.access_time,
          //         size: 14,
          //         color: AppColors.textColor.withOpacity(0.5),
          //       ),
          //       SizedBox(width: context.screenWidth * 0.01),
          //       subText3(
          //         _formatDate(note.createdAt!),
          //         color: AppColors.textColor.withOpacity(0.5),
          //       ),
          //     ],
          //   ),
          // ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
