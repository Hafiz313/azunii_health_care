import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/networking/api_provider.dart';
import 'package:azunii_health_care/utils/my_loader.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/auth/login/login_widgets.dart';
import 'package:azunii_health_care/views/auth/sing_up/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
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
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      List<BiometricType> available = await auth.getAvailableBiometrics();
      if (mounted) {
        setState(() {
          _showFingerprint =
              canCheck && available.contains(BiometricType.fingerprint);
          _showFace = canCheck && available.contains(BiometricType.face);
        });
      }
    } catch (e) {
      setState(() {
        _showFingerprint = false;
        _showFace = false;
      });
    }
  }

  Future<void> _authenticateAndLogin(BuildContext context) async {
    try {
      bool isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) {
        print("Biometric not available");
        return;
      }

      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        print("Authenticated successfully!");
      } else {
        print("Authentication failed.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

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
            style: TextStyle(
              fontSize: context.percentHeight * 2.5,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: context.percentHeight * 2.0),
          LoginWidgets.buildEmailField(context, controller),
          SizedBox(height: context.percentHeight * 2.0),
          LoginWidgets.buildPasswordField(context, controller),
          SizedBox(height: context.percentHeight * 2.0),
          Obx(() => mainLoading.value
              ? const MyLoader()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoginWidgets.buildRememberMeAndForgotPassword(
                        context, controller),
                    SizedBox(height: context.percentHeight * 2.0),
                    // Biometric login button
                    // if (Platform.isAndroid)
                    if (Platform.isAndroid && _showFingerprint)
                      Column(
                        children: [
                          Icon(Icons.fingerprint,
                              size: context.percentHeight * 5,
                              color: AppColors.primary),
                          SizedBox(height: context.percentHeight * 1),
                          GestureDetector(
                            onTap: () => _authenticateAndLogin(context),
                            child: const Text(
                              'Login with Fingerprint',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: context.percentHeight * 2.0),
                        ],
                      ),
                    // if (Platform.isIOS)
                    if (Platform.isIOS && _showFace)
                      Column(
                        children: [
                          Icon(Icons.face_6,
                              size: context.percentHeight * 5,
                              color: AppColors.primary),
                          SizedBox(height: context.percentHeight * 1),
                          GestureDetector(
                            onTap: () => _authenticateAndLogin(context),
                            child: const Text(
                              'Login with Face Recognition',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: context.percentHeight * 2.0),
                        ],
                      ),
                    SizedBox(height: context.percentHeight * 4),
                    LoginWidgets.buildLoginButton(context,
                        onPress: () => controller.login(context)),
                    SizedBox(height: context.percentHeight * 4.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        subText4(
                          Lang.donntHaveAnAccount,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
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
                            )),
                      ],
                    ),
                    SizedBox(
                      height: context.percentHeight * 1,
                    ),
                    SizedBox(
                      width: context.screenWidth * 0.6,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF9CA3AF).withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF9CA3AF).withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.percentHeight * 5,
                    ),
                    LoginWidgets.buildSocialButtons(context),
                  ],
                ))
        ]),
      ),
    );
  }
}
