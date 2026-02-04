import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:Azunii_Health/views/widget/text_fields.dart';

class EditSummaryDialog extends StatefulWidget {
  final String initialText;
  final int summaryId;
  final TextEditingController controller;
  final VoidCallback onUpdate;

  const EditSummaryDialog({
    super.key,
    required this.initialText,
    required this.summaryId,
    required this.controller,
    required this.onUpdate,
  });

  @override
  State<EditSummaryDialog> createState() => _EditSummaryDialogState();
}

class _EditSummaryDialogState extends State<EditSummaryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    widget.controller.text = widget.initialText;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        title: Text(
          "Edit Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.headingTextColor,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTxtField(
                textEditingController: widget.controller,
                hintTxt: 'Enter summary text...',
                maxLines: 7,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onUpdate();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              "Update",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
