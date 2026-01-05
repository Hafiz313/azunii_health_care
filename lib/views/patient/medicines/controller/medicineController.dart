import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/Medicine_model.dart';
import '../../../../core/repositories/Medicine_repo.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';

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
  final RxString existingImageUrl = RxString('');
  final RxInt editingMedicineId = RxInt(0);
  final RxBool isEditMode = RxBool(false);

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
    if (frequencyRows.isEmpty) {
      addFrequencyRow(); // Start with one row
    }
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
          CustomSnackbar.show('Camera permission is required', isSuccess: false);
          return;
        }
      } else {
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          CustomSnackbar.show('Storage permission is required', isSuccess: false);
          return;
        }
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
        existingImageUrl.value = ''; // Clear existing URL when new image is selected
      }
    } catch (e) {
      CustomSnackbar.show('Failed to pick image: $e', isSuccess: false);
    }
  }

  void clearImage() {
    selectedImage.value = null;
    existingImageUrl.value = '';
  }

  // Load medicine data for editing
  void loadMedicineData(Medicine medicine) {
    isEditMode.value = true;
    editingMedicineId.value = medicine.id;

    // Populate form fields
    medNameController.text = medicine.medicineName;
    selectedDosage.value = medicine.dosage;
    selectedStatus.value = medicine.status;
    
    // Load existing image URL if available
    if (medicine.attachment != null && medicine.attachment!.isNotEmpty) {
      existingImageUrl.value = medicine.attachment!;
      selectedImage.value = null; // Clear local file since we have network image
    }

    // Clear existing frequency rows
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    frequencyRows.clear();

    // Load frequencies
    for (var freq in medicine.frequencies) {
      final row = MedicineFrequencyInput();
      row.frequency.value = freq.frequency;
      // Strip seconds from time (19:05:00 -> 19:05)
      final time = freq.time.split(':');
      row.timeController.text =
          time.length >= 2 ? '${time[0]}:${time[1]}' : freq.time;
      frequencyRows.add(row);
    }

    // Ensure at least one row
    if (frequencyRows.isEmpty) {
      addFrequencyRow();
    }
  }

  // Store or Update Medicine
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
              time: row.timeController.text.trim(),
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
      final result;
      // if (isEditMode.value) {
      //   print('🔄 UPDATE MODE DETECTED');
      //   print('🆔 Editing Medicine ID: ${editingMedicineId.value}');
      //   // Update existing medicine
      //   final updateRequest = UpdateMedicineRequest(
      //     id: editingMedicineId.value,
      //     medicineName: medicineRequest.medicineName,
      //     dosage: medicineRequest.dosage,
      //     status: medicineRequest.status,
      //     attachment: medicineRequest.attachment,
      //     frequencies: medicineRequest.frequencies,
      //   );
      //   print('📤 Calling updateMedicine API...');
      //   result = await safeApiCall(() => _medicineRepository.updateMedicine(
      //       updateRequest, editingMedicineId.value));
      //   print('📥 Update API Response: $result');
      // }
      //else {
      // Create new medicine
      result = await safeApiCall(
          () => _medicineRepository.storeMedicine(medicineRequest));
      // }

      if (result != null) {
        _showBottomSnackBar(
            // isEditMode.value
            //     ? 'Medicine updated successfully!'
            //:
            'Medicine added successfully!',
            isSuccess: true);
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
              time: row.timeController.text.trim(),
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
    print('update request is ${updateRequest.toJson()}');

    // Show loading
    setLoading(true);

    try {
      // Call API
      final result = await safeApiCall(
          () => _medicineRepository.updateMedicine(updateRequest, medicineId));

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
    isEditMode.value = false;
    editingMedicineId.value = 0;
    // Clear frequency rows
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    frequencyRows.clear();
    addFrequencyRow(); // Add one empty row
    selectedImage.value = null;
    existingImageUrl.value = '';
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
