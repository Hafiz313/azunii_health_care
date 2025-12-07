import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Azunii_Health/views/splash/controller/splash_controller.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/logo_widget.dart';
import '../base_view/base_scaffold_auth.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String routeName = '/SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final SplashController _splashController;
  Timer? _timer;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    _splashController = SplashController();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Start animations
    _animationController.forward();

    // Navigate after delay
    _timer = Timer(const Duration(seconds: 1), () {
      _splashController.checkLoginAndNavigate(context);
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
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: const LogoWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}
