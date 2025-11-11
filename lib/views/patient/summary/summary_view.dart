import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import 'feedback_view.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: _buildPlainLanguageSummary(),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar with back button, title, and feedback button
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          // Title
          Expanded(
            child: Center(
              child: headline3(
                'Plain-Language Summary',
                color: AppColors.headingTextColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Feedback button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackView()),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.bellBgColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.feedback_outlined,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  /// Plain Language Summary View
  Widget _buildPlainLanguageSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header Section
          headline3(
            'Plain-Language Summary',
            color: AppColors.headingTextColor,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 12),
          subText3(
            'Write your medical instructions in simple, everyday language',
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
          const SizedBox(height: 8),
          subText3(
            'This summary helps you remember what your doctor told you in words you can easily understand. Include things like when to take medications, what to watch out for, and when to call your doctor.',
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
          
          const SizedBox(height: 32),
          
          // Example Summary Section
          _buildSectionHeader('Example Summary'),
          const SizedBox(height: 16),
          _buildExampleSummaryCard(),
          
          const SizedBox(height: 32),
          
          // Your Medical Instructions Section
          _buildSectionHeader('Your Medical Instructions in Plain Language'),
          const SizedBox(height: 16),
          _buildInstructionsForm(),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppElevatedButton(
                  onPressed: () {
                    // Handle cancel
                  },
                  title: 'Cancel',
                  backgroundColor: AppColors.cardGray,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppElevatedButton(
                  onPressed: () {
                    // Navigate to feedback screen after saving summary
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackView()),
                    );
                  },
                  title: 'Save Summary',
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }



  Widget _buildSectionHeader(String title) {
    return subText2(
      title,
      color: AppColors.headingTextColor,
      align: TextAlign.start,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildExampleSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subText3(
            '"Take blood pressure pill every morning with breakfast. Check your blood pressure at home twice a week. If the number is over 160 or you feel dizzy, call the doctor right away. Avoid eating too much salt. Come back in 2 weeks for a follow-up."',
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subText3(
            'Write your instructions here in simple, everyday language...',
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
          const SizedBox(height: 20),
          
          // Question prompts
          _buildQuestionPrompt('When do I take my medicine?'),
          _buildQuestionPrompt('What side effects should I watch for?'),
          _buildQuestionPrompt('When should I call my doctor?'),
          _buildQuestionPrompt('What activities should I avoid?'),
          _buildQuestionPrompt('When is my next appointment?'),
        ],
      ),
    );
  }

  Widget _buildQuestionPrompt(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.textColor, fontSize: 16)),
          Expanded(
            child: subText3(
              question,
              color: AppColors.textColor,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }


}