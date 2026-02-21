import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/notification_model.dart';
import '../../../../../core/repositories/notifications_repo.dart';
import '../../../../widget/Common_widgets/custom_snackbar.dart';

class NotificationController extends BaseController {
  final NotificationsRepository _repository = NotificationsRepository();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxString selectedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedDate.value = currentDate; // Set current date in filter
    fetchNotifications(currentDate);
  }

  Future<void> fetchNotifications(String date) async {
    final result = await safeApiCall(
      () => _repository.getNotifications(date),
    );
    if (result != null) {
      notifications.value = result.data;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value.isEmpty
          ? DateTime.now()
          : DateTime.parse(selectedDate.value),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate.value = DateFormat('yyyy-MM-dd').format(picked);
      await fetchNotifications(selectedDate.value);
    }
  }

  Future<void> clearDateFilter() async {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedDate.value = currentDate; // Reset to current date
    await fetchNotifications(currentDate);
  }

  Future<void> deleteNotification(int id) async {
    final result = await safeApiCall(
      () => _repository.deleteNotification(id),
    );
    if (result != null) {
      notifications.removeWhere((notification) => notification.id == id);
      CustomSnackbar.show('Notification deleted successfully', isSuccess: true);
    }
  }
}
