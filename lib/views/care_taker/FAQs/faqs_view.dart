import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import 'controller/faqs_controller.dart';

class FAQsView extends StatefulWidget {
  static const String routeName = '/faqs-caregiver';

  const FAQsView({super.key});

  @override
  State<FAQsView> createState() => _FAQsViewState();
}

class _FAQsViewState extends State<FAQsView> {
  int? expandedIndex;
  late final FAQsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FAQsController());
  }

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
              child: Obx(() {
                if (controller.isLoading.value && controller.isFirstLoad.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshFAQs,
                  color: AppColors.blueV1,
                  child: controller.faqList.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: context.screenHeight * 0.6,
                              child: Center(
                                child: subText4(
                                  'No FAQs available',
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
      child: headline6(
        Lang.faq,
        color: AppColors.headingTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFAQList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
      child: Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.faqList.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: context.screenHeight * 0.015),
            itemBuilder: (context, index) {
              final faq = controller.faqList[index];
              final isExpanded = expandedIndex == index;

              return _buildFAQCard(
                context: context,
                question: faq.question,
                answer: faq.answer,
                isExpanded: isExpanded,
                onTap: () {
                  setState(() {
                    expandedIndex = isExpanded ? null : index;
                  });
                },
              );
            },
          )),
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
            color: Colors.black.withValues(alpha: 0.05),
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
                  color: AppColors.white.withValues(alpha: 0.9),
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
