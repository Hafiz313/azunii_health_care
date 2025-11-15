import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';

class Settingsview extends StatelessWidget {
  static const String routeName = '/settings-caregiver';
  
  const Settingsview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: headingText1(
            'Caregiver Settings',
            color: AppColors.headingTextColor,
          ),
        ),
      ),
    );
  }
}