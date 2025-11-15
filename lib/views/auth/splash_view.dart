import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/auth/sing_up/signup_view.dart';
import 'package:azunii_health_care/views/auth/term_conditions_view.dart';
import 'package:azunii_health_care/views/widget/Common_widgets/logo_widget.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../consts/assets.dart';
import '../../consts/colors.dart';
import '../base_view/base_scaffold_auth.dart';
import '../widget/buttons.dart';
import 'login/login_view.dart';
import 'dart:async';

class SplashView extends StatefulWidget {
  SplashView({super.key});
  static const String routeName = '/SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final emailTxtField = TextEditingController();

  final passwordTxtField = TextEditingController();

  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Create zoom animation - start from very small and zoom in
    _scaleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Start animation
    _animationController.forward();

    // Start a 5-second timer to navigate to login page
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldAuth(
      body: Container(
        width: double.infinity,
        child: Center(
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
      ),
    );
  }
}
