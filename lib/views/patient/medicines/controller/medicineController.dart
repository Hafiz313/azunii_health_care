import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/Medicine_model.dart';
import '../../../../core/repositories/Medicine_repo.dart';

class MedicineFrequencyInput {
  final RxString frequency = RxString('');
  final TextEditingController timeController = TextEditingController();
  final RxString amPm = RxString('AM');

  MedicineFrequencyInput();
}

class MedicineController extends BaseController {
  final MedicineRepository _medicineRepository = MedicineRepository();
  // Text Controllers
  final TextEditingController medNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  // Observable variables
  final RxString selectedDosage = RxString('');
  final RxString selectedStatus = RxString('active');
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Frequency management
  final RxList<MedicineFrequencyInput> frequencyRows =
      RxList<MedicineFrequencyInput>([]);

  // Dropdown lists
  final List<String> dosageList = ['10mg', '20mg', '40mg', '50mg', '100mg'];

  final List<String> frequencyList = [
    'Daily',
    'Weekly',
    'Monthly',
    'Hourly',
    'Custom',
  ];

  final List<String> statusList = ['active', 'inactive'];

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    addFrequencyRow(); // Start with one row
  }

  // Setter functions
  void setDosage(String? value) {
    selectedDosage.value = value ?? '';
  }

  void setStatus(String? value) {
    selectedStatus.value = value ?? 'active';
  }

  void setFrequencyForRow(int index, String? value) {
    if (index >= 0 && index < frequencyRows.length) {
      frequencyRows[index].frequency.value = value ?? '';
    }
  }

  void setAmPmForRow(int index, String? value) {
    if (index >= 0 && index < frequencyRows.length) {
      frequencyRows[index].amPm.value = value ?? 'AM';
    }
  }

  String _convertTo24HourFormat(String time, String amPm) {
    if (time.isEmpty) return time;
    
    String processedTime = time.trim();
    
    // Handle single digit or number without colon (e.g., "10" -> "10:00")
    if (!processedTime.contains(':')) {
      int hour = int.tryParse(processedTime) ?? 0;
      processedTime = '${hour.toString().padLeft(2, '0')}:00';
    }
    
    final parts = processedTime.split(':');
    if (parts.length != 2) return processedTime;
    
    int hour = int.tryParse(parts[0]) ?? 0;
    String minute = parts[1].padLeft(2, '0');
    
    // Convert to 24-hour format based on AM/PM
    if (amPm == 'PM' && hour != 12) {
      hour += 12;
    } else if (amPm == 'AM' && hour == 12) {
      hour = 0;
    }
    
    return '${hour.toString().padLeft(2, '0')}:$minute';
  }

  void addFrequencyRow() {
    frequencyRows.add(MedicineFrequencyInput());
  }

  void removeFrequencyRow(int index) {
    if (frequencyRows.length > 1 &&
        index >= 0 &&
        index < frequencyRows.length) {
      frequencyRows[index].timeController.dispose();
      frequencyRows.removeAt(index);
    }
  }

  Future<void> showImagePickerDialog() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Request permissions
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          Get.snackbar('Permission Denied', 'Camera permission is required');
          return;
        }
      } else {
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          Get.snackbar('Permission Denied', 'Storage permission is required');
          return;
        }
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void clearImage() {
    selectedImage.value = null;
  }

  // Store Medicine
  Future<void> storeMedicine() async {
    // Validation
    if (medNameController.text.trim().isEmpty) {
      _showBottomSnackBar('Please enter medicine name');
      return;
    }

    if (selectedDosage.value.isEmpty) {
      _showBottomSnackBar('Please select dosage');
      return;
    }

    if (frequencyRows.isEmpty) {
      _showBottomSnackBar('Please add at least one frequency');
      return;
    }

    // Validate each frequency row
    for (int i = 0; i < frequencyRows.length; i++) {
      if (frequencyRows[i].frequency.value.isEmpty) {
        _showBottomSnackBar('Please select frequency for row ${i + 1}');
        return;
      }
      if (frequencyRows[i].timeController.text.trim().isEmpty) {
        _showBottomSnackBar('Please enter time for row ${i + 1}');
        return;
      }
    }

    // Build frequencies list
    final frequencies = frequencyRows
        .map((row) => MedicineFrequency(
              frequency: row.frequency.value,
              time: _convertTo24HourFormat(
                  row.timeController.text.trim(), row.amPm.value),
            ))
        .toList();

    // Create request
    final medicineRequest = StoreMedicineRequest(
      medicineName: medNameController.text.trim(),
      dosage: selectedDosage.value,
      status: selectedStatus.value,
      attachment: selectedImage.value,
      frequencies: frequencies,
    );

    // Print payload for debugging
    print('\n🔍 MEDICINE REQUEST PAYLOAD 🔍');
    print('Medicine Name: ${medicineRequest.medicineName}');
    print('Dosage: ${medicineRequest.dosage}');
    print('Status: ${medicineRequest.status}');
    print('Attachment: ${medicineRequest.attachment?.path ?? 'null'}');
    print('Frequencies:');
    for (int i = 0; i < medicineRequest.frequencies.length; i++) {
      print('  [$i] Frequency: ${medicineRequest.frequencies[i].frequency}');
      print('  [$i] Time: ${medicineRequest.frequencies[i].time}');
    }
    print('JSON Payload: ${medicineRequest.toJson()}');
    print('🔍 END PAYLOAD 🔍\n');

    // Show loading
    setLoading(true);

    try {
      // Call API
      final result = await safeApiCall(
          () => _medicineRepository.storeMedicine(medicineRequest));

      if (result != null) {
        // _showBottomSnackBar('Medicine added successfully!', isSuccess: true);
        _clearAllFields();
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      }
    } finally {
      setLoading(false);
    }
  }

  // Get Medicine Details
  Future<Map<String, dynamic>?> getMedicineDetails(int medicineId) async {
    try {
      final result = await safeApiCall(
          () => _medicineRepository.getMedicineDetails(medicineId));
      return result;
    } catch (e) {
      _showBottomSnackBar('Failed to load medicine details');
      return null;
    }
  }

  // Update Medicine
  Future<void> updateMedicine(int medicineId) async {
    // Validation
    if (medNameController.text.trim().isEmpty) {
      _showBottomSnackBar('Please enter medicine name');
      return;
    }

    if (selectedDosage.value.isEmpty) {
      _showBottomSnackBar('Please select dosage');
      return;
    }

    if (frequencyRows.isEmpty) {
      _showBottomSnackBar('Please add at least one frequency');
      return;
    }

    // Validate each frequency row
    for (int i = 0; i < frequencyRows.length; i++) {
      if (frequencyRows[i].frequency.value.isEmpty) {
        _showBottomSnackBar('Please select frequency for row ${i + 1}');
        return;
      }
      if (frequencyRows[i].timeController.text.trim().isEmpty) {
        _showBottomSnackBar('Please enter time for row ${i + 1}');
        return;
      }
    }

    // Build frequencies list
    final frequencies = frequencyRows
        .map((row) => MedicineFrequency(
              frequency: row.frequency.value,
              time: _convertTo24HourFormat(
                  row.timeController.text.trim(), row.amPm.value),
            ))
        .toList();

    // Create request
    final updateRequest = UpdateMedicineRequest(
      id: medicineId,
      medicineName: medNameController.text.trim(),
      dosage: selectedDosage.value,
      status: selectedStatus.value,
      attachment: selectedImage.value,
      frequencies: frequencies,
    );

    // Show loading
    setLoading(true);

    try {
      // Call API
      final result = await safeApiCall(
          () => _medicineRepository.updateMedicine(updateRequest));

      if (result != null) {
        _showBottomSnackBar('Medicine updated successfully!', isSuccess: true);
        _clearAllFields();
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      }
    } finally {
      setLoading(false);
    }
  }

  void _showBottomSnackBar(String message, {bool isSuccess = false}) {
    final overlay = Overlay.of(Get.context!);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSuccess ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 1200), () {
      overlayEntry.remove();
    });
  }

  void _clearAllFields() {
    medNameController.clear();
    dosageController.clear();
    selectedDosage.value = '';
    selectedStatus.value = 'active';
    // Clear frequency rows
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    frequencyRows.clear();
    addFrequencyRow(); // Add one empty row
    selectedImage.value = null;
  }

  @override
  void onClose() {
    _clearAllFields();
    medNameController.dispose();
    dosageController.dispose();
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    super.onClose();
  }
}
