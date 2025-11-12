import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MedicineController extends GetxController {
  // Text Controllers
  final TextEditingController medNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  // Observable variables
  final RxString selectedDosage = RxString('');
  final RxString selectedFrequency = RxString('');
  final RxString selectedStatus = RxString('');
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Dropdown lists
  final List<String> dosageList = [
    '10mg',
    '20mg',
    '40mg',
    '50mg',
    '100mg'
  ];

  final List<String> frequencyList = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'As needed',
  ];

  final List<String> statusList = [
    'Active',
    'Inactive',
    'Paused',
    'Completed'
  ];

  final ImagePicker _picker = ImagePicker();

  // Setter functions
  void setDosage(String? value) {
    selectedDosage.value = value ?? '';
  }

  void setFrequency(String? value) {
    selectedFrequency.value = value ?? '';
  }

  void setStatus(String? value) {
    selectedStatus.value = value ?? '';
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

  @override
  void onClose() {
    medNameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    super.onClose();
  }
}