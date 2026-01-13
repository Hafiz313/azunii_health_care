import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../views/splash/controller/splash_controller.dart';

/// FCM Service - Handles all Firebase Cloud Messaging operations
/// Responsibilities:
/// - Request notification permissions
/// - Initialize local notifications
/// - Handle foreground notifications
/// - Handle notification clicks
/// - Fetch and manage FCM token
class FCMService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  /// Android notification channel for high-priority notifications
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  /// Initialize FCM service
  /// Call this in main.dart after Firebase initialization
  static Future<void> init() async {
    // Request notification permissions (iOS & Android 13+)
    await _requestPermissions();
    
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Get and log FCM token
    await _getFCMToken();
    
    // Listen to foreground messages
    _listenToForegroundMessages();
    
    // Listen to notification clicks when app is in background
    _listenToNotificationClicks();
  }

  /// Request notification permissions
  /// For Android 13+ (API 33+) and iOS
  /// Made public to call from splash screen
  static Future<void> requestPermissions() async {
    await _requestPermissions();
  }

  /// Internal permission request method
  /// For Android 13+ (API 33+) and iOS
  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ requires POST_NOTIFICATIONS permission
      final status = await Permission.notification.request();
      print('📱 Android notification permission: $status');
    }
    
    // Request iOS permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    print('🔔 FCM Permission status: ${settings.authorizationStatus}');
  }

  /// Initialize flutter_local_notifications
  /// Required to show notifications when app is in foreground
  static Future<void> _initializeLocalNotifications() async {
    // Android initialization settings - using custom notification icon
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@drawable/ic_notification');
    
    // iOS initialization settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    // Initialize with click handler
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    
    print('✅ Local notifications initialized');
  }

  /// Fetch and log FCM token
  /// Token is used to send notifications to this device
  static Future<String?> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      print('🔑 FCM Token: $token');
      
      // TODO: Send token to your backend server
      // await YourApiService.sendFCMToken(token);
      
      return token;
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Listen to token refresh
  /// Call this to handle token updates
  static void listenToTokenRefresh(Function(String) onTokenRefresh) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed: $newToken');
      onTokenRefresh(newToken);
    });
  }

  /// Listen to foreground messages
  /// Shows local notification when app is in foreground
  static void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground message received:');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
      
      // Show local notification
      _showLocalNotification(message);
    });
  }

  /// Show local notification
  /// Used to display notification when app is in foreground
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: '@drawable/ic_notification',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Listen to notification clicks
  /// Handles when user taps notification while app is in background
  static void _listenToNotificationClicks() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notification clicked (background):');
      print('   Data: ${message.data}');
      
      // Handle navigation based on message data
      _handleNotificationClick(message.data);
    });
  }

  /// Handle notification tap from local notifications
  /// Called when user taps notification shown by flutter_local_notifications
  static void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Local notification tapped');
    print('   Payload: ${response.payload}');
    
    // Simply bring app to foreground - don't navigate
    // User is already in the app, just show it
    print('✅ App brought to foreground');
  }

  /// Handle notification click and navigate
  /// Uses SplashController logic to check login and navigate to appropriate screen
  static void _handleNotificationClick(Map<String, dynamic> data) {
    print('🎯 Handling notification click (background)');
    print('   Data: $data');
    
    // Only navigate if app was in background/killed state
    // Use Get.context to access BuildContext
    final context = Get.context;
    if (context != null) {
      // Use existing SplashController if available, otherwise create new one
      final splashController = Get.isRegistered<SplashController>() 
          ? Get.find<SplashController>() 
          : Get.put(SplashController());
      splashController.checkLoginAndNavigate(context);
    } else {
      print('❌ Context not available for navigation');
    }
  }

  /// Get current FCM token
  /// Use this to retrieve token when needed
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Delete FCM token
  /// Call this on logout
  static Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    print('🗑️ FCM token deleted');
  }
}
