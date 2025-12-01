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
            CustomAppBar(title: Lang.medication),
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
    return SizedBox(
      width: double.infinity,
      child: AppElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicineView()),
          );
        },
        title: Lang.addMedication,
      ),
    );
  }
}

class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  static const String routeName = '/add-medicine';

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  final MedicineController controller = Get.put(MedicineController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() => LoadingOverlay(
            isLoading: controller.isLoading.value,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    CustomAppBar(
                      title: Lang.medication,
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
                            _buildFrequencySection(),
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
    return Obx(() => CustomDropdown(
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
        ));
  }

  Widget _buildStatusDropdown() {
    return Obx(() => CustomDropdown(
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
        ));
  }

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequency Schedule',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
              children: [
                if (controller.frequencyRows.isNotEmpty) _buildFrequencyRow(0),
                const SizedBox(height: 12),
                _buildAddFrequencyButton(),
                if (controller.frequencyRows.length > 1)
                  ...controller.frequencyRows
                      .asMap()
                      .entries
                      .skip(1)
                      .map((entry) => _buildFrequencyRow(entry.key))
                      .toList(),
              ],
            )),
      ],
    );
  }

  Widget _buildFrequencyRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardsColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildFrequencyDropdown(index),
                const SizedBox(height: 12),
                _buildTimeRow(index),
              ],
            ),
          ),
          if (controller.frequencyRows.length > 1) _buildRemoveButton(index),
        ],
      ),
    );
  }

  Widget _buildFrequencyDropdown(int index) {
    return Obx(() => CustomDropdown(
          label: 'Frequency',
          hintText: 'Select frequency',
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
        ));
  }

  Widget _buildTimeRow(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildTimeField(index)),
        const SizedBox(width: 8),
        _buildAmPmSelector(index),
      ],
    );
  }

  Widget _buildTimeField(int index) {
    return CustomTxtField(
      title: 'Time',
      textEditingController: controller.frequencyRows[index].timeController,
      hintTxt: '10:00',
      keyboardType: TextInputType.datetime,
      prefixIcon: const Icon(
        Icons.access_time,
        color: AppColors.textColor,
        size: 18,
      ),
    );
  }

  Widget _buildAmPmSelector(int index) {
    return Obx(() => PopupMenuButton<String>(
          initialValue: controller.frequencyRows[index].amPm.value,
          onSelected: (value) => controller.setAmPmForRow(index, value),
          offset: const Offset(0, 50),
          child: Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardsColor,
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.frequencyRows[index].amPm.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.blackColor,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColor,
                  size: 16,
                ),
              ],
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'AM', child: Text('AM')),
            const PopupMenuItem(value: 'PM', child: Text('PM')),
          ],
        ));
  }

  Widget _buildRemoveButton(int index) {
    return IconButton(
      onPressed: () => controller.removeFrequencyRow(index),
      icon: const Icon(
        Icons.remove_circle_outline,
        color: AppColors.redColor,
        size: 18,
      ),
    );
  }

  Widget _buildAddFrequencyButton() {
    return InkWell(
      onTap: controller.addFrequencyRow,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Add Another Frequency',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: 14,
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