import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/repositories/caregivers_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqItem {
  final int id;
  final String question;
  final String answer;

  FaqItem({required this.id, required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class FAQsController extends BaseController {
  final CaregiversRepository _caregiversRepository = CaregiversRepository();

  final RxList<FaqItem> faqList = <FaqItem>[].obs;
  final RxBool isFirstLoad = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchFAQs();
  }

  Future<void> _fetchFAQs() async {
    final result = await safeApiCall(() => _caregiversRepository.getFAQs());

    if (result != null) {
      final List<dynamic> data = result['data'] ?? [];
      faqList.value = data.map((e) => FaqItem.fromJson(e)).toList();
      isFirstLoad.value = false;
      debugPrint('✅ FAQs loaded: ${faqList.length} items');
    }
  }

  Future<void> refreshFAQs() async {
    await _fetchFAQs();
  }
}
