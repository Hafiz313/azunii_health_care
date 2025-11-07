import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../consts/colors.dart';
import '../../consts/fonts.dart';

class CustomTxtField extends StatelessWidget {
  final String? hintTxt;
  final bool isHiddenPassword;
  final bool enabled;
  final bool isRequired;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  int? maxLength;
  List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  final TextEditingController? textEditingController;

  CustomTxtField(
      {Key? key,
      this.hintTxt,
      this.validator,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.textEditingController,
      this.maxLength,
      this.inputFormatters,
      this.isHiddenPassword = false,
      this.prefixIcon,
      this.suffixIcon,
      this.enabled = true,
      this.isRequired = false,
      this.hintStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      enabled: enabled,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.green,
      maxLength: maxLength,
      keyboardType: keyboardType,
      controller: textEditingController,
      obscureText: isHiddenPassword,
      validator: validator,
      style: const TextStyle(
          color: AppColors.blackColor,
          fontFamily: FontFamily.satoshi,
          fontWeight: FontWeight.w500,
          fontSize: 17),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.blackColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(10)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintTxt,
        fillColor: const Color(0xFFFAFAFA),
        filled: true,
        label: Row(
          children: [
            Text(
              hintTxt!,
              overflow: TextOverflow.ellipsis,
              style: hintStyle ?? const TextStyle(color: Colors.black),
            ),
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(
                  color: AppColors.redColor,
                ),
              )
          ],
        ),
        hintStyle: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: FontFamily.satoshi,
            fontSize: 17,
            fontWeight: FontWeight.w200),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }
}
