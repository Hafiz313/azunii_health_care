import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/Medicine_model.dart';
import '../../../../core/repositories/Medicine_repo.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';

class MedicineFrequencyInput {
  final RxString frequency = RxString('');
  final TextEditingController timeController = TextEditingController();
  final RxString amPm = RxString('AM');

  MedicineFrequencyInput();
}

class MedicineController extends BaseController {
  final MedicineRepository _medicineRepository = MedicineRepository();

  // Search autocomplete state
  final RxList<String> medicineSearchResults = <String>[].obs;
  final RxBool isSearchingMedicine = false.obs;
  Timer? _searchDebounceTimer;

  // Text Controllers
  final TextEditingController medNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Observable variables
  final RxString selectedDosage = RxString('');
  final RxString selectedStatus = RxString('active');
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString existingImageUrl = RxString('');
  final RxInt editingMedicineId = RxInt(0);
  final RxBool isEditMode = RxBool(false);

  // Frequency type: 'scheduled' or 'unscheduled'
  final RxString frequencyType = RxString('scheduled');

  // Frequency management
  final RxList<MedicineFrequencyInput> frequencyRows =
      RxList<MedicineFrequencyInput>([]);

  // Dropdown lists
  final List<String> dosageList = ['10mg', '20mg', '40mg', '50mg', '100mg'];

  // Dynamic frequency list based on date range duration
  List<String> get availableFrequencies {
    final start = _parseDate(startDateController.text.trim());
    final end = _parseDate(endDateController.text.trim());

    // If either date is missing, show all options
    if (start == null || end == null) {
      return ['Daily', 'Every other day', 'Weekly', 'Monthly'];
    }

    final days = end.difference(start).inDays;

    // 0-1 days: Only Daily
    if (days < 2) {
      return ['Daily'];
    }
    // 2-6 days: Daily + Every other day
    else if (days < 7) {
      return ['Daily', 'Every other day'];
    }
    // 7-29 days: Daily + Every other day + Weekly
    else if (days < 30) {
      return ['Daily', 'Every other day', 'Weekly'];
    }
    // 30+ days: All options
    else {
      return ['Daily', 'Every other day', 'Weekly', 'Monthly'];
    }
  }

  // Keep a static reference for backward compatibility
  List<String> get frequencyList => availableFrequencies;

  final List<String> statusList = ['active', 'inactive'];

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Start with scheduled type and one frequency row
    if (frequencyRows.isEmpty) {
      addFrequencyRow();
    }

