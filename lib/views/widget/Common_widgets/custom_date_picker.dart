import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../text.dart';

class CustomDatePicker extends StatelessWidget {
  final String? label;
  final String hintText;
  final DateTime? selectedDate;
  final Function(DateTime?) onChanged;

  const CustomDatePicker({
    super.key,
    this.label,
    required this.hintText,
    this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.headingTextColor,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(width: 0.3, color: AppColors.primary),
              color: AppColors.cardsColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.calander,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : hintText,
                    style: TextStyle(
                      color: selectedDate != null
                          ? AppColors.blackColor
                          : AppColors.textColor,
                      fontFamily: 'Satoshi',
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
