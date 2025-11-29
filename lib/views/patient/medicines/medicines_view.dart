import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_dropdown.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/upload_section_widget.dart';
import 'package:Azunii_Health/views/widget/loading_overlay.dart';
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
import 'controller/medicineController.dart';

class MedicinesView extends StatelessWidget {
  const MedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.medication,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildAddMedicationButton(context),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMedicationButton(BuildContext context) {
    return Container(
        width: double.infinity,
        child: AppElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddMedicineView()),
              );
            },
            title: Lang.addMedication));
  }
}

/// Add Medicine View - Separate widget for adding new medicines
class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  static const String routeName = '/add-medicine';

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  final MedicineController controller = Get.put(MedicineController());

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Medicine saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Get.back(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.medication,

              onIconTap: () {}, // optional
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    CustomTxtField(
                      title: Lang.medName,
                      textEditingController: controller.medNameController,
                      hintTxt: Lang.enterMedName,
                      prefixIcon: const Icon(
                        Icons.medication_outlined,
                        color: AppColors.textColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdown(
                          label: Lang.dosage,
                          hintText: Lang.enterDosage,
                          items: controller.dosageList,
                          selectedValue: controller.selectedDosage.value.isEmpty
                              ? null
                              : controller.selectedDosage.value,
                          onChanged: controller.setDosage,
                          prefixIcon: const Icon(
                            Icons.science_outlined,
                            color: AppColors.textColor,
                            size: 20,
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdown(
                          label: Lang.frequency,
                          hintText: Lang.enterMedFrequency,
                          items: controller.frequencyList,
                          selectedValue:
                              controller.selectedFrequency.value.isEmpty
                                  ? null
                                  : controller.selectedFrequency.value,
                          onChanged: controller.setFrequency,
                          prefixIcon: SvgPicture.asset(
                            AppAssets.calander,
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdown(
                          label: Lang.status,
                          hintText: Lang.selectStatus,
                          items: controller.statusList,
                          selectedValue: controller.selectedStatus.value.isEmpty
                              ? null
                              : controller.selectedStatus.value,
                          onChanged: controller.setStatus,
                          prefixIcon: const Icon(
                            Icons.medical_services_outlined,
                            color: AppColors.textColor,
                            size: 20,
                          ),
                        )),
                    const SizedBox(height: 24),
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
                      onPressed: () {
                        _showSaveDialog(context);
                      },
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
}
