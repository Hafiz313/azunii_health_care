import 'package:azunii_health_care/views/widget/Common_widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  static const String routeName = '/feedback';

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int _selectedRating = 1; // Default to 1 star as shown in Figma
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'User Feedback',
            ),
            Expanded(
              child: _buildFeedbackContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// Feedback Content
  Widget _buildFeedbackContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // Help Us to Improve Section
          Center(
            child: Column(
              children: [
                headline3(
                  'Help Us to Improve',
                  color: AppColors.headingTextColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Star Rating
                _buildStarRating(),

                const SizedBox(height: 50),

                // Your Note Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: subText2(
                    'Your Note',
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Note Input Field
                _buildNoteInputField(),

                const SizedBox(height: 50),

                // Submit Button
                AppElevatedButton(
                  onPressed: () {
                    _handleSubmitFeedback();
                  },
                  title: 'Submit',
                  backgroundColor: AppColors.primary,
                  width: double.infinity,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = index + 1;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              index < _selectedRating ? Icons.star : Icons.star_border,
              size: 40,
              color: index < _selectedRating
                  ? AppColors.yellow
                  : AppColors.textColor,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNoteInputField() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerGray, width: 1),
      ),
      child: TextField(
        controller: _noteController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          color: AppColors.blackColor,
          fontSize: 16,
          fontFamily: 'Satoshi',
        ),
        decoration: InputDecoration(
          hintText: 'Write your Note',
          hintStyle: TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontFamily: 'Satoshi',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  void _handleSubmitFeedback() {
    // Handle feedback submission
    print('Rating: $_selectedRating');
    print('Note: ${_noteController.text}');

    // Show success message and go back
    Get.snackbar(
      'Success',
      'Thank you for your feedback!',
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );

    // Go back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}
