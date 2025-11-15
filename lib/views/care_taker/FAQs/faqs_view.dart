import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/customAppBar.dart';

class FAQsView extends StatefulWidget {
  static const String routeName = '/faqs-caregiver';

  const FAQsView({super.key});

  @override
  State<FAQsView> createState() => _FAQsViewState();
}

class _FAQsViewState extends State<FAQsView> {
  int? expandedIndex;

  final List<Map<String, String>> faqData = [
    {'question': Lang.faqQuestion1, 'answer': Lang.faqAnswer1},
    {'question': Lang.faqQuestion2, 'answer': Lang.faqAnswer2},
    {'question': Lang.faqQuestion3, 'answer': Lang.faqAnswer3},
    {'question': Lang.faqQuestion4, 'answer': Lang.faqAnswer4},
    {'question': Lang.faqQuestion5, 'answer': Lang.faqAnswer5},
    {'question': Lang.faqQuestion6, 'answer': Lang.faqAnswer6},
    {'question': Lang.faqQuestion7, 'answer': Lang.faqAnswer7},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.faq,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildFAQHeader(),
                    const SizedBox(height: 20),
                    _buildFAQList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          headline6(
            Lang.faq,
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
          ),
          InkWell(
            onTap: () {},
            child: subText5(
              fontSize: 12,
              Lang.viewAll,
              color: AppColors.borderColor,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: faqData.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final faq = faqData[index];
          final isExpanded = expandedIndex == index;

          return _buildFAQCard(
            question: faq['question']!,
            answer: faq['answer']!,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                expandedIndex = isExpanded ? null : index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildFAQCard({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isExpanded ? AppColors.blueV1 : AppColors.white,
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
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: subText4(
                      question,
                      color: isExpanded
                          ? AppColors.white
                          : AppColors.headingTextColor,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.start,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded ? AppColors.white : AppColors.textColor,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: subText3(
                answer,
                color: isExpanded
                    ? AppColors.white.withOpacity(0.9)
                    : AppColors.textColor,
                align: TextAlign.start,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}
