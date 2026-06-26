import 'dart:io';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/visit_model.dart';
import '../../../../core/repositories/visits_repo.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../core/models/specialty_model.dart';
import '../../../../core/services/local_storage_service.dart';

class VisitsController extends BaseController {
  final VisitsRepository _VisitsRepository = VisitsRepository();
  bool _isDisposed = false;
  final TextEditingController providerNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final RxString selectedSpecialty = RxString('');
  final RxString selectedCategory = RxString('');
  final RxString selectedSpecialtyName = RxString('');
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString existingImageUrl = RxString('');
  final RxInt editingVisitId = RxInt(0);
  final RxBool isEditMode = RxBool(false);
  final RxnInt selectedSpecialityId = RxnInt(null);

  final RxList<SpecialtyModel> specialities = <SpecialtyModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<String> namesForCategory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSpecialties();
  }

  Future<void> fetchSpecialties() async {
    try {
      final cachedStr = await LocalStorageService.getCachedDoctorSpecialties();
      if (cachedStr != null) {
        final List<dynamic> jsonList = jsonDecode(cachedStr);
        specialities.value =
            jsonList.map((e) => SpecialtyModel.fromJson(e)).toList();
      } else {
        final data = await _VisitsRepository.getSpecialties();
        if (data.isNotEmpty) {
          await LocalStorageService.saveDoctorSpecialties(jsonEncode(data));
          specialities.value =
              data.map((e) => SpecialtyModel.fromJson(e)).toList();
        }
      }

      // Update categories list
      final Set<String> cats = {};
      for (var s in specialities) {
        if (s.category.isNotEmpty) cats.add(s.category);
      }
      categories.value = cats.toList();
    } catch (e) {
      debugPrint('Error fetching specialties: $e');
    }
  }

  void setCategory(String? category) {
    selectedCategory.value = category ?? '';
    selectedSpecialtyName.value = '';
    selectedSpecialty.value = '';

    if (selectedCategory.value.isNotEmpty) {
      namesForCategory.value = specialities
          .where((s) => s.category == selectedCategory.value)
          .map((s) => s.name)
          .toList();
    } else {
      namesForCategory.clear();
    }
  }

  void setSpecialtyName(String? name) {
    selectedSpecialtyName.value = name ?? '';
    final spec = specialities.firstWhereOrNull((s) => s.name == name);
    if (spec != null) {
      selectedSpecialty.value = spec
          .description; // We pass the description "as is going right now" (e.g., Cardiologist)
      selectedSpecialityId.value = spec.id;
    } else {
      selectedSpecialty.value = name ?? ''; // Fallback
      selectedSpecialityId.value = null;
    }
  }

  final ImagePicker _picker = ImagePicker();

  void setSpecialty(String? value) {
    selectedSpecialty.value = value ?? '';
  }

  void setDate(DateTime? date) {
    selectedDate.value = date;
  }

  Future<void> showFilePickerOptions() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Photo'),
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
      // Request appropriate permission
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            Get.snackbar('Permission Denied',
                'Camera permission permanently denied. Please enable it in app settings.');
            await openAppSettings();
          } else {
            Get.snackbar('Permission Denied', 'Camera permission is required');
          }
          return;
        }
      } else {
        // On Android 13+ (API 33), Permission.storage is ignored.
        // Use Permission.photos instead.
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            status = await Permission.photos.request();
          } else {
            status = await Permission.storage.request();
          }
        } else {
          status = await Permission.photos.request();
        }

        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            Get.snackbar('Permission Denied',
                'Gallery permission permanently denied. Please enable it in app settings.');
            await openAppSettings();
          } else {
            Get.snackbar('Permission Denied', 'Gallery permission is required');
          }
          return;
        }
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedFile.value = File(image.path);
        existingImageUrl.value =
            ''; // Clear existing URL when new image is selected
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void clearImage() {
    selectedFile.value = null;
    existingImageUrl.value = '';
  }

  // Load visit data for editing
  void loadVisitData(VisitModel visit) {
    print('📊 Loading visit data for editing');
    print('📸 Visit attachment: ${visit.attachment}');

    isEditMode.value = true;
    editingVisitId.value = visit.id;

    // Populate form fields
    providerNameController.text = visit.providerName;
    selectedSpecialty.value = visit.specialty;
    notesController.text = visit.notes;

    // Find name and category from description (if loaded)
    if (specialities.isNotEmpty) {
      final spec = specialities.firstWhereOrNull((s) =>
          s.description == visit.specialty || s.name == visit.specialty);
      if (spec != null) {
        selectedCategory.value = spec.category;
        namesForCategory.value = specialities
            .where((s) => s.category == spec.category)
            .map((self) => self.name)
            .toList();
        selectedSpecialtyName.value = spec.name;
        selectedSpecialityId.value = spec.id;
      } else {
        selectedCategory.value = '';
        selectedSpecialtyName.value = visit.specialty;
        selectedSpecialityId.value = null;
      }
    } else {
      selectedCategory.value = '';
      selectedSpecialtyName.value = visit.specialty;
      selectedSpecialityId.value = null;
    }

    // Parse visit date
    try {
      selectedDate.value = DateTime.parse(visit.visitDate);
    } catch (e) {
      selectedDate.value = null;
    }

    // Load existing image URL if available
    if (visit.attachment != null && visit.attachment!.isNotEmpty) {
      existingImageUrl.value = visit.attachment!;
      selectedFile.value = null; // Clear local file since we have network image
      print('✅ Existing attachment URL set: ${existingImageUrl.value}');
    } else {
      print('⚠️ No attachment found');
    }
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
      attachment: selectedFile.value,
      specialityId: selectedSpecialityId.value,
    );

    // Call API using safeApiCall
    final result =
        await safeApiCall(() => _VisitsRepository.updateVisit(updateRequest));

    if (result != null) {
      // Navigate back first, then show snackbar
      // Using Navigator.pop to avoid Get.back() closing the snackbar overlay
      if (Get.isRegistered<VisitsController>()) {
        clearAllFields();
        Get.back();
      }

      // Show success snackbar after navigation
      _showBottomSnackBar('Visit updated successfully!', isSuccess: true);
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
      attachment: selectedFile.value,
      specialityId: selectedSpecialityId.value,
    );

    // Call API using safeApiCall
    final result =
        await safeApiCall(() => _VisitsRepository.storeVisit(visitRequest));

    if (result != null) {
      _showBottomSnackBar('Visit saved successfully!', isSuccess: true);
    }

    // Always clear fields after API call (success or failure)
    // This screen lives in a PageView, so no Get.back()
    clearAllFields();
  }

  void _showBottomSnackBar(String message, {bool isSuccess = false}) {
    CustomSnackbar.show(message, isSuccess: isSuccess);
  }

  void clearAllFields() {
    if (_isDisposed) return; // Guard against use after dispose
    try {
      providerNameController.clear();
      notesController.clear();
    } catch (_) {
      // TextEditingControllers may already be disposed
    }
    selectedSpecialty.value = '';
    selectedCategory.value = '';
    selectedSpecialtyName.value = '';
    namesForCategory.clear();
    selectedDate.value = null;
    selectedFile.value = null;
    existingImageUrl.value = '';
    isEditMode.value = false;
    editingVisitId.value = 0;
    selectedSpecialityId.value = null;
  }

  @override
  void onClose() {
    _isDisposed = true;
    providerNameController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
