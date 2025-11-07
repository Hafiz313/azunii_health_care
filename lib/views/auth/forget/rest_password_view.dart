import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/auth/login/login_widgets.dart';
import 'package:azunii_health_care/views/auth/sing_up/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../base_view/base_scaffold_auth.dart';
import '../../widget/buttons.dart';
import '../../widget/text.dart';
import '../../widget/text_fields.dart';
import '../login/controller/login_controller.dart';
import 'controller/forget_controller.dart';

class RestPasswordView extends StatelessWidget {
  RestPasswordView({super.key});
  static const String routeName = '/RestPasswordView';
  var controller = Get.find<ForgetController>();
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldAuth(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.percentWidth * 5.0,
            vertical: context.percentHeight * 5.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginWidgets.buildLogo(context),
              SizedBox(height: context.percentHeight * 3.0),
              _buildFormContainer(context),
              SizedBox(
                height: context.percentHeight * 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.percentHeight * 2.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.percentHeight * 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: controller.restFormKey,
        child: Column(
          children: [
            Text(
              Lang.restPassword.toUpperCase(),
              style: TextStyle(
                fontSize: context.percentHeight * 2.5,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
            SizedBox(height: context.percentHeight * 2.0),
            CustomTxtField(
              hintTxt: Lang.password,
              textEditingController: controller.passwordTxtField,
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
                if (val == null || val.isEmpty) {
                  return "Password cannot be empty";
                }
                if (!RegExp(
                        r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
                    .hasMatch(val)) {
                  return "Weak password!";
                }
                return null;
              },
            ),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            CustomTxtField(
              hintTxt: Lang.confirmPassword,
              textEditingController: controller.confirmPasswordTxtField,
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
                if (controller.passwordTxtField.text !=
                    controller.confirmPasswordTxtField.text) {
                  return "Password not match";
                }
                return null;
              },
            ),
            SizedBox(height: context.percentHeight * 3.0),
            btn(context, onPress: () {
              if (controller.restFormKey.currentState!.validate()) {
                controller.restPassword(context);
              }
            }),
            SizedBox(height: context.percentHeight * 1),
          ],
        ),
      ),
    );
  }

  static Widget btn(BuildContext context, {required Function() onPress}) {
    return AppElevatedButton(
      backgroundColor: AppColors.blue,
      onPressed: onPress,
      title: Lang.getCode,
    );
  }
}
