import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:Azunii_Health/views/widget/edit_summary_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';
import 'controller/summary_controller.dart';

class ViewSummariesView extends StatefulWidget {
  static const String routeName = '/view-summaries';
  const ViewSummariesView({super.key});

  @override
  State<ViewSummariesView> createState() => _ViewSummariesViewState();
}

class _ViewSummariesViewState extends State<ViewSummariesView>
    with SingleTickerProviderStateMixin {
  late final SummaryController controller;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SummaryController>();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSummaries();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoader(
          isLoading: controller.isLoading.value,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white70,
              body: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        title: 'All Summaries',
                        isOndashboard: false,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.percentWidth * 5,
                          vertical: context.percentHeight * 2,
                        ),
                        child: subText3(
                          'Summaries',
                          color: AppColors.headingTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          if (controller.summariesList.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 80,
                                    color: AppColors.textColor.withOpacity(0.3),
                                  ),
                                  SizedBox(
                                      height: context.percentHeight * 0.02),
                                  subText4(
                                    'No summaries found',
                                    color: AppColors.textColor,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.percentWidth * 5,
                            ),
                            itemCount: controller.summariesList.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: context.percentHeight * 2),
                            itemBuilder: (context, index) {
                              final summary = controller.summariesList[index];
                              return TweenAnimationBuilder<double>(
                                duration:
                                    Duration(milliseconds: 300 + (index * 50)),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Opacity(
                                      opacity: value,
                                      child:
                                          _buildSummaryCard(context, summary),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSummaryCard(BuildContext context, dynamic summary) {
    final createdDate = summary['created_at'] != null
        ? summary['created_at'].toString().split('T')[0]
        : 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        color: AppColors.white,
                        size: context.percentWidth * 5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Summary",
                        style: TextStyle(
                          color: AppColors.headingTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: context.percentWidth * 4.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  summary['summary_text'] ?? 'No summary available',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: context.percentWidth * 3.75,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: context.percentWidth * 3.5,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      createdDate,
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.7),
                        fontSize: context.percentWidth * 3.25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showEditDialog(context, summary),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: AppColors.primary,
                    size: context.percentWidth * 4.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, dynamic summary) {
    showDialog(
      context: context,
      builder: (context) => EditSummaryDialog(
        initialText: summary['summary_text'] ?? '',
        summaryId: summary['id'],
        controller: controller.editSummaryController,
        onUpdate: () {
          controller.updateSummary(summary['id']);
        },
      ),
    );
  }
}
