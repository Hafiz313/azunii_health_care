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
  String? _errorText;

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

  void _validateAndUpdate() {
    final text = widget.controller.text.trim();
    
    if (text.isEmpty) {
      setState(() {
        _errorText = 'Summary cannot be empty';
      });
      return;
    }
    
    if (text.length < 10) {
      setState(() {
        _errorText = 'Summary must be at least 10 characters long';
      });
      return;
    }
    
    // Validation passed
    widget.onUpdate();
    Navigator.pop(context);
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
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
            EdgeInsets.symmetric(horizontal: context.percentWidth * 5),
        child: Container(
          width: context.screenWidth * 0.9,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.white,
                      size: context.percentWidth * 6,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Edit Summary",
                      style: TextStyle(
                        fontSize: context.percentWidth * 4.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary Text",
                      style: TextStyle(
                        fontSize: context.percentWidth * 3.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.headingTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _errorText != null 
                              ? Colors.red 
                              : AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: CustomTxtField(
                        textEditingController: widget.controller,
                        hintTxt: 'Enter summary text...',
                        maxLines: 6,
                      ),
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorText!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: context.percentWidth * 3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.percentWidth * 4,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: context.percentWidth * 3.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _validateAndUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.percentWidth * 5,
                              vertical: 8,
                            ),
                            elevation: 0,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Update",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              fontSize: context.percentWidth * 3.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
