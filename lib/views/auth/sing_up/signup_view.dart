import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/networking/api_provider.dart';
import 'package:azunii_health_care/utils/my_loader.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_view.dart';
import 'package:azunii_health_care/views/auth/term_conditions_view.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../base_view/base_scaffold_auth.dart';

import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
import '../login/login_view.dart';
import 'controller/signup_controller.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  static const String routeName = '/SignUpView';

  final SignUpController controller = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldAuth(
        body: Obx(() => Form(
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
                      width: context.percentWidth * 50.0,
                      child: Image.asset(AppAssets.logo),
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.02,
                    ),
                    headline5('WELCOME YOU', color: AppColors.blue),
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
                    //CustomTxtField(
                    //   hintTxt: Lang.ssn,
                    //   textEditingController: controller.ssnTxtField,
                    //   inputFormatters: [
                    //     FilteringTextInputFormatter.digitsOnly,
                    //     SSNInputFormatter(),
                    //     LengthLimitingTextInputFormatter(11),
                    //   ],
                    //   // suffixIcon: Icon(
                    //   //   FontAwesomeIcons.hashtag,
                    //   //   color: AppColors.borderColor,
                    //   //   size: context.screenHeight * 0.02,
                    //   // ),
                    //   isRequired: true,
                    //   validator: (String? val) {
                    //     if (val!.isEmpty) {
                    //       return Lang.empty;
                    //     }
                    //
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: context.screenHeight * 0.01,
                    // ),
                    // CustomTxtField(
                    //   hintTxt: Lang.companyRegisteredEmail,
                    //   textEditingController:
                    //       controller.companyRegisteredTxtField,
                    //   suffixIcon: Icon(
                    //     FontAwesomeIcons.solidEnvelope,
                    //     color: AppColors.borderColor,
                    //     size: context.screenHeight * 0.02,
                    //   ),
                    //   validator: (String? val) {},
                    // ),
                    // SizedBox(
                    //   height: context.screenHeight * 0.01,
                    // ),
                    CustomTxtField(
                      title: Lang.email,
                      hintTxt: Lang.enterYourEmail,
                      textEditingController: controller.empRegisteredTxtField,
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
                    // subText5(
                    //     "Note: Password must contain at least one uppercase letter, one number, and one special character ",
                    //     fontWeight: FontWeight.normal,
                    //     color: AppColors.blackColor),
                    // SizedBox(
                    //   height: context.percentHeight * 2.0,
                    // ),
                    // Row(
                    //   children: [
                    //     Obx(() => Checkbox(
                    //           side: const BorderSide(
                    //               color: AppColors.textColor),
                    //           value: controller
                    //               .acceptTermsAndConditions.value,
                    //           onChanged: (bool? value) {
                    //             controller.acceptTermsAndConditions
                    //                 .value = value ?? false;
                    //           },
                    //           activeColor: AppColors.blue,
                    //           checkColor: AppColors.white,
                    //         )),
                    //     InkWell(
                    //       onTap: () {
                    //         showDialog(
                    //             context: context,
                    //             builder: (context) =>
                    //                 TermsConditionView());
                    //       },
                    //       child: subText5("Accept Terms & Condition",
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.normal,
                    //           color: AppColors.blackColor),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: context.percentHeight * 2.0,
                    ),
                    Obx(() => mainLoading.value
                        ? const MyLoader()
                        : Column(
                            children: [
                              AppElevatedButton(
                                  backgroundColor: AppColors.secondary,
                                  onPressed: () => controller.signup(context),
                                  title: Lang.signUp),
                              SizedBox(
                                height: context.percentHeight * 2.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                          ))
                  ],
                ),
              ),
            )));
  }
}
