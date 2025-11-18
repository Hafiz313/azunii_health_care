import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/dashboard.dart';
import 'package:Azunii_Health/views/patient/dashboard/patient_dashboard.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  SplashView({super.key});
  static const String routeName = '/SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userTypeKey = 'userType';

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();

    // Check login status and navigate accordingly after 3s splash
    _timer = Timer(const Duration(seconds: 3), () {
      checkLoginAndNavigate();
    });
  }

  Future<void> checkLoginAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final userType = prefs.getString(_userTypeKey);

    if (isLoggedIn) {
      // Navigate based on userType
      if (userType == 'patient') {
        Navigator.pushReplacementNamed(context, PatientDashboard.routeName);
      } else if (userType == 'caregiver') {
        Navigator.pushReplacementNamed(context, CareTakerDashboard.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginView.routeName);
      }
    } else {
      // Not logged in
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child:
                  Opacity(opacity: _fadeAnimation.value, child: LogoWidget()),
            );
          },
        ),
      ),
    );
  }
}
