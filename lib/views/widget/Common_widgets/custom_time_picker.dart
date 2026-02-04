import 'package:Azunii_Health/consts/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTimePicker extends StatelessWidget {
  final String? selectedTime;
  final Function(String) onTimeSelected;
  final String label;

  const CustomTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
    this.label = 'Time',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Unfocus any active text fields before showing time picker
            FocusScope.of(context).unfocus();
            _showTimePickerDialog(context);
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cardsColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppColors.textColor,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  selectedTime ?? 'Select Time',
                  style: GoogleFonts.manrope(
                    color: selectedTime != null
                        ? AppColors.blackColor
                        : AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePickerDialog(BuildContext context) {
    final now = DateTime.now();
    DateTime selectedDateTime = now;

    if (selectedTime != null && selectedTime!.isNotEmpty) {
      final parts = selectedTime!.split(':');
      if (parts.length == 2) {
        selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.tryParse(parts[0]) ?? now.hour,
          int.tryParse(parts[1]) ?? now.minute,
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) => _TimePickerDialog(
        initialDateTime: selectedDateTime,
        onTimeSelected: onTimeSelected,
      ),
    );
  }
}

class _TimePickerDialog extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(String) onTimeSelected;

  const _TimePickerDialog({
    required this.initialDateTime,
    required this.onTimeSelected,
  });

  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        height: 380,
        child: Column(
          children: [
            Text(
              '${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  primaryColor: AppColors.primary,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 22,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: selectedDateTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      selectedDateTime = newDateTime;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.manrope(
                        color: AppColors.textColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final hour =
                          selectedDateTime.hour.toString().padLeft(2, '0');
                      final minute =
                          selectedDateTime.minute.toString().padLeft(2, '0');
                      widget.onTimeSelected('$hour:$minute');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.manrope(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
