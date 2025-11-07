import 'package:flutter/material.dart';


import '../../consts/colors.dart';
import '../../consts/fonts.dart';

class SearchTxtField extends StatelessWidget {
  final String? hintTxt;
  final bool isHiddenPassword;
  final bool enabled;
  final bool isRequired;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;

  final TextEditingController? textEditingController;

  const SearchTxtField(
      {super.key,
      this.hintTxt,
      this.validator,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.textEditingController,
      this.isHiddenPassword = false, this.prefixIcon, this.suffixIcon,  this.enabled=true,  this.isRequired=false, this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      enabled: enabled,
      cursorColor: AppColors.white,
      keyboardType:keyboardType ,
      controller: textEditingController,
      obscureText: isHiddenPassword,
      validator: validator,
      style: const TextStyle(
          color: AppColors.blackColor,
          fontFamily: FontFamily.satoshi,
          fontWeight: FontWeight.w500,
          fontSize: 17),
      decoration: InputDecoration(
        border:  const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        enabledBorder:const UnderlineInputBorder(

          borderSide: BorderSide(color: AppColors.white),
        ),
        focusedBorder:const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        errorBorder:const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.redColor),
        ),
        prefixIcon:prefixIcon,
        suffixIcon: suffixIcon,
        // hintText: hintTxt,
        fillColor: AppColors.primary,
        filled: true,
        label: Row(
          children:  [
            Text(hintTxt!,style: hintStyle?? const TextStyle(color: AppColors.borderColor),),
           if(isRequired)
            const Text('*',style:TextStyle(color: AppColors.redColor,),)

          ],
        ),
        hintStyle: hintStyle??TextStyle(
            color: AppColors.blackColor,
            fontFamily: FontFamily.satoshi,
            fontSize: 17,
            fontWeight: FontWeight.w200),
        contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      ),
    );
  }
}
