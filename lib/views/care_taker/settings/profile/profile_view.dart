import 'package:flutter/material.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';
import '../../../widget/Common_widgets/customAppBar.dart';

class ProfileView extends StatelessWidget {
  static const String routeName = '/profile-settings';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.profile,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenWidth * 0.05),
                    _buildProfileHeader(),
                    SizedBox(height: context.screenWidth * 0.04),
                    _buildProfileMenu(context),
                    SizedBox(height: context.screenWidth * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: headline6(
        Lang.profile,
        color: AppColors.headingTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': Lang.personalInformation,
        'icon': Icons.person_outline,
        'color': AppColors.primary,
        'onTap': () {},
      },
      {
        'title': Lang.accountSettings,
        'icon': Icons.settings_outlined,
        'color': AppColors.primary,
        'onTap': () {},
      },
      {
        'title': Lang.changePassword,
        'icon': Icons.lock_outline,
        'color': AppColors.primary,
        'onTap': () {},
      },
      {
        'title': Lang.language,
        'icon': Icons.language_outlined,
        'color': AppColors.primary,
        'onTap': () {},
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: context.screenWidth * 0.03),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return _buildMenuItem(
            context: context,
            title: item['title'],
            icon: item['icon'],
            color: item['color'],
            onTap: item['onTap'],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(context.screenWidth * 0.04),
        decoration: BoxDecoration(
          color: AppColors.white,
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
        child: Row(
          children: [
            Container(
              width: context.screenWidth * 0.1,
              height: context.screenWidth * 0.1,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: context.screenWidth * 0.05,
              ),
            ),
            SizedBox(width: context.screenWidth * 0.04),
            Expanded(
              child: subText4(
                title,
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w500,
                align: TextAlign.start,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textColor,
              size: context.screenWidth * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
