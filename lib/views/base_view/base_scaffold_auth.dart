import 'package:flutter/material.dart';

import '../../consts/colors.dart';
import '../../utils/navigation_dailog.dart';

class BaseScaffoldAuth extends StatefulWidget {
  final Widget? body;
  final bool showBlurBackground;
  final String title;
  final String subTitle;
  final Color? backgroundColor;
  final List<Widget>? actionWidgets;
  final bool showAppBar;
  final bool showBackButton;
  final bool plainBackground;

  const BaseScaffoldAuth({
    super.key,
    this.showAppBar = true,
    this.title = '',
    this.subTitle = '',
    this.showBackButton = true,
    required this.body,
    this.actionWidgets,
    this.plainBackground = true,
    this.showBlurBackground = false,
    this.backgroundColor,
  });

  @override
  State<BaseScaffoldAuth> createState() => _BaseScaffoldAuthState();
}

class _BaseScaffoldAuthState extends State<BaseScaffoldAuth> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await NavigationUtils.handleBackNavigation(context);
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: widget.backgroundColor ?? AppColors.primary,
            resizeToAvoidBottomInset: true,
            body: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                  color: widget.backgroundColor ?? AppColors.primary,
                  child: widget.body!),
            )),
      ),
    );
  }
}

final RegExp emailExp = RegExp("^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]"
    "(?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:/."
    "[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*.[a-zA-Z0-9]");
