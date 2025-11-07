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
import '../../home/home_view.dart';
import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
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
      hintTxt: Lang.email,
      // enabled: !mainLoading.value,
      textEditingController: controller.emailTxtField,
      // suffixIcon: Icon(
      //   FontAwesomeIcons.solidEnvelope,
      //   color: AppColors.borderColor,
      //   size: context.percentHeight * 2.0,
      // ),
      validator: (String? val) {
        if (val!.isEmpty) return Lang.empty;
        if (!emailExp.hasMatch(val)) return Lang.empty;
        return null;
      },
    );
  }

  static Widget buildPasswordField(
      BuildContext context, LoginController controller) {
    return Obx(() => CustomTxtField(
          hintTxt: Lang.password,
          // enabled: !mainLoading.value,
          textEditingController: controller.passwordTxtField,
          keyboardType: TextInputType.visiblePassword,
          isHiddenPassword: controller.isPasswordVisible.value,
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
            if (val!.isEmpty) return Lang.empty;
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
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                value: controller.isChecked.value,
                onChanged: controller.toggleRememberMe,
                side: BorderSide(color: AppColors.borderColor, width: 1.5),
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
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
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
      backgroundColor: AppColors.blue,
      onPressed: onPress,
      title: Lang.logIn,
    );
  }
}
