import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/repositories/summaries_repo.dart';
import '../../../widget/Common_widgets/custom_snackbar.dart';

class SummaryController extends BaseController {
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController editSummaryController = TextEditingController();
  final SummariesRepository _summariesRepository = SummariesRepository();
  final RxList<dynamic> summariesList = <dynamic>[].obs;
  
  @override
  void onClose() {
    instructionsController.dispose();
    editSummaryController.dispose();
    super.onClose();
  }
  
  Future<void> getSummaries() async {
    final result = await safeApiCall(
      () => _summariesRepository.getSummary(),
    );
    
    if (result != null && result['data'] != null) {
      summariesList.value = result['data'] is List ? result['data'] : [result['data']];
    }
  }
  
  Future<void> updateSummary(int id) async {
    if (editSummaryController.text.trim().isEmpty) {
      CustomSnackbar.show('Please enter summary text', isSuccess: false);
      return;
    }

    final result = await safeApiCall(
      () => _summariesRepository.updateSummary(id, editSummaryController.text.trim()),
    );
    
    if (result != null) {
      CustomSnackbar.show('Summary updated successfully', isSuccess: true);
      editSummaryController.clear();
      await getSummaries();
    }
  }
  
  Future<void> saveSummary() async {
    if (instructionsController.text.trim().isEmpty) {
      CustomSnackbar.show('Please enter your medical instructions', isSuccess: false);
      return;
    }

    final result = await safeApiCall(
      () => _summariesRepository.storeSummary(instructionsController.text.trim()),
    );
    
    if (result != null) {
      CustomSnackbar.show('Summary saved successfully', isSuccess: true);
      instructionsController.clear();
    }
  }
  
  void cancelSummary() {
    instructionsController.clear();
  }
}