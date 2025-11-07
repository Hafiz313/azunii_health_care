import 'package:flutter/material.dart';

import '../../consts/colors.dart';
import '../../consts/fonts.dart';

class CustomTxtFieldV1 extends StatelessWidget {
  final Widget? hintTxt;
  final bool isHiddenPassword;
  final bool enabled;
  final bool isRequired;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  final TextEditingController? textEditingController;

  const CustomTxtFieldV1(
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
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      enabled: enabled,
      cursorColor: AppColors.green,
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
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(5)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(5)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColors.redColor),
            borderRadius: BorderRadius.circular(5)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // hintText: widget(child: hintTxt),
        fillColor: const Color(0xFFFAFAFA),
        filled: true,
        label: Row(
          children: [
            // Text(hintTxt!,style: const TextStyle(color: AppColors.borderColor),),
            hintTxt!,
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(
                  color: AppColors.redColor,
                ),
              )
          ],
        ),
        hintStyle: TextStyle(
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
