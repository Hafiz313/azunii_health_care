import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/core/models/Medicine_model.dart';
import 'package:Azunii_Health/core/models/visit_model.dart';
import 'package:Azunii_Health/utils/DateForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsDialogs {
  static void showVisitDetailsDialog(
    VisitModel visit, {
    required Function(int) onEdit,
    required Function(String) onImagePreview,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Visit Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headingTextColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Provider', visit.providerName),
                _buildDetailRow('Specialty', visit.specialty),
                _buildDetailRow('Visit Date', formatDate(visit.visitDate)),
                _buildDetailRow('Notes', visit.notes),
                if (visit.createdBy != null)
                  _buildDetailRow('Created By', visit.createdBy!.name),
                if (visit.updatedBy != null)
                  _buildDetailRow('Updated By', visit.updatedBy!.name),
                _buildDetailRow('Created At', formatDate(visit.createdAt)),
                _buildDetailRow('Updated At', formatDate(visit.updatedAt)),
                if (visit.attachment != null &&
                    visit.attachment!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Attachment:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => onImagePreview(visit.attachment!),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.dividerGray),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          visit.attachment!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.cardGray,
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textColor,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to preview',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onEdit(visit.id.toInt());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showMedicineDetailsDialog(
    Medicine medicine, {
    required Function(int) onEdit,
    required Function(String) onImagePreview,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medicine Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headingTextColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Name', medicine.medicineName),
                _buildDetailRow('Dosage', medicine.dosage),
                _buildDetailRow('Status', medicine.status),
                // _buildDetailRow('Interaction Flag', medicine.interactionFlag),
                if (medicine.interactionMessage != null)
                  _buildDetailRow(
                      'Interaction Message', medicine.interactionMessage!),
                if (medicine.interactionDetails != null)
                  // _buildDetailRow(
                  //     'Interaction Details', medicine.interactionDetails!),
                  if (medicine.updatedBy != null)
                    _buildDetailRow('Updated By', medicine.updatedBy!),
                if (medicine.startDate != null)
                  _buildDetailRow('Start Date', formatDate(medicine.startDate!)),
                if (medicine.endDate != null)
                  _buildDetailRow('End Date', formatDate(medicine.endDate!)),
                if (medicine.frequencies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Frequencies:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...medicine.frequencies.map((freq) {
                    // Format frequency label
                    String frequencyLabel = _formatFrequencyLabel(freq.frequency);
                    // Format time value
                    String timeValue = freq.frequency.toLowerCase() == 'as_per_needed'
                        ? 'When Required'
                        : convertTo12HourFormat(freq.time);
                    
                    return _buildDetailRow(frequencyLabel, timeValue);
                  }),
                ],
                if (medicine.attachment != null &&
                    medicine.attachment!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Attachment:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => onImagePreview(medicine.attachment!),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.dividerGray),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          medicine.attachment!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.cardGray,
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textColor,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to preview',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onEdit(medicine.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showImagePreview(String imageUrl) {
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
                      child: Hero(
                        tag: imageUrl,
                        child: InteractiveViewer(
                          panEnabled: true,
                          boundaryMargin: EdgeInsets.all(20),
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.white54,
                                    ),
                                    const SizedBox(height: 12),
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
                      child: Icon(
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

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Converts 24-hour time format to 12-hour format with AM/PM
  /// Handles both "HH:MM" and "HH:MM:SS" formats
  /// Example: "14:30:00" -> "2:30 PM", "09:15" -> "9:15 AM"
  static String convertTo12HourFormat(String time24) {
    try {
      if (time24.isEmpty) return time24;

      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      int hour = int.parse(parts[0]);
      String minute = parts[1];

      String period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return time24;
    }
  }

  /// Formats frequency label for display
  /// Example: "daily" -> "Daily", "as_per_needed" -> "As Per Needed", "monthly" -> "Monthly"
  static String _formatFrequencyLabel(String frequency) {
    final lowerFreq = frequency.toLowerCase().trim();
    
    if (lowerFreq == 'as_per_needed') {
      return 'As Per Needed';
    } else if (lowerFreq == 'daily') {
      return 'Daily';
    } else if (lowerFreq == 'weekly') {
      return 'Weekly';
    } else if (lowerFreq == 'monthly') {
      return 'Monthly';
    } else if (lowerFreq == 'every other day') {
      return 'Every Other Day';
    } else {
      // Capitalize first letter for any other frequency
      return frequency[0].toUpperCase() + frequency.substring(1);
    }
  }
}
