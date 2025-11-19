import 'package:Azunii_Health/consts/lang.dart';
import 'package:Azunii_Health/networking/api_provider.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/logo_widget.dart';
import 'package:Azunii_Health/views/widget/loading_overlay.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../base_view/base_scaffold_auth.dart';

import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
import '../login/login_view.dart';
import 'controller/signup_controller.dart';
import 'signup_widgets.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  static const String routeName = '/SignUpView';

  final SignUpController controller = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingOverlay(
          isLoading: mainLoading.value,
          child: BaseScaffoldAuth(
            body: Form(
              key: controller.formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.percentWidth * 4.0,
                  vertical: context.percentHeight * 1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: context.percentWidth * 80.0,
                        child: LogoWidget()),
                    SizedBox(
                      height: context.screenHeight * 0.02,
                    ),
                    Text(
                      Lang.welcomeyou,
                      style: GoogleFonts.michroma(
                        fontSize: context.percentHeight * 2.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.015,
                    ),
                    CustomTxtField(
                      title: Lang.fullName,
                      hintTxt: Lang.enterYourFullName,
                      textEditingController: controller.nameTxtField,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.borderColor,
                        size: context.percentHeight * 3,
                      ),
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return 'Please enter full name';
                        }
                      },
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.005,
                    ),
                    CustomTxtField(
                      title: Lang.email,
                      hintTxt: Lang.enterYourEmail,
                      textEditingController: controller.emailTxtField,
                      prefixIcon: Icon(
                        FontAwesomeIcons.envelope,
                        color: AppColors.borderColor,
                        size: context.percentHeight * 2.0,
                      ),
                      validator: (String? val) {
                        if (val!.isEmpty) return Lang.pleaseEnterYourEmail;
                        if (!emailExp.hasMatch(val))
                          return Lang.pleaseEnterCorrectEmail;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.005,
                    ),
                    CustomTxtField(
                      title: Lang.password,
                      hintTxt: Lang.enterYourPassword,
                      textEditingController: controller.passwordTxtField,
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
                      height: context.screenHeight * 0.005,
                    ),
                    CustomTxtField(
                      title: Lang.verifyPassword,
                      hintTxt: Lang.verifyPassword,
                      textEditingController: controller.confirmPasswordTxtField,
                      isHiddenPassword:
                          controller.isConformPasswordVisible.value,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.borderColor,
                        size: context.percentHeight * 2.5,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => controller.isConformPasswordVisible.value =
                            !controller.isConformPasswordVisible.value,
                        child: Icon(
                          controller.isConformPasswordVisible.value
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
                    SizedBox(
                      height: context.percentHeight * 2.0,
                    ),
                    SizedBox(
                      height: context.percentHeight * 2.0,
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            AppElevatedButton(
                                backgroundColor: AppColors.secondary,
                                onPressed: () {
                                  SignUpWidgets.showUserTypeDialog(
                                      context, true);
                                },
                                title: Lang.signUp),
                            SizedBox(
                              height: context.percentHeight * 2.0,
                            ),
                            SizedBox(
                              height: context.percentHeight * 2.0,
                            ),
                            SignUpWidgets.buildSocialButtons(context),
                            SizedBox(
                              height: context.percentHeight * 2.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //git  crossAxigitsAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    subText4(
                                      Lang.alreadyText,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(width: context.percentWidth * 1),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, LoginView.routeName);
                                        },
                                        child: subText4(
                                          Lang.signIn,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primary,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Obx(() => mainLoading.value
                        //     ? Positioned.fill(
                        //         child: Container(
                        //           color: Colors.black.withOpacity(0.3),
                        //           child: const Center(
                        //             child: MyLoader(),
                        //           ),
                        //         ),
                        //       )
                        //     : const SizedBox.shrink()),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
