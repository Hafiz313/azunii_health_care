import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/repositories/summaries_repo.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends BaseController {
  final SummariesRepository _summariesRepository = SummariesRepository();
  final TextEditingController noteController = TextEditingController();
  final RxInt selectedRating = RxInt(1);
  final RxBool isPageActive = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    // Clear form after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clearForm();
    });
  }

  void onPageVisible() {
    isPageActive.value = true;
  }

  void onPageHidden() {
    isPageActive.value = false;
    // Clear form when leaving the page (scheduled after frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clearForm();
    });
  }

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  Future<void> submitFeedback(BuildContext context) async {
    if (noteController.text.trim().isEmpty) {
      CustomSnackbar.show('Please write a note', isSuccess: false);
      return;
    }

    print('🚀 Submitting feedback...');
    print('Rating: ${selectedRating.value}');
    print('Note: ${noteController.text.trim()}');

    final result = await safeApiCall(() => _summariesRepository.storeFeedback(
          selectedRating.value,
          noteController.text.trim(),
        ));

    print('📥 Result: $result');

    if (result != null) {
      print('✅ Feedback submitted successfully');
      CustomSnackbar.show('Thank you for your feedback!', isSuccess: true);
      clearForm();
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      print('❌ Feedback submission failed');
    }
  }

  void clearForm() {
    noteController.clear();
    selectedRating.value = 1;
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
