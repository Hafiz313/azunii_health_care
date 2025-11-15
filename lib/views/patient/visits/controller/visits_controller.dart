import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class VisitsController extends GetxController {
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

  void saveVisit() {
    if (providerNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter provider name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (selectedSpecialty.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a specialty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Visit saved successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    providerNameController.dispose();
    notesController.dispose();
    super.onClose();
  }
}