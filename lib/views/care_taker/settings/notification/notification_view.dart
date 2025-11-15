import 'package:flutter/material.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';
import '../../../widget/Common_widgets/customAppBar.dart';

class NotificationView extends StatefulWidget {
  static const String routeName = '/notification-settings';

  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool medicationReminders = true;
  bool appointmentReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.notifications,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenWidth * 0.05),
                    _buildNotificationHeader(),
                    SizedBox(height: context.screenWidth * 0.04),
                    _buildNotificationOptions(context),
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

  Widget _buildNotificationHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: headline6(
        Lang.notifications,
        color: AppColors.headingTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNotificationOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSwitchOption(
            context: context,
            title: Lang.pushNotifications,
            icon: Icons.notifications_outlined,
            value: pushNotifications,
            onChanged: (value) => setState(() => pushNotifications = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.emailNotifications,
            icon: Icons.email_outlined,
            value: emailNotifications,
            onChanged: (value) => setState(() => emailNotifications = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.medicationReminders,
            icon: Icons.medication_outlined,
            value: medicationReminders,
            onChanged: (value) => setState(() => medicationReminders = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.appointmentReminders,
            icon: Icons.calendar_today_outlined,
            value: appointmentReminders,
            onChanged: (value) => setState(() => appointmentReminders = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
