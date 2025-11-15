import 'package:flutter/material.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';
import '../../../widget/Common_widgets/customAppBar.dart';

class AccessibilityView extends StatefulWidget {
  static const String routeName = '/accessibility-settings';
  
  const AccessibilityView({super.key});

  @override
  State<AccessibilityView> createState() => _AccessibilityViewState();
}

class _AccessibilityViewState extends State<AccessibilityView> {
  bool highContrast = false;
  bool voiceOver = false;
  bool screenReader = false;
  String selectedFontSize = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.accessibility,
              onIconTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenWidth * 0.05),
                    _buildAccessibilityHeader(),
                    SizedBox(height: context.screenWidth * 0.04),
                    _buildAccessibilityOptions(context),
                    SizedBox(height: context.screenWidth * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: headline6(
        Lang.accessibility,
        color: AppColors.headingTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAccessibilityOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildFontSizeOption(context),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.highContrast,
            icon: Icons.contrast_outlined,
            value: highContrast,
            onChanged: (value) => setState(() => highContrast = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.voiceOver,
            icon: Icons.record_voice_over_outlined,
            value: voiceOver,
            onChanged: (value) => setState(() => voiceOver = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.screenReader,
            icon: Icons.accessibility_new_outlined,
            value: screenReader,
            onChanged: (value) => setState(() => screenReader = value),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: context.screenWidth * 0.1,
            height: context.screenWidth * 0.1,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.text_fields_outlined,
              color: AppColors.primary,
              size: context.screenWidth * 0.05,
            ),
          ),
          SizedBox(width: context.screenWidth * 0.04),
          Expanded(
            child: subText4(
              Lang.fontSize,
              color: AppColors.headingTextColor,
              fontWeight: FontWeight.w500,
              align: TextAlign.start,
            ),
          ),
          DropdownButton<String>(
            value: selectedFontSize,
            underline: Container(),
            items: ['Small', 'Medium', 'Large', 'Extra Large']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: subText3(value, color: AppColors.textColor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedFontSize = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: context.screenWidth * 0.1,
            height: context.screenWidth * 0.1,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: context.screenWidth * 0.05,
            ),
          ),
          SizedBox(width: context.screenWidth * 0.04),
          Expanded(
            child: subText4(
              title,
              color: AppColors.headingTextColor,
              fontWeight: FontWeight.w500,
              align: TextAlign.start,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}