import 'package:azunii_health_care/networking/api_provider.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/auth/forget/froget_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../base_view/base_scaffold.dart';
import '../../patient/home/home_view.dart';
import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
import '../../widget/social_button.dart';
import 'controller/login_controller.dart';

class LoginWidgets {
  static Widget buildLogo(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: context.percentWidth * 40.0,
      height: context.percentHeight * 15.0,
    );
  }

  static Widget buildEmailField(
      BuildContext context, LoginController controller) {
    return CustomTxtField(
      title: Lang.email,
      hintTxt: Lang.enterYourEmail,
      // enabled: !mainLoading.value,
      textEditingController: controller.emailTxtField,
      prefixIcon: Icon(
        FontAwesomeIcons.envelope,
        color: AppColors.borderColor,
        size: context.percentHeight * 2.0,
      ),
      validator: (String? val) {
        if (val!.isEmpty) return Lang.enterYourEmail;
        if (!emailExp.hasMatch(val)) return Lang.enterYourEmail;
        return null;
      },
    );
  }

  static Widget buildPasswordField(
      BuildContext context, LoginController controller) {
    return Obx(() => CustomTxtField(
          title: Lang.password,
          hintTxt: Lang.enterYourPassword,
          // enabled: !mainLoading.value,
          textEditingController: controller.passwordTxtField,
          keyboardType: TextInputType.visiblePassword,
          isHiddenPassword: controller.isPasswordVisible.value,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: AppColors.borderColor,
            size: context.percentHeight * 2.5,
          ),
          suffixIcon: InkWell(
            onTap: () => controller.isPasswordVisible.value =
                !controller.isPasswordVisible.value,
            child: Icon(
              controller.isPasswordVisible.value
                  ? FontAwesomeIcons.eye
                  : FontAwesomeIcons.eyeSlash,
              color: AppColors.borderColor,
              size: context.percentHeight * 2.0,
            ),
          ),
          validator: (String? val) {
            if (val!.isEmpty) return Lang.enterYourPassword;
            return null;
          },
        ));
  }

  static Widget buildRememberMeAndForgotPassword(
      BuildContext context, LoginController controller) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: context.percentHeight * 2.5,
                width: context.percentHeight * 2.5,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.isChecked.value
                        ? AppColors.secondary
                        : AppColors.borderColor,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Transform.scale(
                  scale: 0.7,
                  child: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    value: controller.isChecked.value,
                    onChanged: controller.toggleRememberMe,
                    side: BorderSide(
                        color: controller.isChecked.value
                            ? AppColors.secondary
                            : AppColors.borderColor,
                        width: 0.8),
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppColors.secondary;
                        }
                        return Colors.transparent;
                      },
                    ),
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: context.percentWidth * 2,
              ),
              Text(
                Lang.rememberMe,
                style: TextStyle(color: AppColors.headingTextColor),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              debugPrint("Forgot Password Tapped");
              Navigator.pushNamed(context, ForgetView.routeName);
            },
            child: const Text(
              Lang.forgotPassword,
              style: TextStyle(
                color: AppColors.redColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget saveDeviceForFurtherUse(
      BuildContext context, LoginController controller) {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            value: controller.isSaveThisDevice.value,
            onChanged: controller.toggleSaveThisDevice,
            side: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          const Text(
            Lang.saveThisDeviceForFurtherUse,
            style: TextStyle(color: AppColors.headingTextColor),
          ),
        ],
      ),
    );
  }

  static Widget buildLoginButton(BuildContext context,
      {required Function() onPress}) {
    return AppElevatedButton(
      backgroundColor: AppColors.secondary,
      onPressed: onPress,
      title: Lang.signIn,
    );
  }

  static Widget buildSocialButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            text: Lang.google,
            iconPath: AppAssets.googleIcon,
            onPressed: () {
              // Handle Google sign in
            },
          ),
        ),
        SizedBox(width: context.percentWidth * 4.0),
        Expanded(
          child: SocialButton(
            text: Lang.apple,
            iconPath: AppAssets.appleIcon,
            onPressed: () {
              // Handle Apple sign in
            },
          ),
        ),
      ],
    );
  }
}
