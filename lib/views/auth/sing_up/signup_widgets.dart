import 'package:Azunii_Health/consts/appconsts.dart';
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
    controller.googleSignup(controller.selectedRole.value);
  }
}
