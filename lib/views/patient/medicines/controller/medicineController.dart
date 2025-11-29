import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/Medicine_model.dart';
import '../../../../core/repositories/Medicine_repo.dart';

class MedicineController extends BaseController {
  final MedicineRepository _medicineRepository = MedicineRepository();
  // Text Controllers
  final TextEditingController medNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  // Observable variables
  final RxString selectedDosage = RxString('');
  final RxString selectedStatus = RxString('Active');
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Frequency management
  final RxList<MedicineFrequency> frequencies = RxList<MedicineFrequency>([]);
  final RxString selectedFrequency = RxString('Once daily');
  final RxString selectedTime = RxString('08:00');

  // Dropdown lists
  final List<String> dosageList = ['10mg', '20mg', '40mg', '50mg', '100mg'];

  final List<String> frequencyList = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'As needed',
  ];

  final List<String> statusList = ['Active', 'Inactive', 'Paused', 'Completed'];

  final ImagePicker _picker = ImagePicker();

  // Setter functions
  void setDosage(String? value) {
    selectedDosage.value = value ?? '';
  }

  void setFrequency(String? value) {
    selectedFrequency.value = value ?? 'Once daily';
  }

  void setTime(String? value) {
    selectedTime.value = value ?? '08:00';
  }

  void setStatus(String? value) {
    selectedStatus.value = value ?? 'Active';
  }

  void addFrequency() {
    final frequency = MedicineFrequency(
      frequency: selectedFrequency.value,
      time: selectedTime.value,
    );
    frequencies.add(frequency);
  }

  void removeFrequency(int index) {
    if (index >= 0 && index < frequencies.length) {
      frequencies.removeAt(index);
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

    if (frequencies.isEmpty) {
      _showBottomSnackBar('Please add at least one frequency');
      return;
    }

    // Create request
    final medicineRequest = StoreMedicineRequest(
      medicineName: medNameController.text.trim(),
      dosage: selectedDosage.value,
      status: selectedStatus.value.toLowerCase(),
      attachment: selectedImage.value,
      frequencies: frequencies,
    );

    // Call API
    final result = await safeApiCall(
        () => _medicineRepository.storeMedicine(medicineRequest));

    if (result != null) {
      _showBottomSnackBar('Medicine added successfully!', isSuccess: true);
      _clearAllFields();
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
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

    if (frequencies.isEmpty) {
      _showBottomSnackBar('Please add at least one frequency');
      return;
    }

    // Create request
    final updateRequest = UpdateMedicineRequest(
      id: medicineId,
      medicineName: medNameController.text.trim(),
      dosage: selectedDosage.value,
      status: selectedStatus.value.toLowerCase(),
      attachment: selectedImage.value,
      frequencies: frequencies,
    );

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
  }

  void _showBottomSnackBar(String message, {bool isSuccess = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  void _clearAllFields() {
    medNameController.clear();
    dosageController.clear();
    selectedDosage.value = '';
    selectedStatus.value = 'Active';
    selectedFrequency.value = 'Once daily';
    selectedTime.value = '08:00';
    frequencies.clear();
    selectedImage.value = null;
  }

  @override
  void onClose() {
    _clearAllFields();
    medNameController.dispose();
    dosageController.dispose();
    super.onClose();
  }
}
