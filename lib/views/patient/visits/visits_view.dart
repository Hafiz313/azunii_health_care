import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_dropdown.dart';
import 'package:Azunii_Health/views/widget/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/custom_date_picker.dart';
import '../../widget/Common_widgets/upload_section_widget.dart';
import 'controller/visits_controller.dart';

class VisitsView extends StatelessWidget {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.userDoctor,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              headingText1(
                'Visits',
                color: AppColors.headingTextColor,
              ),
              const SizedBox(height: 10),
              subText3(
                'Manage your doctor visits',
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddVisitView extends StatelessWidget {
  AddVisitView({super.key});

  final VisitsController controller = Get.put(VisitsController());

  static const String routeName = '/add-visit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.addVisit,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildHeading(),
                    const SizedBox(height: 10),
                    // Provider name
                    CustomTxtField(
                      title: Lang.ProviderName,
                      textEditingController: controller.providerNameController,
                      hintTxt: Lang.enterProviderName,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.textColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Specialty dropdown
                    Obx(() => CustomDropdown(
                          label: Lang.specialty,
                          hintText: Lang.selectSpecialty,
                          items: const [
                            'Cardiologist',
                            'Neurologist',
                            'Dermatologist',
                            'Pediatrician',
                            'Orthopedic',
                          ],
                          selectedValue:
                              controller.selectedSpecialty.value.isEmpty
                                  ? null
                                  : controller.selectedSpecialty.value,
                          onChanged: controller.setSpecialty,
                          prefixIcon: const Icon(
                            Icons.settings_outlined,
                            size: 18,
                            color: AppColors.textColor,
                          ),
                        )),
                    const SizedBox(height: 20),
                    // Date picker
                    Obx(() => CustomDatePicker(
                          label: Lang.date,
                          hintText: Lang.selectDate,
                          selectedDate: controller.selectedDate.value,
                          onChanged: controller.setDate,
                        )),
                    const SizedBox(height: 20),
                    // Notes
                    CustomTxtField(
                      title: Lang.notes,
                      textEditingController: controller.notesController,
                      hintTxt: Lang.writeDescription,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    // Upload Section
                    UploadSectionWidget(
                      headerIcon: Icons.upload,
                      title: Lang.photoDocumentUpload,
                      subtitle: Lang.selectAndUploadPhoto,
                      onTap: controller.showImagePickerDialog,
                      selectedImage: controller.selectedImage,
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    AppElevatedButton(
                      onPressed: controller.saveVisit,
                      title: Lang.save,
                      backgroundColor: AppColors.primary,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 12,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return subText5(
      Lang.prepareForNewVisit,
      fontSize: 15,
      color: AppColors.headingTextColor,
      fontWeight: FontWeight.w500,
    );
  }
}
