import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../consts/colors.dart';
import '../../consts/fonts.dart';
import '../../utils/percentage_size_ext.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.percentHeight * 1.5,
          horizontal: context.percentWidth * 4.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.borderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: context.percentHeight * 4.0,
              width: context.percentHeight * 4.0,
              fit: BoxFit.contain,
            ),
            SizedBox(width: context.percentWidth * 3.0),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
