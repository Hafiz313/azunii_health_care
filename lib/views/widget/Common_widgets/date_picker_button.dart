import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../utils/percentage_size_ext.dart';
import '../text.dart';

class DatePickerButton extends StatelessWidget {
  final String date;
  final VoidCallback? onTap;

  const DatePickerButton({
    super.key,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.dividerGray,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.calander,
                width: 13,
                height: 13,
                colorFilter: const ColorFilter.mode(
                  AppColors.textColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  fontSize: context.percentHeight * 1.5,
                  fontWeight: FontWeight.normal,
                  color: AppColors.headingTextColor,
                  fontFamily: 'Satoshi',
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
