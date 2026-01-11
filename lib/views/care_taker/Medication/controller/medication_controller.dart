import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';
import '../../../../core/repositories/caregiver_medicine_repo.dart';
import '../../../../core/models/caregiver_medicine_list_model.dart';
import '../../../../core/controllers/base_controller.dart';

class MedicationController extends BaseController {
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<CaregiverMedicineItem> allMedications = <CaregiverMedicineItem>[].obs;
  final RxList<CaregiverMedicineItem> filteredMedications = <CaregiverMedicineItem>[].obs;
  final CaregiverMedicineRepository _repository = CaregiverMedicineRepository();

  @override
  void onInit() {
    super.onInit();
    getMedications();
  }

  Future<void> getMedications() async {
    final result = await safeApiCall(() => _repository.getMedicinesList());
    
    if (result != null) {
      allMedications.value = result.data.medicines;
      filteredMedications.value = allMedications;
    }
  }

  void filterMedicationsByDate() {
    if (allMedications.isEmpty) {
      filteredMedications.value = [];
      return;
    }

    if (selectedDate.value == null) {
      filteredMedications.value = allMedications;
      return;
    }

    final selectedDateTime = selectedDate.value!;
    
    filteredMedications.value = allMedications.where((medication) {
      try {
        final updatedAt = DateTime.parse(medication.updatedAt);
        return updatedAt.year == selectedDateTime.year &&
               updatedAt.month == selectedDateTime.month &&
               updatedAt.day == selectedDateTime.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Future<void> selectDate(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Medicines'),
              onTap: () {
                selectedDate.value = null;
                filterMedicationsByDate();
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Select Date'),
              onTap: () async {
                Get.back();
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  selectedDate.value = picked;
                  filterMedicationsByDate();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void viewMedicationDetails(CaregiverMedicineItem medication) {
    Get.dialog(
      AlertDialog(
        title: Text(medication.medicineName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${medication.dosage}'),
            Text('Status: ${medication.status}'),
            if (medication.interactionFlag == '1' && medication.interactionMessage != null)
              Text('Interaction: ${medication.interactionMessage}'),
            if (medication.frequencies.isNotEmpty) ...
              medication.frequencies.map((freq) => 
                Text('${freq.frequency} at ${freq.time}')
              ),
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