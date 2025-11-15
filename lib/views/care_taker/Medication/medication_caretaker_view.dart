import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/customAppBar.dart';


class Medication_caretaker extends StatefulWidget {
  static const String routeName = '/medication-caregiver';
  
  const Medication_caretaker({super.key});

  @override
  State<Medication_caretaker> createState() => _Medication_caretakerState();
}

class _Medication_caretakerState extends State<Medication_caretaker> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> medications = [
    {
      'name': Lang.paracetamol,
      'dosage': '500mg',
      'timing': Lang.afterMeals,
      'startDate': '09-12-2025',
      'endDate': '10-12-2025',
      'hasInteraction': true,
      'interactionWith': Lang.ibuprofen,
      'interactionMessage': Lang.mayReduceEffectiveness,
    },
    {
      'name': Lang.paracetamol,
      'dosage': '500mg',
      'timing': Lang.afterMeals,
      'startDate': '09-12-2025',
      'endDate': '10-12-2025',
      'hasInteraction': true,
      'interactionWith': Lang.ibuprofen,
      'interactionMessage': Lang.mayReduceEffectiveness,
    },
    {
      'name': Lang.paracetamol,
      'dosage': '500mg',
      'timing': Lang.afterMeals,
      'startDate': '09-12-2025',
      'endDate': '10-12-2025',
      'hasInteraction': true,
      'interactionWith': Lang.ibuprofen,
      'interactionMessage': Lang.mayReduceEffectiveness,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildMedicationList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerGray),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(width: 8),
                  subText3(
                    '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}',
                    color: AppColors.textColor,
                  ),
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

  Widget _buildMedicationList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: medications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final medication = medications[index];
          return _buildMedicationCard(medication);
        },
      ),
    );
  }

  Widget _buildMedicationCard(Map<String, dynamic> medication) {
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
                medication['name'],
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w500,
                align: TextAlign.start,
              ),
              subText3(
                medication['dosage'],
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
              subText3(
                medication['timing'],
                color: AppColors.textColor,
                align: TextAlign.start,
              ),
              SizedBox(height: context.screenWidth * 0.01),
              Row(
                children: [
                  Expanded(
                    child: subText3(
                      '${Lang.startDate} ${medication['startDate']}',
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.03),
                  Expanded(
                    child: subText3(
                      '${Lang.endDate} ${medication['endDate']}',
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: context.screenWidth * 0.03),
          // Drug interactions section - matching Figma design
          if (medication['hasInteraction'])
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
                      subText3(
                        '${Lang.interactsWith} ${medication['interactionWith']}',
                        color: AppColors.textColor,
                        align: TextAlign.start,
                      ),
                      SizedBox(height: context.screenWidth * 0.005),
                      subText3(
                        medication['interactionMessage'],
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
            height: context.screenWidth * 0.1,
            child: AppElevatedButton(
              onPressed: () {},
              title: Lang.viewDetails,
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}