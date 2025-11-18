import 'package:Azunii_Health/consts/colors.dart';
import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  final TabController tabController;
  final List<String> tabLabels;
  final ValueChanged<int> onTap;
  final List<Widget> tabViews;

  const CustomTabView({
    super.key,
    required this.tabController,
    required this.tabLabels,
    required this.tabViews,
    required this.onTap,
  });

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView>
    with SingleTickerProviderStateMixin {
  int _monthlySelectedIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {
        _monthlySelectedIndex = widget.tabController.index;
      });
    });
  }

  @override
  void dispose() {
    widget.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.transparent, // Background color for tabs
            borderRadius:
                BorderRadius.circular(20), // Rounded container for tabs
          ),
          child: TabBar(
            controller: widget.tabController,
            indicatorWeight: 0,
            padding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorColor: AppColors.blackColor,
            unselectedLabelColor: AppColors.blackColor,
            labelColor: AppColors.white,
            dividerColor: Colors.transparent,
            onTap: widget.onTap,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            tabs: widget.tabLabels.map((label) {
              return Tab(
                text: label,
              );
            }).toList(),
          ),
        ),
        // SizedBox(height: context.percentHeight * 2,),
        Expanded(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: widget.tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }
}
