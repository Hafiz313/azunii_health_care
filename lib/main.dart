import 'package:azunii_health_care/utils/localStorage/storage_service.dart';
import 'package:azunii_health_care/views/auth/splash_view.dart';
import 'package:azunii_health_care/utils/inactivity_service.dart';
import 'package:azunii_health_care/utils/localStorage/storage_consts.dart';
import 'package:azunii_health_care/utils/localStorage/storage_service.dart';
import 'package:azunii_health_care/views/auth/login/controller/login_controller.dart';
import 'package:azunii_health_care/views/auth/login/login_view.dart';
import 'package:flutter/foundation.dart';
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
  await GetStorage.init();
  EasyLoading.init();
  // _getToken();
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
      title: 'Employee App',
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
