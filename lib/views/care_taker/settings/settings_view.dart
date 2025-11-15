import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import '../../auth/login/login_view.dart';
import 'profile/profile_view.dart';
import 'accessibility/accessibility_view.dart';
import 'notification/notification_view.dart';
import 'privacy/privacy_view.dart';

class Settingsview extends StatelessWidget {
  static const String routeName = '/settings-caregiver';

  const Settingsview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.settings,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenWidth * 0.05),
                    _buildSettingsHeader(),
                    SizedBox(height: context.screenWidth * 0.04),
                    _buildSettingsMenu(context),
                    SizedBox(height: context.screenWidth * 0.08),
                    _buildActionButtons(context),
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

  Widget _buildSettingsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: headline6(
        Lang.settings,
        color: AppColors.headingTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': Lang.profile,
        'icon': Icons.person_outline,
        'color': AppColors.primary,
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileView())),
      },
      {
        'title': Lang.accessibility,
        'icon': Icons.accessibility_outlined,
        'color': AppColors.primary,
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AccessibilityView())),
      },
      {
        'title': Lang.notifications,
        'icon': Icons.notifications_outlined,
        'color': AppColors.primary,
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NotificationView())),
      },
      {
        'title': Lang.privacySecurity,
        'icon': Icons.security_outlined,
        'color': AppColors.primary,
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrivacyView())),
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: context.screenWidth * 0.12,
              child: AppElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginView.routeName,
                    (route) => false,
                  );
                },
                title: Lang.logOut,
                backgroundColor: AppColors.cardGray,
                textColor: AppColors.headingTextColor,
              ),
            ),
          ),
          SizedBox(width: context.screenWidth * 0.04),
          Expanded(
            child: SizedBox(
              height: context.screenWidth * 0.12,
              child: AppElevatedButton(
                onPressed: () {},
                title: Lang.deleteAccount,
                backgroundColor: AppColors.lightRed,
                textColor: AppColors.redColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
