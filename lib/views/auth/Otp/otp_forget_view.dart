import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/networking/api_provider.dart';
import 'package:azunii_health_care/utils/my_loader.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/auth/login/login_view.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../base_view/base_scaffold_auth.dart';
import '../../widget/buttons.dart';
import '../forget/controller/forget_controller.dart';

class OtpForgetView extends StatelessWidget {
  OtpForgetView({super.key});
  static const String routeName = '/OtpForgetView';

  final controller = Get.find<ForgetController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldAuth(
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: controller.otpFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.percentHeight * 8.0),
                SvgPicture.asset(AppAssets.logoMain, width: context.percentWidth * 40.0),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: context.percentHeight * 4.0,
                    horizontal: context.percentWidth * 5.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.percentWidth * 4.0,
                    vertical: context.percentHeight * 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(context.percentHeight * 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: context.percentHeight * 1.5),
                      headline5(Lang.enterOtpCode, color: AppColors.blue),
                      SizedBox(height: context.percentHeight * 1.0),
                      subText5(
                        Lang.otpText,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                      ),
                      SizedBox(height: context.percentHeight * 3.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: context.percentWidth * 10,
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            child: TextField(
                              controller: controller.otpControllers[index],
                              focusNode: controller.otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: const EdgeInsets.all(10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).requestFocus(
                                      controller.otpFocusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(
                                      controller.otpFocusNodes[index - 1]);
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: context.percentHeight * 3.0),
                      Obx(() => mainLoading.value
                          ? MyLoader()
                          : Column(
                              children: [
                                AppElevatedButton(
                                  backgroundColor: AppColors.blue,
                                  onPressed: () {
                                    String otp = controller.otpCode;
                                    if (otp.length != 6) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please enter the 6-digit OTP.'),
                                        ),
                                      );
                                      return;
                                    }
                                    controller.verifyOtp(context, otp: otp);
                                  },
                                  title: "Verify",
                                ),
                                SizedBox(height: context.percentHeight * 2.0),
                                Text.rich(
                                  TextSpan(
                                    text: "Didn’t Receive Code? ",
                                    style: TextStyle(
                                        fontSize: context.percentHeight * 1.6),
                                    children: [
                                      TextSpan(
                                        text: "Send Again",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            controller.forget(context,
                                                moveToOtp: false);
                                          },
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
