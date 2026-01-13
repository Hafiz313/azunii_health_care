import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';
import '../../../../core/repositories/caregiver_medicine_repo.dart';
import '../../../../core/models/caregiver_medicine_list_model.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/services/caregiver_state.dart';

class MedicationController extends BaseController {
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<CaregiverMedicineItem> allMedications = <CaregiverMedicineItem>[].obs;
  final RxList<CaregiverMedicineItem> filteredMedications = <CaregiverMedicineItem>[].obs;
  final CaregiverMedicineRepository _repository = CaregiverMedicineRepository();
  final CaregiverState _state = CaregiverState();

  @override
  void onInit() {
    super.onInit();
    getMedications();
  }

  Future<void> getMedications() async {
    final patientId = _state.activePatientId.value;
    if (patientId == null) {
      print('❌ No active patient selected');
      return;
    }

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
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: '${freq.frequency[0].toUpperCase()}${freq.frequency.substring(1)} at ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: _formatTime(freq.time),
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                )
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