    // Listen to frequency type changes to ensure proper setup
    ever(frequencyType, (type) {
      if (type == 'unscheduled' && frequencyRows.isEmpty) {
        final row = MedicineFrequencyInput();
        row.frequency.value = 'as_per_needed';
        row.timeController.text = '00:00';
        frequencyRows.add(row);
      }
    });
  }

  // Set frequency type (scheduled/unscheduled)
  void setFrequencyType(String type) {
    print('🔄 Setting frequency type to: $type');
    frequencyType.value = type;
    if (type == 'unscheduled') {
      // Clear end date immediately — it must NOT persist or be sent to API
      endDateController.clear();
      // Clear all frequency rows and set single 'as_per_needed'
      for (var row in frequencyRows) {
        row.timeController.dispose();
      }
      frequencyRows.clear();
      final row = MedicineFrequencyInput();
      row.frequency.value = 'as_per_needed';
      row.timeController.text = '00:00'; // Dummy time for unscheduled
      frequencyRows.add(row);
      frequencyRows.refresh(); // Force UI update
      print('✅ Set unscheduled with as_per_needed frequency');
      print('📋 Frequency rows count: ${frequencyRows.length}');
      if (frequencyRows.isNotEmpty) {
        print('📋 First row frequency: ${frequencyRows[0].frequency.value}');
        print('📋 First row time: ${frequencyRows[0].timeController.text}');
      }
    } else {
      // Reset to scheduled with one empty row
      for (var row in frequencyRows) {
        row.timeController.dispose();
      }
      frequencyRows.clear();
      addFrequencyRow();
      print('✅ Set scheduled with empty frequency row');
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

  // Check if a specific time is already used by another row with given frequency
  bool isTimeAlreadyUsed(int currentIndex, String time) {
    if (time.trim().isEmpty) return false;
    for (int i = 0; i < frequencyRows.length; i++) {
      if (i == currentIndex) continue;
      if (frequencyRows[i].timeController.text.trim() == time.trim()) {
        return true;
      }
    }
    return false;
  }

  // Parse date string (yyyy-MM-dd) to DateTime
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  // Check for duplicate frequency + time combinations
  bool _hasDuplicateFrequency() {
    for (int i = 0; i < frequencyRows.length; i++) {
      for (int j = i + 1; j < frequencyRows.length; j++) {
        if (frequencyRows[i].frequency.value ==
                frequencyRows[j].frequency.value &&
            frequencyRows[i].timeController.text.trim() ==
                frequencyRows[j].timeController.text.trim() &&
            frequencyRows[i].frequency.value.isNotEmpty &&
            frequencyRows[i].timeController.text.trim().isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  // Clear selected frequencies that are no longer valid for current date range
  void recalculateFrequencies() {
    final available = availableFrequencies;
    for (var row in frequencyRows) {
      if (row.frequency.value.isNotEmpty &&
          !available.contains(row.frequency.value)) {
        row.frequency.value = '';
      }
    }
    frequencyRows.refresh();
  }

  void removeFrequencyRow(int index) {
    if (frequencyRows.length > 1 &&
        index >= 0 &&
        index < frequencyRows.length) {
      frequencyRows[index].timeController.dispose();
      frequencyRows.removeAt(index);
    }
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
            CustomSnackbar.show(
                'Camera permission permanently denied. Please enable it in app settings.',
                isSuccess: false);
            await openAppSettings();
          } else {
            CustomSnackbar.show('Camera permission is required',
                isSuccess: false);
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
            CustomSnackbar.show(
                'Gallery permission permanently denied. Please enable it in app settings.',
                isSuccess: false);
            await openAppSettings();
          } else {
            CustomSnackbar.show('Gallery permission is required',
                isSuccess: false);
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
      CustomSnackbar.show('Failed to pick image: $e', isSuccess: false);
    }
  }

  void clearImage() {
    selectedFile.value = null;
    existingImageUrl.value = '';
  }

  // Load medicine data for editing
  void loadMedicineData(Medicine medicine) {
    debugPrint('📊 Loading medicine data for editing');
    debugPrint('📸 Medicine attachment: ${medicine.attachment}');

    isEditMode.value = true;
    editingMedicineId.value = medicine.id;

    // Populate form fields
    medNameController.text = medicine.medicineName;
    selectedDosage.value = medicine.dosage;
    selectedStatus.value = medicine.status;

    // Load dates
    if (medicine.startDate != null && medicine.startDate!.isNotEmpty) {
      startDateController.text = medicine.startDate!;
    }
    if (medicine.endDate != null && medicine.endDate!.isNotEmpty) {
      endDateController.text = medicine.endDate!;
    }

    // Load existing image URL if available
    if (medicine.attachment != null && medicine.attachment!.isNotEmpty) {
      existingImageUrl.value = medicine.attachment!;
      selectedFile.value = null;
      debugPrint('✅ Existing attachment URL set: ${existingImageUrl.value}');
    } else {
      debugPrint('⚠️ No attachment found');
    }

    // Clear existing frequency rows
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    frequencyRows.clear();

    // Determine frequency type and load frequencies
    if (medicine.frequencies.isNotEmpty &&
        medicine.frequencies[0].frequency == 'as_per_needed') {
      // Unscheduled type — add the row BEFORE setting frequencyType
      // to prevent the ever() listener from adding a duplicate row
      final row = MedicineFrequencyInput();
      row.frequency.value = 'as_per_needed';
      row.timeController.text = '00:00';
      frequencyRows.add(row);
      frequencyType.value = 'unscheduled';
    } else {
      // Scheduled type
      frequencyType.value = 'scheduled';
      for (var freq in medicine.frequencies) {
        final row = MedicineFrequencyInput();
        row.frequency.value = freq.frequency;
        // Strip seconds from time (19:05:00 -> 19:05)
        final time = freq.time.split(':');
        row.timeController.text =
            time.length >= 2 ? '${time[0]}:${time[1]}' : freq.time;
        frequencyRows.add(row);
      }
    }

    // Ensure at least one row for scheduled
    if (frequencyRows.isEmpty) {
      addFrequencyRow();
    }
  }

  // Store or Update Medicine with date validation
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

    // Validate start date (required)
    if (startDateController.text.trim().isEmpty) {
      _showBottomSnackBar('Please select start date');
      return;
    }

    // For scheduled, validate end date and frequencies
    if (frequencyType.value == 'scheduled') {
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

      // Block duplicate frequency + time combinations
      if (_hasDuplicateFrequency()) {
        _showBottomSnackBar(
            'Duplicate frequency and time combination is not allowed');
        return;
      }

      // Validate end date is not before start date
      if (endDateController.text.trim().isNotEmpty) {
        final startDate = _parseDate(startDateController.text.trim());
        final endDate = _parseDate(endDateController.text.trim());
        if (startDate != null &&
            endDate != null &&
            endDate.isBefore(startDate)) {
          _showBottomSnackBar('End date cannot be before start date');
          return;
        }
      }
    } else {
      // For unscheduled, ensure we have the as_per_needed frequency
      if (frequencyRows.isEmpty) {
        print('⚠️ No frequency rows for unscheduled, creating one');
        final row = MedicineFrequencyInput();
        row.frequency.value = 'as_per_needed';
        row.timeController.text = '00:00';
        frequencyRows.add(row);
      }
    }

    // Debug: Log frequency rows before building (storeMedicine)
    print('🔍 STORE DEBUG: About to build frequencies');
    print('🔍 Frequency Type: ${frequencyType.value}');
    print('🔍 Frequency Rows Count: ${frequencyRows.length}');
    for (int i = 0; i < frequencyRows.length; i++) {
      print(
          '🔍 Row $i - Frequency Value: "${frequencyRows[i].frequency.value}"');
      print('🔍 Row $i - Time: "${frequencyRows[i].timeController.text}"');
    }

    // Build frequencies list
    final frequencies = frequencyRows.map((row) {
      // For unscheduled, ensure frequency is 'as_per_needed'
      String freqValue = row.frequency.value;
      if (frequencyType.value == 'unscheduled' && freqValue.isEmpty) {
        freqValue = 'as_per_needed';
      }
      return MedicineFrequency(
        frequency: freqValue,
        time: row.timeController.text.trim(),
      );
    }).toList();

    // Force clear end date for unscheduled — never send it to API
    final String? endDateValue = frequencyType.value == 'unscheduled'
        ? null
        : (endDateController.text.trim().isEmpty
            ? null
            : endDateController.text.trim());

    // Create request with dates
    final medicineRequest = StoreMedicineRequest(
      medicineName: medNameController.text.trim(),
      dosage: selectedDosage.value,
      status: selectedStatus.value,
      startDate: startDateController.text.trim(),
      endDate: endDateValue,
      attachment: selectedFile.value,
      frequencies: frequencies,
    );

    // Debug payload
    debugPrint('\n🔍 MEDICINE REQUEST PAYLOAD 🔍');
    debugPrint('Medicine Name: ${medicineRequest.medicineName}');
    debugPrint('Dosage: ${medicineRequest.dosage}');
    debugPrint('Status: ${medicineRequest.status}');
    debugPrint('Start Date: ${medicineRequest.startDate}');
    debugPrint('End Date: ${medicineRequest.endDate ?? "null"}');
    debugPrint('Frequency Type: ${frequencyType.value}');
    debugPrint('Attachment: ${medicineRequest.attachment?.path ?? 'null'}');
    debugPrint('Frequencies:');
    for (int i = 0; i < medicineRequest.frequencies.length; i++) {
      debugPrint(
          '  [$i] Frequency: ${medicineRequest.frequencies[i].frequency}');
      debugPrint('  [$i] Time: ${medicineRequest.frequencies[i].time}');
    }
    debugPrint('🔍 END PAYLOAD 🔍\n');

    // Show loading
    setLoading(true);

    try {
      final result = await safeApiCall(
          () => _medicineRepository.storeMedicine(medicineRequest));

      if (result != null) {
        _showBottomSnackBar('Medicine added successfully!', isSuccess: true);
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

  // Update Medicine with date fields
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

    // Validate start date (required)
    if (startDateController.text.trim().isEmpty) {
      _showBottomSnackBar('Please select start date');
      return;
    }

    // For scheduled, validate frequencies
    if (frequencyType.value == 'scheduled') {
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

      // Block duplicate frequency + time combinations
      if (_hasDuplicateFrequency()) {
        _showBottomSnackBar(
            'Duplicate frequency and time combination is not allowed');
        return;
      }

      // Validate end date is not before start date
      if (endDateController.text.trim().isNotEmpty) {
        final startDate = _parseDate(startDateController.text.trim());
        final endDate = _parseDate(endDateController.text.trim());
        if (startDate != null &&
            endDate != null &&
            endDate.isBefore(startDate)) {
          _showBottomSnackBar('End date cannot be before start date');
          return;
        }
      }
    } else {
      // For unscheduled, ensure we have the as_per_needed frequency
      if (frequencyRows.isEmpty) {
        print('⚠️ No frequency rows for unscheduled, creating one');
        final row = MedicineFrequencyInput();
        row.frequency.value = 'as_per_needed';
        row.timeController.text = '00:00';
        frequencyRows.add(row);
      }
    }

    // Debug: Log frequency rows before building (updateMedicine)
    print('🔍 UPDATE DEBUG: About to build frequencies');
    print('🔍 Frequency Type: ${frequencyType.value}');
    print('🔍 Frequency Rows Count: ${frequencyRows.length}');
    for (int i = 0; i < frequencyRows.length; i++) {
      print(
          '🔍 Row $i - Frequency Value: "${frequencyRows[i].frequency.value}"');
      print('🔍 Row $i - Time: "${frequencyRows[i].timeController.text}"');
    }

    // Build frequencies list
    final frequencies = frequencyRows.map((row) {
      // For unscheduled, ensure frequency is 'as_per_needed'
      String freqValue = row.frequency.value;
      if (frequencyType.value == 'unscheduled' && freqValue.isEmpty) {
        freqValue = 'as_per_needed';
      }
      return MedicineFrequency(
        frequency: freqValue,
        time: row.timeController.text.trim(),
      );
    }).toList();

    // Force clear end date for unscheduled — never send it to API
    final String? updateEndDateValue = frequencyType.value == 'unscheduled'
        ? null
        : (endDateController.text.trim().isEmpty
            ? null
            : endDateController.text.trim());

    // Create request with dates
    final updateRequest = UpdateMedicineRequest(
      id: medicineId,
      medicineName: medNameController.text.trim(),
      dosage: selectedDosage.value,
      status: selectedStatus.value,
      startDate: startDateController.text.trim(),
      endDate: updateEndDateValue,
      attachment: selectedFile.value,
      frequencies: frequencies,
    );
    debugPrint('update request is ${updateRequest.toJson()}');

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
    startDateController.clear();
    endDateController.clear();
    selectedDosage.value = '';
    selectedStatus.value = 'active';
    frequencyType.value = 'scheduled';
    isEditMode.value = false;
    editingMedicineId.value = 0;
    // Clear frequency rows
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    frequencyRows.clear();
    addFrequencyRow(); // Add one empty row
    selectedFile.value = null;
    existingImageUrl.value = '';
  }

  void searchMedicine(String query) {
    if (_searchDebounceTimer?.isActive ?? false) _searchDebounceTimer!.cancel();

    if (query.trim().length < 2) {
      medicineSearchResults.clear();
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      isSearchingMedicine.value = true;
      try {
        final results = await _medicineRepository.searchMedicineNames(query.trim());
        medicineSearchResults.value = results;
      } catch (e) {
        debugPrint('Error searching medicine: $e');
      } finally {
        isSearchingMedicine.value = false;
      }
    });
  }

  @override
  void onClose() {
    _clearAllFields();
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer!.cancel();
    }
    medNameController.dispose();
    dosageController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    for (var row in frequencyRows) {
      row.timeController.dispose();
    }
    super.onClose();
  }
}
