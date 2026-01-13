import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import '../../widget/Common_widgets/overlayloader.dart';
import 'controller/medication_controller.dart';
import '../../../core/models/caregiver_medicine_list_model.dart';

class Medication_caretaker extends StatelessWidget {
  static const String routeName = '/medication-caregiver';

  const Medication_caretaker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicationController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() => OverlayLoader(
              isLoading: controller.isLoading.value,
              child: Column(
                children: [
                  CustomAppBar(
                    title: Lang.medication,
                    onIconTap: () {},
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.getMedications,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            _buildHeader(context, controller),
                            const SizedBox(height: 20),
                            _buildMedicationList(context, controller),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MedicationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          headline6(
            Lang.completed,
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
          ),
          GestureDetector(
            onTap: () => controller.selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerGray),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(width: 8),
                  Obx(() => subText5(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        controller.selectedDate.value == null
                            ? 'All'
                            : '${controller.selectedDate.value!.day.toString().padLeft(2, '0')}-${controller.selectedDate.value!.month.toString().padLeft(2, '0')}-${controller.selectedDate.value!.year}',
                        color: AppColors.textColor,
                      )),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.textColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationList(
      BuildContext context, MedicationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        if (controller.filteredMedications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: subText4(
                'No medicines are available',
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
                align: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.filteredMedications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final medication = controller.filteredMedications[index];
            return _buildMedicationCard(context, medication, controller);
          },
        );
      }),
    );
  }

  Widget _buildMedicationCard(BuildContext context,
      CaregiverMedicineItem medication, MedicationController controller) {
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
          // Medication name and dosage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              subText4(
                medication.medicineName,
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w500,
                align: TextAlign.start,
              ),
              subText5(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                medication.dosage,
                color: AppColors.textColor,
                align: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: context.screenWidth * 0.02),
          // Timing and dates
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (medication.frequencies.isNotEmpty)
                ...medication.frequencies.map((f) => Padding(
                      padding: EdgeInsets.only(bottom: context.screenWidth * 0.01),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textColor,
                            fontFamily: 'Satoshi',
                          ),
                          children: [
                            TextSpan(
                              text: '${f.frequency[0].toUpperCase()}${f.frequency.substring(1)} at ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: _formatTime(f.time),
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ))
              else
                subText5(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  'No timing specified',
                  color: AppColors.textColor,
                  align: TextAlign.start,
                ),
              SizedBox(height: context.screenWidth * 0.01),
              Wrap(
                spacing: context.screenWidth * 0.03,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      subText5(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        '${Lang.startDate}: ',
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                      subText5(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        _formatDate(medication.createdAt),
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      subText5(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        '${Lang.endDate} ',
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                      subText5(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        _formatDate(medication.updatedAt),
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: context.screenWidth * 0.03),
          // Drug interactions section - matching Figma design
          if (medication.interactionFlag == '1')
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: context.screenWidth * 0.06,
                  height: context.screenWidth * 0.06,
                  decoration: const BoxDecoration(
                    color: AppColors.lightRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subText4(
                        Lang.drugInteractions,
                        color: AppColors.headingTextColor,
                        fontWeight: FontWeight.w500,
                        align: TextAlign.start,
                      ),
                      SizedBox(height: context.screenWidth * 0.005),
                      Wrap(
                        children: [
                          subText5(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            '${Lang.interactsWith}',
                            color: AppColors.textColor,
                            align: TextAlign.start,
                          ),
                          subText5(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            ' ${medication.interactionDetails ?? 'Unknown interaction'}',
                            color: AppColors.textColor,
                            align: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(height: context.screenWidth * 0.005),
                      subText5(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        medication.interactionMessage ??
                            'No interaction message available',
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(height: context.screenWidth * 0.03),
          // View Details button
          SizedBox(
            width: context.screenWidth * 0.35,
            height: context.screenWidth * 0.09,
            child: AppElevatedButton(
              onPressed: () => controller.viewMedicationDetails(medication),
              title: Lang.viewDetails,
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateTime.split(' ')[0];
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];
      
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      
      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }
}
