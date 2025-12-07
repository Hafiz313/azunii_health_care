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
      child: CupertinoAlertDialog(
        title: Text(
          "Edit Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.headingTextColor,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Material(
            // Needed for textfield inside Cupertino dialog
            color: Colors.transparent,
            child: CustomTxtField(
              textEditingController: widget.controller,
              hintTxt: 'Enter summary text...',
              maxLines: 4,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: false,
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.textColor.withOpacity(0.7),
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              widget.onUpdate();
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: Text(
              "Update",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
