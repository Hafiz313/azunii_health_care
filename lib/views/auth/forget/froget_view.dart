import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/networking/api_provider.dart';
import 'package:azunii_health_care/utils/my_loader.dart';
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

class ForgetView extends StatelessWidget {
  ForgetView({super.key});
  static const String routeName = '/ForgetView';
  ForgetController controller = Get.put(ForgetController());
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
        borderRadius: BorderRadius.circular(context.percentHeight * 0.5),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Text(
              Lang.forgetPassword.toUpperCase(),
              style: TextStyle(
                fontSize: context.percentHeight * 2.5,
                fontWeight: FontWeight.bold,
                color: AppColors.borderColor,
              ),
            ),
            SizedBox(height: context.percentHeight * 2.0),
            buildEmailField(context, controller.emailTxtField),
            SizedBox(height: context.percentHeight * 3.0),
            Obx(
              () => mainLoading.value
                  ? const MyLoader()
                  : btn(context, onPress: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.forget(context);
                      }
                    }),
            ),
            SizedBox(height: context.percentHeight * 1),
          ],
        ),
      ),
    );
  }

  static Widget buildEmailField(
      BuildContext context, TextEditingController textEditingController) {
    return CustomTxtField(
      title: Lang.email,
      hintTxt: Lang.enterYourEmail,
      // enabled: !mainLoading.value,
      textEditingController: textEditingController,
      prefixIcon: Icon(
        FontAwesomeIcons.envelope,
        color: AppColors.borderColor,
        size: context.percentHeight * 2.0,
      ),
      validator: (String? val) {
        if (val!.isEmpty) return Lang.empty;
        if (!emailExp.hasMatch(val)) return Lang.empty;
        return null;
      },
    );

    // CustomTxtField(
    //   hintTxt: Lang.email,
    //   textEditingController: textEditingController,
    //   suffixIcon: Icon(
    //     FontAwesomeIcons.solidEnvelope,
    //     color: AppColors.borderColor,
    //     size: context.percentHeight * 2.0,
    //   ),
    //   validator: (String? val) {
    //     if (val!.isEmpty) return Lang.empty;
    //     if (!emailExp.hasMatch(val)) return Lang.empty;
    //     return null;
    //   },
    // );
  }

  static Widget btn(BuildContext context, {required Function() onPress}) {
    return AppElevatedButton(
      backgroundColor: AppColors.secondary,
      onPressed: onPress,
      title: Lang.getCode,
    );
  }
}
