import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../text.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? selectedValue;
  final Widget prefixIcon;
  final List<String> items;
  final Function(String?) onChanged;
  final String? label;
  final bool allowCustomValue;

  const CustomDropdown({
    super.key,
    required this.hintText,
    this.selectedValue,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.label,
    this.allowCustomValue = true,
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
          onTap: () {
            // Unfocus any active text fields before showing picker
            FocusScope.of(context).unfocus();
            _showPicker(context).then((_) {
              // Re-unfocus after sheet closes to prevent focus returning to text field
              FocusScope.of(context).unfocus();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardsColor,
              border: Border.all(width: 0.3, color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                prefixIcon,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedValue ?? hintText,
                    style: TextStyle(
                      color: selectedValue != null
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

  Future<void> _showPicker(BuildContext context) {
    final TextEditingController customController = TextEditingController();

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Custom input field - only show if allowCustomValue is true
            if (allowCustomValue) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardsColor,
                  border: Border.all(width: 0.3, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    //  prefixIcon,
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: customController,
                        decoration: const InputDecoration(
                          hintText: 'Enter custom value',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 14,
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            onChanged(value.trim());
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (customController.text.trim().isNotEmpty) {
                          onChanged(customController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.check,
                          color: AppColors.primary, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
            ],
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      onChanged(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
