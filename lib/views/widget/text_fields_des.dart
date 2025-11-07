import 'package:flutter/material.dart';

import '../../consts/colors.dart';
import '../../consts/fonts.dart';

class CustomTxtFieldDes extends StatelessWidget {
  final String? hintTxt;
  final bool isHiddenPassword;
  final int maxLines;
  final bool enabled;
  final bool isRequired;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  final TextEditingController? textEditingController;

  const CustomTxtFieldDes(
      {Key? key,
      this.hintTxt,
      this.validator,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.textEditingController,
      this.isHiddenPassword = false,
      this.prefixIcon,
      this.suffixIcon,
      this.enabled = true,
      this.isRequired = false,
      this.maxLines = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      enabled: enabled,
      cursorColor: AppColors.green,
      keyboardType: keyboardType,
      controller: textEditingController,
      maxLines: maxLines,
      obscureText: isHiddenPassword,
      validator: validator,
      style: const TextStyle(
          color: AppColors.blackColor,
          fontFamily: FontFamily.satoshi,
          fontWeight: FontWeight.w500,
          fontSize: 17),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(5)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(5)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColors.redColor),
            borderRadius: BorderRadius.circular(5)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // hintText: widget(child: hintTxt),
        fillColor: const Color(0xFFFAFAFA),
        filled: true,
        hintText: hintTxt,

        hintStyle: TextStyle(
            color: AppColors.blackColor,
            fontFamily: FontFamily.satoshi,
            fontSize: 17,
            fontWeight: FontWeight.normal),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }
}
