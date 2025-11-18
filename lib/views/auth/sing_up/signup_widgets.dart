import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/social_button.dart';
import 'controller/signup_controller.dart';

class SignUpWidgets {
  static Widget buildSocialButtons(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            text: Lang.google,
            iconPath: AppAssets.googleIcon,
            onPressed: () => showUserTypeDialog(context, false),
          ),
        ),
        SizedBox(width: context.percentWidth * 4.0),
        Expanded(
          child: SocialButton(
            text: Lang.apple,
            iconPath: AppAssets.appleIcon,
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Only Google Sign-In is available for now',
                backgroundColor: AppColors.primary,
                colorText: AppColors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
          ),
        ),
      ],
    );
  }

  static void showUserTypeDialog(BuildContext context, bool isApicall) {
    final controller = Get.find<SignUpController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Sign Up As',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isApicall
                        ? controller.signInAsPatient(context)
                        : controller.signInAsPatient(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Sign Up as Patient',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isApicall
                        ? controller.SignupAsCaregiver(context)
                        : controller.signInAsCaregiver(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Sign Up as Caregiver',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
