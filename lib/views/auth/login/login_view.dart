import 'package:Azunii_Health/consts/lang.dart';

import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/auth/login/login_widgets.dart';
import 'package:Azunii_Health/views/auth/sing_up/signup_view.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:local_auth/local_auth.dart';
import '../../../consts/colors.dart';
import '../../base_view/base_scaffold_auth.dart';
import '../../widget/text.dart';

import 'controller/login_controller.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  static const String routeName = '/loginView';
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());
  final LocalAuthentication auth = LocalAuthentication();
  bool _showFingerprint = false;
  bool _showFace = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoader(
        isLoading: controller.isLoading.value,
        child: BaseScaffoldAuth(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.percentWidth * 5.0,
                vertical: context.percentHeight * 5.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: context.screenHeight * 0.03,
                  ),
                  LoginWidgets.buildLogo(context),
                  SizedBox(height: context.percentHeight * 1.0),
                  _buildFormContainer(context),
                  SizedBox(
                    height: context.percentHeight * 2.0,
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Widget _buildFormContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 0.02,
          vertical: context.percentHeight * 0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.percentHeight * 0.5),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(children: [
          Text(
            Lang.welcomeBack,
            style: GoogleFonts.michroma(
              fontSize: context.percentWidth * 6.25,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: context.percentHeight * 2.0),
          LoginWidgets.buildEmailField(context, controller),
          SizedBox(height: context.percentHeight * 2.0),
          LoginWidgets.buildPasswordField(context, controller),
          SizedBox(height: context.percentHeight * 2.0),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoginWidgets.buildRememberMeAndForgotPassword(
                      context, controller),
                  SizedBox(height: context.percentHeight * 2.0),
                  SizedBox(height: context.percentHeight * 3),
                  LoginWidgets.buildLoginButton(context,
                      onPress: () => controller.login()),
                  SizedBox(height: context.percentHeight * 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      subText4(
                        Lang.donntHaveAnAccount,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                        context: context,
                      ),
                      SizedBox(width: context.percentWidth * 5),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, SignUpView.routeName);
                          },
                          child: subText4(
                            Lang.signUp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                            context: context,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: context.percentHeight * 3,
                  ),
                  LoginWidgets.buildSocialButtons(context),
                  SizedBox(height: context.percentHeight * 2),
                  // FCM Test Button
                                  ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
