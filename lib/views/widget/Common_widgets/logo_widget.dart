import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';

class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const LogoWidget({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: context.percentWidth * 55.0,
              child: Image.asset(AppAssets.logoMain),
            ),
            //  SizedBox(height: context.percentHeight * 1.0),
            // Text(
            //   Lang.appName,
            //   style: GoogleFonts.michroma(
            //     color: AppColors.darkNavy,
            //     fontSize: 16,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(height: context.percentHeight * 1.0),
            // Text(
            //   Lang.appSlang,
            //   style: GoogleFonts.manrope(
            //     color: AppColors.textColor,
            //     fontSize: 13,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
