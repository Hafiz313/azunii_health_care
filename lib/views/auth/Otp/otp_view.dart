// import 'package:Azunii_Health/consts/lang.dart';
// import 'package:Azunii_Health/networking/api_provider.dart';
// import 'package:Azunii_Health/utils/my_loader.dart';
// import 'package:Azunii_Health/utils/percentage_size_ext.dart';
// import 'package:Azunii_Health/views/widget/text.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import '../../../consts/assets.dart';
// import '../../../consts/colors.dart';
// import '../../base_view/base_scaffold_auth.dart';
// import '../../widget/buttons.dart';
// import '../../widget/text_fields.dart';
// import '../login/controller/login_controller.dart';

// class OtpView extends StatelessWidget {
//   OtpView({super.key});
//   static const String routeName = '/otpView';

//   final formKey = GlobalKey<FormState>();
//   final otpTxtField = TextEditingController();
//   final controller = Get.find<LoginController>();

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffoldAuth(
//       body: SizedBox(
//         width: double.infinity,
//         child: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: context.percentHeight * 8.0),
//                 SvgPicture.asset(AppAssets.logoMain,
//                     width: context.percentWidth * 40.0),
//                 Container(
//                   margin: EdgeInsets.symmetric(
//                     vertical: context.percentHeight * 4.0,
//                     horizontal: context.percentWidth * 5.0,
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: context.percentWidth * 4.0,
//                     vertical: context.percentHeight * 3.0,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius:
//                         BorderRadius.circular(context.percentHeight * 0.5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(height: context.percentHeight * 1.5),
//                       headline5(Lang.enterOtpCode, color: AppColors.blue),
//                       SizedBox(height: context.percentHeight * 1.0),
//                       subText5(
//                         Lang.otpText,
//                         color: AppColors.blackColor,
//                         fontWeight: FontWeight.bold,
//                         align: TextAlign.center,
//                       ),
//                       SizedBox(height: context.percentHeight * 3.0),
//                       CustomTxtField(
//                         hintTxt: Lang.enterOtpCode,
//                         textEditingController: otpTxtField,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                         maxLength: 6,
//                         suffixIcon: Icon(
//                           FontAwesomeIcons.checkCircle,
//                           color: AppColors.borderColor,
//                           size: context.screenHeight * 0.02,
//                         ),
//                         validator: (String? val) {
//                           if (val == null || val.isEmpty) {
//                             return Lang.empty;
//                           } else if (val.length < 6) {
//                             return "OTP not correct";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: context.percentHeight * 3.0),
//                       Obx(() => mainLoading.value
//                           ? const MyLoader()
//                           : Column(
//                               children: [
//                                 AppElevatedButton(
//                                   backgroundColor: AppColors.blue,
//                                   onPressed: () {
//                                     if (formKey.currentState!.validate()) {
//                                       controller.verifyOtp(
//                                         context,
//                                         otp: otpTxtField.text,
//                                       );
//                                     }
//                                   },
//                                   title: Lang.verify,
//                                 ),
//                                 SizedBox(height: context.percentHeight * 2.0),
//                                 Text.rich(
//                                   TextSpan(
//                                     text: Lang.didntReceived,
//                                     style: TextStyle(
//                                         fontSize: context.percentHeight * 1.6),
//                                     children: [
//                                       TextSpan(
//                                         text: " ${Lang.sendAgain}",
//                                         style: TextStyle(
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.bold,
//                                           decoration: TextDecoration.underline,
//                                         ),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () {
//                                             final email =
//                                                 controller.emailTxtField.text;
//                                             final password = controller
//                                                 .passwordTxtField.text;

//                                             controller.loginApi(context,
//                                                 email: email,
//                                                 password: password,
//                                                 moveToOtp: false);
//                                           },
//                                       ),
//                                     ],
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
