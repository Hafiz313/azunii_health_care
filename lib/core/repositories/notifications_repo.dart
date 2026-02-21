import 'package:flutter/material.dart';
import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  // Get Notifications (POST with date parameter)
  Future<NotificationResponse> getNotifications(String date) async {
    try {
      debugPrint('\n🔔 GET NOTIFICATIONS Request 🔔');
      debugPrint('📅 Date: $date');
      final response = await ApiClient.postWithAuth(
        Apis.getNotifications,
        body: {'date': date},
      );
      debugPrint('✅ Notifications retrieved successfully\n');
      return NotificationResponse.fromJson(response);
    } catch (e) {
      debugPrint('❌ Get Notifications Error: $e');
      rethrow;
    }
  }

  // Delete Notification (GET with ID in URL)
  Future<Map<String, dynamic>> deleteNotification(int id) async {
    try {
      debugPrint('\n🗑️ DELETE NOTIFICATION Request 🗑️');
      debugPrint('🆔 Notification ID: $id');
      final response = await ApiClient.getWithAuth('${Apis.delNotifications}$id');
      debugPrint('✅ Notification deleted successfully\n');
      return response;
    } catch (e) {
      debugPrint('❌ Delete Notification Error: $e');
      rethrow;
    }
  }
}
