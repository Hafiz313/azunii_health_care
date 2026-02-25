import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';
import '../../../widget/Common_widgets/customAppBar.dart';
import '../../../widget/Common_widgets/overlayloader.dart';
import '../../../widget/Common_widgets/date_picker_button.dart';
import 'controller/notification_controller.dart';

class NotificationView extends StatefulWidget {
  static const String routeName = '/notification-settings';

  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NotificationController());
  }

  @override
  void dispose() {
    Get.delete<NotificationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoader(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.headingTextColor),
                onPressed: () => Get.back(),
              ),
              title: Text(
                Lang.notifications,
                style: const TextStyle(
                  color: AppColors.headingTextColor,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 4,
                        vertical: context.percentHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() => DatePickerButton(
                              date: controller.selectedDate.value,
                              onTap: () => controller.selectDate(context),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.notifications.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 80,
                                color: AppColors.textColor.withOpacity(0.3),
                              ),
                              SizedBox(height: context.percentHeight * 0.02),
                              subText4(
                                'No notifications for today',
                                color: AppColors.textColor,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.all(context.percentWidth * 0.04),
                        itemCount: controller.notifications.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: context.percentHeight * 0.015),
                        itemBuilder: (context, index) {
                          final notification = controller.notifications[index];
                          return _buildNotificationCard(context, notification);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildNotificationCard(BuildContext context, notification) {
    final createdDate = notification.createdAt.split('T')[0];
    final createdTime24 = notification.createdAt.split('T').length > 1
        ? notification.createdAt.split('T')[1].substring(0, 5)
        : '';

    // Convert 24-hour time to 12-hour format with AM/PM
    String createdTime = '';
    if (createdTime24.isNotEmpty) {
      final parts = createdTime24.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        String minute = parts[1];
        String period = hour >= 12 ? 'PM' : 'AM';

        if (hour == 0) {
          hour = 12;
        } else if (hour > 12) {
          hour = hour - 12;
        }

        createdTime = '$hour:$minute $period';
      }
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.only(bottom: context.percentHeight * 0.015),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 231, 231, 231),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            // Light shadow (top-left)
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: const Offset(-6, -6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
            // Dark shadow (bottom-right)
            BoxShadow(
              color: const Color(0xFFD1D9E6).withOpacity(0.6),
              offset: const Offset(6, 6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Neumorphic Icon Container
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    // Inner shadow effect (pressed/inset)
                    BoxShadow(
                      color: const Color(0xFFD1D9E6).withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.7),
                      offset: const Offset(-4, -4),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.notifications_rounded,
                    color: const Color(0xFF6C63FF),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Message
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B6B6B),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Date and Time Row
                    Row(
                      children: [
                        // Calendar Icon + Date
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: const Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          createdDate,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        if (createdTime.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          // Clock Icon + Time
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: const Color(0xFF9E9E9E),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            createdTime,
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Delete Button
              InkWell(
                onTap: () => controller.deleteNotification(notification.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Color(0xFFFF4D4F),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
