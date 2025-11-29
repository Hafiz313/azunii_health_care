import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/visit_model.dart';
import '../../../../core/repositories/visits_repo.dart';
import 'package:intl/intl.dart';

class VisitsController extends BaseController {
  final VisitsRepository _VisitsRepository = VisitsRepository();
  final TextEditingController providerNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final RxString selectedSpecialty = RxString('');
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<File?> selectedImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  void setSpecialty(String? value) {
    selectedSpecialty.value = value ?? '';
  }

  void setDate(DateTime? date) {
    selectedDate.value = date;
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

  Future<void> updateVisit(int visitId) async {
    // Validation with simple bottom snackbar
    if (providerNameController.text.trim().isEmpty) {
      _showBottomSnackBar('Please enter provider name');
      return;
    }

    if (selectedSpecialty.value.isEmpty) {
      _showBottomSnackBar('Please select a specialty');
      return;
    }

    if (selectedDate.value == null) {
      _showBottomSnackBar('Please select a visit date');
      return;
    }

    // Format date as required: 2025-11-29 10:59:29
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate.value!);

    // Create update request
    final updateRequest = UpdateVisitRequest(
      id: visitId,
      providerName: providerNameController.text.trim(),
      specialty: selectedSpecialty.value,
      visitDate: formattedDate,
      notes: notesController.text.trim(),
      attachment: selectedImage.value,
    );

    // Call API using safeApiCall
    final result =
        await safeApiCall(() => _VisitsRepository.updateVisit(updateRequest));

    if (result != null) {
      _showBottomSnackBar('Visit updated successfully!', isSuccess: true);

      // Clear all fields immediately after success
      _clearAllFields();

      // Close screen after delay
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    }
  }

  Future<void> saveVisit() async {
    // Validation with simple bottom snackbar
    if (providerNameController.text.trim().isEmpty) {
      _showBottomSnackBar('Please enter provider name');
      return;
    }

    if (selectedSpecialty.value.isEmpty) {
      _showBottomSnackBar('Please select a specialty');
      return;
    }

    if (selectedDate.value == null) {
      _showBottomSnackBar('Please select a visit date');
      return;
    }

    // Format date as required: 2025-11-29 10:59:29
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate.value!);

    // Create visit request
    final visitRequest = StoreVisitRequest(
      providerName: providerNameController.text.trim(),
      specialty: selectedSpecialty.value,
      visitDate: formattedDate,
      notes: notesController.text.trim(),
      attachment: selectedImage.value,
    );

    // Call API using safeApiCall
    final result =
        await safeApiCall(() => _VisitsRepository.storeVisit(visitRequest));

    if (result != null) {
      _showBottomSnackBar('Visit saved successfully!', isSuccess: true);

      // Clear all fields immediately after success
      _clearAllFields();

      // Close after delay
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
    providerNameController.clear();
    notesController.clear();
    selectedSpecialty.value = '';
    selectedDate.value = null;
    selectedImage.value = null;
  }

  @override
  void onClose() {
    _clearAllFields();
    providerNameController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
