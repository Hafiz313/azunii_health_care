import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../core/models/timeline_model.dart';

class TimelineDetailsDialogs {
  /// Show visit details dialog matching the app's existing dialog pattern
  static void showVisitDetailsDialog(TimelineEvent visit) {
    final formattedDate = _formatTimestamp(visit.timestamp);
    final isActive = visit.status.toLowerCase() == 'active';

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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.local_hospital_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Visit Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headingTextColor,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.cardGray,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: AppColors.textColor, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Provider info
                _buildInfoCard(
                  icon: Icons.person_outline,
                  label: 'Provider',
                  value: visit.title,
                  color: AppColors.primary,
                ),
                if (visit.subtitle != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.medical_services_outlined,
                    label: 'Specialty',
                    value: visit.subtitle!,
                    color: Colors.teal,
                  ),
                ],
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Visit Date',
                  value: formattedDate,
                  color: Colors.orange,
                ),
                if (visit.notes != null && visit.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: visit.notes!,
                    color: Colors.purple,
                  ),
                ],
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.circle,
                  label: 'Status',
                  value: _capitalize(visit.status),
                  color: isActive ? AppColors.green : Colors.red,
                ),

                const SizedBox(height: 24),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  /// Show medicine schedule details dialog
  static void showScheduleDetailsDialog(MedicineSchedule schedule) {
    final isActive = schedule.status.toLowerCase() == 'active';

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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.medication_outlined,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Medicine Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headingTextColor,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.cardGray,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: AppColors.textColor, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildInfoCard(
                  icon: Icons.medication,
                  label: 'Medicine',
                  value: schedule.medicineName,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.science_outlined,
                  label: 'Dosage',
                  value: schedule.dosage,
                  color: Colors.teal,
                ),
                if (schedule.startDate.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'Start Date',
                    value: _formatDateString(schedule.startDate),
                    color: Colors.green,
                  ),
                ],
                if (schedule.endDate.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.event_outlined,
                    label: 'End Date',
                    value: _formatDateString(schedule.endDate),
                    color: Colors.orange,
                  ),
                ],
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.circle,
                  label: 'Status',
                  value: _capitalize(schedule.status),
                  color: isActive ? AppColors.green : Colors.red,
                ),

                // Frequencies section
                if (schedule.frequencies.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Frequencies',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...schedule.frequencies.map((freq) {
                    final freqLabel = _formatFrequencyLabel(freq.frequency);
                    final timeValue = freq.frequency.toLowerCase() == 'as_per_needed'
                        ? 'When Required'
                        : _formatTime(freq.time);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$freqLabel — $timeValue',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.headingTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  static Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.headingTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (e) {
      return timestamp;
    }
  }

  static String _formatDateString(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }

  static String _formatTime(String time) {
    if (time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        if (hour == 0) hour = 12;
        if (hour > 12) hour -= 12;
        return '$hour:$minute $period';
      }
    }
    return time;
  }

  static String _formatFrequencyLabel(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      case 'every_other_day':
        return 'Every Other Day';
      case 'as_per_needed':
        return 'As Per Needed';
      default:
        return frequency.replaceAll('_', ' ').split(' ')
            .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
            .join(' ');
    }
  }
}
