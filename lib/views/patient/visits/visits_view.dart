import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';

class VisitsView extends StatelessWidget {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.userDoctor,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              headingText1(
                'Visits',
                color: AppColors.headingTextColor,
              ),
              const SizedBox(height: 10),
              subText3(
                'Manage your doctor visits',
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}