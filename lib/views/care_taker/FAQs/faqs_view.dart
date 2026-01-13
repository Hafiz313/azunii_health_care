import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
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
                    SizedBox(height: context.screenHeight * 0.025),
                    _buildFAQHeader(context),
                    SizedBox(height: context.screenHeight * 0.025),
                    _buildFAQList(context),
                    SizedBox(height: context.screenHeight * 0.025),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
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
              fontSize: context.screenWidth * 0.03,
              Lang.viewAll,
              color: AppColors.borderColor,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: faqData.length,
        separatorBuilder: (context, index) => SizedBox(height: context.screenHeight * 0.015),
        itemBuilder: (context, index) {
          final faq = faqData[index];
          final isExpanded = expandedIndex == index;

          return _buildFAQCard(
            context: context,
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
    required BuildContext context,
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isExpanded ? AppColors.blueV1 : AppColors.white,
        borderRadius: BorderRadius.circular(context.screenWidth * 0.03),
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
            borderRadius: BorderRadius.circular(context.screenWidth * 0.03),
            child: Padding(
              padding: EdgeInsets.all(context.screenWidth * 0.04),
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
                    size: context.screenWidth * 0.06,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                context.screenWidth * 0.04,
                0,
                context.screenWidth * 0.04,
                context.screenWidth * 0.04,
              ),
              child: Text(
                answer,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Satoshi',
                ),
                textAlign: TextAlign.start,
              ),
            ),
        ],
      ),
    );
  }
}
