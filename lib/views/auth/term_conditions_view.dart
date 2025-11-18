import 'package:Azunii_Health/consts/lang.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../consts/assets.dart';
import '../../consts/colors.dart';
import '../base_view/base_scaffold_auth.dart';
import '../widget/buttons.dart';

class TermsConditionView extends StatelessWidget {
  TermsConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool _isChecked = false.obs;
    return SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.only(
              top: context.percentHeight * 8.0,
              bottom: context.percentHeight * 8.0,
              left: context.percentHeight * 3.0,
              right: context.percentHeight * 3.0),
          padding: EdgeInsets.symmetric(
              horizontal: context.percentWidth * 4.0,
              vertical: context.percentHeight * 2),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(context.percentHeight * 0.3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subText1(
                    Lang.termsCondition,
                    color: AppColors.headingTextColor,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        FontAwesomeIcons.circleXmark,
                        color: AppColors.redColor,
                      )),
                ],
              ),
              SizedBox(
                height: context.percentHeight * 1.0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      subText4(
                        Lang.termsConditionText,
                        align: TextAlign.start,
                      )
                    ],
                  ),
                ),
              ),
              // Container(
              //   margin:
              //       EdgeInsets.symmetric(vertical: context.percentHeight * 1.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Obx(
              //         () => Checkbox(
              //           value: _isChecked.value,
              //           onChanged: (bool? value) {
              //             _isChecked.value = value ?? false;
              //           },
              //         ),
              //       ),
              //       subText4(
              //         Lang.acceptTerms,
              //         color: AppColors.headingTextColor,
              //       ),
              //     ],
              //   ),
              // ),
              AppElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // if(_isChecked.value){
                    //   Navigator.pushReplacementNamed(context,  SignUpView.routeName);
                    //
                    // }else{
                    //   //
                    //   Fluttertoast.showToast(
                    //       msg: "Please review and accept the Terms & Conditions to proceed",
                    //       //Empty
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.SNACKBAR,
                    //       timeInSecForIosWeb: 2,
                    //       backgroundColor: Colors.red,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0);
                    // }
                  },
                  title: Lang.ok),
            ],
          ),
        ));
  }
}
