import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import '../../widget/Common_widgets/custom_dropdown.dart';
import '../../widget/text_fields.dart';
import 'controller/notes_controller.dart';

class Notesview extends StatelessWidget {
  static const String routeName = '/notes-caregiver';

  const Notesview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotesController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.caregiverNotes,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenWidth * 0.05),
                    _buildAddNotesSection(context, controller),
                    SizedBox(height: context.screenWidth * 0.06),
                    _buildPreviousNotesSection(context, controller),
                    SizedBox(height: context.screenWidth * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNotesSection(
      BuildContext context, NotesController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headline6(
            Lang.addNotes,
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: context.screenWidth * 0.04),
          Obx(() => CustomDropdown(
                label: Lang.category,
                hintText: Lang.selectCategory,
                items: controller.categories,
                selectedValue: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                onChanged: controller.setCategory,
                prefixIcon: const Icon(
                  Icons.category_outlined,
                  color: AppColors.textColor,
                  size: 20,
                ),
              )),
          SizedBox(height: context.screenWidth * 0.04),
          CustomTxtField(
            title: Lang.yourNote,
            textEditingController: controller.noteController,
            hintTxt: Lang.writeYourNote,
            maxLines: 6,
            prefixIcon: const Icon(
              Icons.note_outlined,
              color: AppColors.textColor,
              size: 20,
            ),
          ),
          SizedBox(height: context.screenWidth * 0.06),
          SizedBox(
            width: double.infinity,
            height: context.screenWidth * 0.12,
            child: AppElevatedButton(
              onPressed: controller.saveNote,
              title: Lang.save,
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousNotesSection(
      BuildContext context, NotesController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headline6(
                Lang.previousNotes,
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
                onTap: controller.viewAllNotes,
                child: subText5(
                  fontSize: 12,
                  Lang.viewAll,
                  color: AppColors.borderColor,
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(height: context.screenWidth * 0.04),
          Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.previousNotes.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: context.screenWidth * 0.04),
                itemBuilder: (context, index) {
                  final note = controller.previousNotes[index];
                  return _buildNoteCard(context, note, controller);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Map<String, dynamic> note,
      NotesController controller) {
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
                    width: context.screenWidth * 0.06,
                    height: context.screenWidth * 0.06,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.02),
                  subText4(
                    note['category'],
                    color: AppColors.headingTextColor,
                    fontWeight: FontWeight.w500,
                    align: TextAlign.start,
                  ),
                ],
              ),
              subText3(
                note['date'],
                color: AppColors.textColor,
                align: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: context.screenWidth * 0.03),
          subText3(
            note['note'],
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
          SizedBox(height: context.screenWidth * 0.03),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppColors.textColor,
                      size: context.screenWidth * 0.04,
                    ),
                    SizedBox(width: context.screenWidth * 0.01),
                    Expanded(
                      child: subText3(
                        note['addedBy'],
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.screenWidth * 0.02),
              SizedBox(
                width: context.screenWidth * 0.24,
                height: context.screenWidth * 0.08,
                child: AppElevatedButton(
                  onPressed: () => controller.viewNoteDetails(note),
                  title: Lang.details,
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
