import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
                FontAwesomeIcons.house,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              headingText1(
                'Home',
                color: AppColors.headingTextColor,
              ),
              const SizedBox(height: 10),
              subText3(
                'Welcome to your dashboard',
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}