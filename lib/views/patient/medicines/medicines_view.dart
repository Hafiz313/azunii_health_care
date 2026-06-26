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
import 'widgets/searchable_medicine_field.dart';

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
                            _buildFrequencyTypeSection(context),
                            const SizedBox(height: 20),
                            _buildDateFields(context),
                            const SizedBox(height: 20),
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
    return SearchableMedicineField(
      title: Lang.medName,
      hintTxt: Lang.enterMedName,
      prefixIcon: const Icon(
        Icons.medication_outlined,
        color: AppColors.textColor,
        size: 20,
      ),
      controller: controller,
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
          allowCustomValue: true,
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
          items: const ['active', 'inactive', 'paused'],
          selectedValue: controller.selectedStatus.value.isEmpty
              ? null
              : controller.selectedStatus.value.toLowerCase(),
          onChanged: controller.setStatus,
          allowCustomValue: false,
          prefixIcon: const Icon(
            Icons.medical_services_outlined,
            color: AppColors.textColor,
            size: 20,
          ),
        ));
  }

  // Frequency Type Selection (Scheduled/Unscheduled)
  Widget _buildFrequencyTypeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency Type',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
            fontSize: context.percentHeight * 2.5,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Row(
              children: [
                Expanded(
                  child: _buildFrequencyTypeOption(
                    context,
                    'Unscheduled',
                    'As needed',
                    'unscheduled',
                    Icons.event_busy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFrequencyTypeOption(
                    context,
                    'Scheduled',
                    'Regular times',
                    'scheduled',
                    Icons.event_available,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  // Frequency Type Option Card
  Widget _buildFrequencyTypeOption(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    IconData icon,
  ) {
    final isSelected = controller.frequencyType.value == value;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.setFrequencyType(value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.cardsColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color:
                    isSelected ? AppColors.primary : AppColors.headingTextColor,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textColor,
                fontFamily: 'Satoshi',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date Fields (Start Date and End Date)
  Widget _buildDateFields(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date (Required)
            _buildDateField(
              context,
              'Start Date *',
              controller.startDateController,
              true,
            ),
            // End Date (Optional) - Only show for scheduled
            if (controller.frequencyType.value == 'scheduled') ...[
              const SizedBox(height: 16),
              _buildDateField(
                context,
                'End Date (Optional)',
                controller.endDateController,
                false,
              ),
            ],
          ],
        ));
  }

  // Single Date Field
  Widget _buildDateField(
    BuildContext context,
    String label,
    TextEditingController controller,
    bool isRequired,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            // For end date, enforce firstDate = start date
            DateTime firstDate = DateTime(2020);
            if (!isRequired && this.controller.startDateController.text.isNotEmpty) {
              try {
                firstDate = DateTime.parse(this.controller.startDateController.text.trim());
              } catch (_) {}
            }
            
            // Use selected date if available, otherwise use firstDate or today
            DateTime initialDate = DateTime.now();
            if (controller.text.isNotEmpty) {
              try {
                final selectedDate = DateTime.parse(controller.text.trim());
                // Ensure selected date is not before firstDate
                if (!selectedDate.isBefore(firstDate)) {
                  initialDate = selectedDate;
                } else if (firstDate.isAfter(DateTime.now())) {
                  initialDate = firstDate;
                }
              } catch (_) {
                initialDate = firstDate.isAfter(DateTime.now()) ? firstDate : DateTime.now();
              }
            } else {
              initialDate = firstDate.isAfter(DateTime.now()) ? firstDate : DateTime.now();
            }
            
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: DateTime(2030),
            );
            // Prevent focus restoration after date picker closes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusManager.instance.primaryFocus?.unfocus();
            });
            if (picked != null) {
              controller.text =
                  '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
              // Recalculate available frequencies when dates change
              this.controller.recalculateFrequencies();
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Select date',
                hintStyle: TextStyle(
                  color: AppColors.textColor.withOpacity(0.5),
                  fontFamily: 'Satoshi',
                ),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.cardsColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.dividerGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.dividerGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySection(BuildContext context) {
    return Obx(() {
      // Hide frequency section for unscheduled
      if (controller.frequencyType.value == 'unscheduled') {
        return const SizedBox.shrink();
      }

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
          Column(
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
          ),
        ],
      );
    });
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
    return Obx(() => CustomDropdown(
          label: 'Frequency',
          hintText: 'Select',
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

  Widget _buildTimePicker(int index) {
    return Obx(() {
      final timeText = controller.frequencyRows[index].timeController.text;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              // Prevent focus restoration after time picker closes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusManager.instance.primaryFocus?.unfocus();
              });
              if (picked != null) {
                final formattedTime =
                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                // Check if this time is already used by another row
                if (controller.isTimeAlreadyUsed(index, formattedTime)) {
                  Get.snackbar(
                    'Duplicate Time',
                    'This time is already selected in another frequency row',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade900,
                    margin: const EdgeInsets.all(12),
                  );
                  return;
                }
                controller.frequencyRows[index].timeController.text =
                    formattedTime;
                controller.frequencyRows.refresh();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardsColor,
                border: Border.all(width: 0.3, color: AppColors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.textColor,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      timeText.isEmpty ? 'Select ' : timeText,
                      style: TextStyle(
                        color: timeText.isEmpty
                            ? AppColors.textColor
                            : AppColors.blackColor,
                        fontFamily: 'Satoshi',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
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
      onTap: controller.showFilePickerOptions,
      selectedFile: controller.selectedFile,
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
