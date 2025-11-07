import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../consts/colors.dart';
import '../../networking/api_provider.dart';

void showCustomLoader() {
  // EasyLoading.instance
  //   ..displayDuration = const Duration(milliseconds: 2000)
  //   ..loadingStyle = EasyLoadingStyle.dark //This was missing in earlier code
  //   ..backgroundColor = Colors.white.withOpacity(0.9)
  //   ..indicatorColor = AppColors.primary
  //   ..dismissOnTap = false
  //   ..textColor = AppColors.primary;

  mainLoading.value = true;
  // EasyLoading.show();
}
