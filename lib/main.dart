import 'package:Azunii_Health/services/fcm_service.dart';
import 'package:Azunii_Health/views/splash/controller/splash_controller.dart';
import 'package:Azunii_Health/utils/localStorage/storage_consts.dart';
import 'package:Azunii_Health/utils/localStorage/storage_service.dart';
import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:Azunii_Health/views/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:get_storage/get_storage.dart';
import 'app_routes.dart';

String deviceToken = '';
Map<String, dynamic>? _initialNotificationData;

/// TOP-LEVEL BACKGROUND MESSAGE HANDLER
/// MUST be top-level function (not inside a class)
/// Required by Firebase to handle messages when app is terminated
///
/// Why top-level?
/// - Dart isolates cannot access class instances
/// - Background handler runs in separate isolate
/// - Must be accessible without any context
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase in background isolate
  await Firebase.initializeApp();

  debugPrint('🔔 Background message received:');
  debugPrint('   Message ID: ${message.messageId}');
  debugPrint('   Title: ${message.notification?.title}');
  debugPrint('   Body: ${message.notification?.body}');
  debugPrint('   Data: ${message.data}');

  // Handle background notification logic here
  // Do NOT perform heavy operations or UI updates
}

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only on mobile platforms
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await Firebase.initializeApp();
      debugPrint('✅ Firebase initialized successfully');

      // Register background message handler
      // MUST be called before any other Firebase Messaging operations
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      debugPrint('✅ Background message handler registered');
    } catch (e) {
      debugPrint('❌ Firebase initialization failed: $e');
    }
  }

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize local storage services
  await GetStorage.init();

  // Initialize FCM service
  // Handles permissions, foreground messages, and notification clicks
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FCMService.init();

    // Handle notification that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🚀 App opened from terminated state via notification');
      debugPrint('   Data: ${initialMessage.data}');

      // Store initial message to handle after app is fully initialized
      _initialNotificationData = initialMessage.data;
    }
  }

  EasyLoading.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Handle initial notification after app is built
    if (_initialNotificationData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = navigate.currentContext;
        if (ctx != null) {
          // Use existing SplashController if available, otherwise create new one
          final splashController = Get.isRegistered<SplashController>() 
              ? Get.find<SplashController>() 
              : Get.put(SplashController());
          splashController.checkLoginAndNavigate(ctx);
          _initialNotificationData = null;
        }
      });
    }

    return GetMaterialApp(
      title: 'Anzuii Health care',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashView.routeName,

      // StorageService().containsKey(StorageConsts.kAppRun)
      //     ? SplashView.routeName
      //     : LoginView.routeName,
      builder: EasyLoading.init(),
      getPages: AppRoutes.pages,
    );
  }
}

GlobalKey<NavigatorState> navigate = GlobalKey<NavigatorState>();
