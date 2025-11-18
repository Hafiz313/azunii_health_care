import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/auth/forget/froget_view.dart';
import 'package:Azunii_Health/views/auth/login/controller/login_controller.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return LogoWidget();
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
        if (val!.isEmpty) return Lang.pleaseEnterYourEmail;
        if (!emailExp.hasMatch(val)) return Lang.pleaseEnterCorrectEmail;
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
      onPressed: () {
        _showUserTypeDialog(context, true);
        // Get.snackbar(
        //   'Coming Soon',
        //   'Only Google Sign-In is available for now',
        //   backgroundColor: AppColors.primary,
        //   colorText: AppColors.white,
        //   snackPosition: SnackPosition.TOP,

        //  );
      },
      title: Lang.signIn,
    );
  }

  static Widget buildSocialButtons(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            text: Lang.google,
            iconPath: AppAssets.googleIcon,
            onPressed: () => _showUserTypeDialog(context, false),
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

  static void _showUserTypeDialog(BuildContext context, bool isonloginApi) {
    try {
      final controller = Get.find<LoginController>();
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
                      try {
                        Navigator.pop(context);
                        isonloginApi
                            ? controller.loginInAsPatient(context)
                            : controller.signInAsPatient(context);
                      } catch (e) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign in as Patient',
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
                      try {
                        Navigator.pop(context);
                        isonloginApi
                            ? controller.loginInAsCaregiver(context)
                            : controller.signInAsCaregiver(context);
                      } catch (e) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign in as Caregiver',
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
    } catch (e) {
      // Handle dialog creation error
    }
  }
}
