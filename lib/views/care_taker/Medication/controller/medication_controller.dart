import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/lang.dart';
import '../../../../core/repositories/caregiver_medicine_repo.dart';
import '../../../../core/models/caregiver_medicine_list_model.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/services/caregiver_state.dart';
import '../../dashboard/controller/caretaker_home_controller.dart';

class MedicationController extends BaseController {
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<CaregiverMedicineItem> allMedications = <CaregiverMedicineItem>[].obs;
  final RxList<CaregiverMedicineItem> filteredMedications = <CaregiverMedicineItem>[].obs;
  final CaregiverMedicineRepository _repository = CaregiverMedicineRepository();
  final CaregiverState _state = CaregiverState();
  
  // Track the current patient ID to detect changes
  final RxInt currentPatientId = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    
    // Listen to active patient changes
    ever(_state.activePatientId, (patientId) {
      if (patientId != null && patientId != currentPatientId.value) {
        print('🔄 Patient changed from ${currentPatientId.value} to $patientId - Fetching medications...');
        currentPatientId.value = patientId;
        // Clear date filter when patient changes
        selectedDate.value = null;
        getMedications();
      }
    });
    
    // Listen to dashboard page changes
    try {
      if (Get.isRegistered<CareTakerHomeController>()) {
        final dashboardController = Get.find<CareTakerHomeController>();
        ever(dashboardController.refreshTrigger, (_) {
          // Check if we're on the medication page (index 1)
          if (dashboardController.currentIndex.value == 1) {
            print('📄 Medication page became visible - Refreshing...');
            getMedications();
          }
        });
      }
    } catch (e) {
      print('⚠️ Dashboard controller not found: $e');
    }
    
    // Initial load if patient is already selected
    final patientId = _state.activePatientId.value;
    if (patientId != null) {
      print('📋 Initial patient ID: $patientId');
      currentPatientId.value = patientId;
      getMedications();
    }
  }

  Future<void> getMedications() async {
    final patientId = _state.activePatientId.value;
    
    print('🔍 getMedications called - Patient ID: $patientId');
    
    if (patientId == null) {
      print('❌ No active patient selected');
      // Clear medications if no patient is selected
      allMedications.value = [];
      filteredMedications.value = [];
      currentPatientId.value = 0;
      return;
    }

    // Update current patient ID
    currentPatientId.value = patientId;
    
    // Clear previous medications before fetching new ones
    allMedications.value = [];
    filteredMedications.value = [];
    
    print('📡 Fetching medications for patient ID: $patientId');

    final result = await safeApiCall(() => _repository.getMedicinesList());
    
    if (result != null) {
      print('✅ Received ${result.data.medicines.length} medications');
      allMedications.value = result.data.medicines;
      filteredMedications.value = allMedications;
    } else {
      print('❌ Failed to fetch medications');
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
        // Parse start date
        if (medication.startDate == null || medication.startDate!.isEmpty) {
          return false; // Skip if no start date
        }
        
        final startDate = DateTime.parse(medication.startDate!);
        
        // If medication has an end date
        if (medication.endDate != null && medication.endDate!.isNotEmpty) {
          final endDate = DateTime.parse(medication.endDate!);
          
          // Check if selected date is between start and end date (inclusive)
          return (selectedDateTime.isAfter(startDate.subtract(const Duration(days: 1))) &&
                  selectedDateTime.isBefore(endDate.add(const Duration(days: 1))));
        } else {
          // If no end date, medication is ongoing - check if selected date is on or after start date
          return selectedDateTime.isAfter(startDate.subtract(const Duration(days: 1)));
        }
      } catch (e) {
        print('Error filtering medication: $e');
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
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        medication.medicineName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Color(0xFF6B6B6B)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Details
                _buildDetailRow('Dosage', medication.dosage),
                _buildDetailRow('Status', medication.status),
                
                // Start Date - always show
                _buildDetailRow(
                  'Start Date',
                  medication.startDate != null && medication.startDate!.isNotEmpty
                      ? _formatDate(medication.startDate!)
                      : 'Not specified'
                ),
                
                // End Date - always show
                _buildDetailRow(
                  'End Date',
                  medication.endDate != null && medication.endDate!.isNotEmpty
                      ? _formatDate(medication.endDate!)
                      : 'Ongoing'
                ),
                
                // Frequencies
                if (medication.frequencies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Frequencies:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...medication.frequencies.map((freq) {
                    // Check if frequency is "as_per_needed"
                    if (freq.frequency.toLowerCase() == 'as_per_needed') {
                      return _buildDetailRow('Frequency', 'As per needed');
                    }
                    // Regular frequency with time
                    return _buildDetailRow(
                      freq.frequency[0].toUpperCase() + freq.frequency.substring(1),
                      _formatTime(freq.time),
                    );
                  }),
                ],
                
                // Interaction
                if (medication.interactionFlag == '1' && medication.interactionMessage != null)
                  _buildDetailRow('Interaction', medication.interactionMessage!),
                
                // Attachment Image
                if (medication.attachment != null && medication.attachment!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Attachment:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showImagePreview(medication.attachment!),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          medication.attachment!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF5F5F5),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Color(0xFF9E9E9E),
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to preview',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1C1C1E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.9),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 60,
                                    color: Colors.white54,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Failed to load',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
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