import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionTimeoutDialog {
  static Future<bool> show(BuildContext context) async {
    bool shouldLogout = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                const Icon(
                  Icons.timer_off,
                  color: AppColors.blue,
                  size: 50,
                ),
                SizedBox(height: context.percentHeight * 1),
                headline5(
                  "Session Timeout",
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                subText5(
                  "Your session has expired due to inactivity. You will be logged out automatically.",
                  align: TextAlign.center,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: context.percentHeight * 2),
                subText5(
                  "Do you want to continue your session?",
                  align: TextAlign.center,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AppElevatedButton(
                      backgroundColor: AppColors.lightGreen,
                      onPressed: () {
                        shouldLogout = true;
                        Navigator.of(context).pop();
                      },
                      title: "Logout",
                    ),
                  ),
                  SizedBox(width: context.percentWidth * 2),
                  Expanded(
                    child: AppElevatedButton(
                      backgroundColor: AppColors.blue,
                      onPressed: () {
                        shouldLogout = false;
                        Navigator.of(context).pop();
                      },
                      title: "Continue",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return shouldLogout;
  }
}
