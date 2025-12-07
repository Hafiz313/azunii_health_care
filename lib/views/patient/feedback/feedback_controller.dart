import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../core/repositories/summaries_repo.dart';
import '../../widget/Common_widgets/custom_snackbar.dart';

class FeedbackController extends BaseController {
  final SummariesRepository _summariesRepository = SummariesRepository();
  final TextEditingController noteController = TextEditingController();
  final RxInt selectedRating = RxInt(1);

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
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      print('❌ Feedback submission failed');
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
