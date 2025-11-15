import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';

class MedicationController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxList<Map<String, dynamic>> medications = <Map<String, dynamic>>[
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
  ].obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  void viewMedicationDetails(Map<String, dynamic> medication) {
    Get.dialog(
      AlertDialog(
        title: Text(medication['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${medication['dosage']}'),
            Text('Timing: ${medication['timing']}'),
            Text('Start Date: ${medication['startDate']}'),
            Text('End Date: ${medication['endDate']}'),
            if (medication['hasInteraction'])
              Text('Interaction: ${medication['interactionMessage']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}