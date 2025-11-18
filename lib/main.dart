import 'package:Azunii_Health/utils/localStorage/storage_consts.dart';
import 'package:Azunii_Health/utils/localStorage/storage_service.dart';
import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:Azunii_Health/views/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:get_storage/get_storage.dart';
import 'app_routes.dart';

String deviceToken = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only on mobile platforms
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  }

  // Initialize local storage services
  await GetStorage.init();

  EasyLoading.init();
  runApp(MyApp());
}

Future<void> _getToken() async {
  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //   deviceToken = androidInfo.id; // Unique Android Device ID
  // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
  //   // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //   // deviceToken = iosInfo.identifierForVendor ?? ""; // Unique iOS Device ID
  // }
  //
  // print("Device ID: $deviceToken");
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Anzuii Health care',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: StorageService().containsKey(StorageConsts.kAppRun)
          ? SplashView.routeName
          : LoginView.routeName,
      builder: EasyLoading.init(),
      getPages: AppRoutes.pages,
    );
  }
}

GlobalKey<NavigatorState> navigate = GlobalKey<NavigatorState>();
