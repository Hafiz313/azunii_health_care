import 'package:flutter/material.dart';

import '../../../consts/assets.dart';

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
              height: context.screenHeight * 0.02,
            ),
            SizedBox(
              width: context.percentWidth * 40.0,
              child: Image.asset(AppAssets.logoMain),
            ),
          ],
        ),
      ),
    );
  }
}
