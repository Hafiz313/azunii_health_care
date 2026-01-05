import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_dropdown.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/upload_section_widget.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_time_picker.dart';
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

class AddMedicineView extends StatefulWidget {
  final bool? isOndashboard;
  const AddMedicineView({super.key, this.isOndashboard});

  static const String routeName = '/add-medicine';

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  late final MedicineController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MedicineController());
  }

  @override
  void dispose() {
    Get.delete<MedicineController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() => OverlayLoader(
            isLoading: controller.isLoading.value,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    CustomAppBar(
                      title: Lang.medication,
                      isOndashboard: widget.isOndashboard ?? true,
                      onIconTap: () {},
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            _buildMedicineNameField(),
                            const SizedBox(height: 20),
                            _buildDosageDropdown(),
                            const SizedBox(height: 20),
                            _buildStatusDropdown(),
                            const SizedBox(height: 24),
                            _buildFrequencySection(context),
                            const SizedBox(height: 24),
                            _buildUploadSection(),
                            const SizedBox(height: 24),
                            _buildSaveButton(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildMedicineNameField() {
    return CustomTxtField(
      title: Lang.medName,
      textEditingController: controller.medNameController,
      hintTxt: Lang.enterMedName,
      prefixIcon: const Icon(
        Icons.medication_outlined,
        color: AppColors.textColor,
        size: 20,
      ),
    );
  }

  Widget _buildDosageDropdown() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() => CustomDropdown(
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
    );
  }

  Widget _buildStatusDropdown() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() => CustomDropdown(
            label: Lang.status,
            hintText: 'Select status',
            items: const ['active', 'inactive'],
            selectedValue: controller.selectedStatus.value.isEmpty
                ? null
                : controller.selectedStatus.value.toLowerCase(),
            onChanged: controller.setStatus,
            prefixIcon: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.textColor,
              size: 20,
            ),
          )),
    );
  }

  Widget _buildFrequencySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency Schedule',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
            fontSize: context.percentHeight * 2.5,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
              children: [
                // Show all frequency rows above the button
                ...controller.frequencyRows
                    .asMap()
                    .entries
                    .map((entry) => _buildFrequencyRow(entry.key))
                    .toList(),
                if (controller.frequencyRows.isNotEmpty)
                  const SizedBox(height: 12),
                _buildAddFrequencyButton(context),
              ],
            )),
      ],
    );
  }

  Widget _buildFrequencyRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardsColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(child: _buildFrequencyDropdown(index)),
                const SizedBox(width: 12),
                Expanded(child: _buildTimePicker(index)),
              ],
            ),
          ),
          if (controller.frequencyRows.length > 1)
            Positioned(
              top: 4,
              right: 4,
              child: _buildRemoveButton(index),
            ),
        ],
      ),
    );
  }

  Widget _buildFrequencyDropdown(int index) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() => CustomDropdown(
            label: 'Frequency',
            hintText: 'Select ',
            items: controller.frequencyList,
            selectedValue: controller.frequencyRows[index].frequency.value.isEmpty
                ? null
                : controller.frequencyRows[index].frequency.value,
            onChanged: (value) => controller.setFrequencyForRow(index, value),
            prefixIcon: const Icon(
              Icons.schedule,
              color: AppColors.textColor,
              size: 18,
            ),
          )),
    );
  }

  Widget _buildTimePicker(int index) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() {
        final timeText = controller.frequencyRows[index].timeController.text;
        return CustomTimePicker(
          label: 'Time',
          selectedTime: timeText.isEmpty ? null : timeText,
          onTimeSelected: (time) {
            controller.frequencyRows[index].timeController.text = time;
            controller.frequencyRows.refresh();
          },
        );
      }),
    );
  }

  Widget _buildRemoveButton(int index) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.redColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => controller.removeFrequencyRow(index),
        icon: const Icon(
          Icons.close,
          color: AppColors.white,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildAddFrequencyButton(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.addFrequencyRow();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,
                color: AppColors.primary, size: context.percentHeight * 3),
            SizedBox(width: 8),
            Text(
              'Add Another Frequency',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: context.percentHeight * 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return UploadSectionWidget(
      headerIcon: Icons.upload,
      title: Lang.photoDocumentUpload,
      subtitle: Lang.selectAndUploadPhoto,
      onTap: controller.showImagePickerDialog,
      selectedImage: controller.selectedImage,
    );
  }

  Widget _buildSaveButton() {
    return AppElevatedButton(
      onPressed: controller.storeMedicine,
      title: Lang.save,
      backgroundColor: AppColors.primary,
      width: double.infinity,
    );
  }
}
