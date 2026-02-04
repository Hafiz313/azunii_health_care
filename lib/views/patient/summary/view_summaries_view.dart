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
    controller = Get.put(SummaryController());
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
    Get.delete<SummaryController>();
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
                        padding: EdgeInsets.only(
                          left: 10,
                          top: context.percentHeight * 0.02,
                        ),
                        child: subText3(
                          'Summaries',
                          color: AppColors.headingTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.percentHeight * 0.02),
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
                              horizontal: context.percentWidth * 0.04,
                            ),
                            itemCount: controller.summariesList.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: context.percentHeight * 0.015),
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
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        //color: Colors.white70,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Dark shadow for depth (bottom-right)
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            offset: const Offset(8, 8),
            blurRadius: 12,
            spreadRadius: 10,
          ),
          // Light shadow for raised effect (top-left)
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container with neumorphic effect
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Summary",
                    style: TextStyle(
                      color: AppColors.headingTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description text
                  Text(
                    summary['summary_text'] ?? 'No summary available',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Created date with icon
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        createdDate,
                        style: TextStyle(
                          color: AppColors.textColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit button with neumorphic effect
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _showEditDialog(context, summary),
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
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
