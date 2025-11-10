import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../utils/inactivity_service.dart';
import '../../utils/navigation_dailog.dart';
import '../auth/login/controller/login_controller.dart';
import '../care_taker/home/home_view.dart';
import '../care_taker/home/controller/home_controller.dart';

class BaseScaffold extends StatefulWidget {
  final Widget? body;
  final bool showBlurBackground;

  final String title;
  final String subTitle;
  final Color? backgroundColor;
  final List<Widget>? actionWidgets;
  final bool showAppBar;
  final bool isBackArrow;
  final bool showBackButton;
  final bool plainBackground;

  const BaseScaffold(
      {super.key,
      this.showAppBar = true,
      this.title = '',
      this.subTitle = '',
      this.showBackButton = true,
      required this.body,
      this.actionWidgets,
      this.plainBackground = true,
      this.showBlurBackground = false,
      this.backgroundColor,
      this.isBackArrow = true});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final InactivityService _inactivityService = InactivityService();

  // final List<Widget> _screens = [
  //   const HomeView(),
  //   const HomeView(),
  //   const HomeView(),
  //   OtpView(),
  //   SignUpView()
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeView.routeName,
        (Route<dynamic> route) => false,
      );
    }
    // else if (index == 1) {
    //   Navigator.pushReplacementNamed(context, AttendanceDetailsView.routeName);
    // } else if (index == 2) {
    //   Navigator.pushReplacementNamed(context, LeaveBalanceView.routeName);
    // } else if (index == 3) {
    //   Navigator.pushReplacementNamed(context, NotificationView.routeName);
    // }
  }

  @override
  Widget build(BuildContext context) {
    _inactivityService.initialize(() {
      // Call your logout logic here
      final loginController = Get.put(LoginController());
      loginController.logout();
      // Optionally, navigate to login screen
    });
    return WillPopScope(
      onWillPop: () async {
        return await NavigationUtils.handleBackNavigation(context);
      },
      child: Listener(
        onPointerDown: (_) => _inactivityService.resetTimer(),
        onPointerMove: (_) => _inactivityService.resetTimer(),
        onPointerUp: (_) => _inactivityService.resetTimer(),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: widget.backgroundColor ?? AppColors.primary,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(
                  80), // Set the height of the custom AppBar
              child: Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.isBackArrow
                          ? InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(FontAwesomeIcons.arrowLeft,
                                  size: 20, color: Colors.black),
                            )
                          : InkWell(
                              onTap: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (_scaffoldKey.currentState != null) {
                                    if (_scaffoldKey
                                        .currentState!.isDrawerOpen) {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    } else {
                                      _scaffoldKey.currentState!.openDrawer();
                                    }
                                  }
                                });
                              },
                              child: const Icon(Icons.menu,
                                  size: 28, color: Colors.black),
                            ),

                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            final homeController = Get.find<HomeController>();
                            final selectedJob =
                                homeController.selectedJob.value;
                            final jobTitle = selectedJob.jobTitle?.toString() ??
                                'Eworkforce Payroll';

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Eworkforce Payroll',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F308C), // Navy blue color
                                  ),
                                ),
                                if (selectedJob.jobTitle != null &&
                                    homeController.isMultiJob.value)
                                  Text(
                                    jobTitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2F308C).withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                      Container(),

                      // Notification Icons
                      // Row(
                      //   children: [
                      //     const Stack(
                      //       clipBehavior: Clip.none,
                      //       children: [
                      //         Icon(Icons.mail_outline,
                      //             size: 28, color: Colors.black),
                      //         Positioned(
                      //           right: -4,
                      //           top: -4,
                      //           child: CircleAvatar(
                      //             radius: 8,
                      //             backgroundColor: Colors.red,
                      //             child: Text(
                      //               '2',
                      //               style: TextStyle(
                      //                 fontSize: 10,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     const SizedBox(width: 16), // Spacing between icons
                      //
                      //     // Bell Icon with Badge
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.pushNamed(
                      //             context, NotificationView.routeName);
                      //       },
                      //       child: const Stack(
                      //         clipBehavior: Clip.none,
                      //         children: [
                      //           Icon(Icons.notifications_none,
                      //               size: 28, color: Colors.black),
                      //           Positioned(
                      //             right: -4,
                      //             top: -4,
                      //             child: CircleAvatar(
                      //               radius: 8,
                      //               backgroundColor: Colors.red,
                      //               child: Text(
                      //                 '2',
                      //                 style: TextStyle(
                      //                   fontSize: 10,
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            // drawer: const CustomDrawer(),
            // bottomNavigationBar: CustomBottomNavigationBar(
            //   currentIndex: _selectedIndex,
            //   onTap: _onItemTapped,
            // ),
            body: Container(
                color: widget.backgroundColor ?? AppColors.primary,
                child: widget.body!)),
      ),
    );
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit App"),
          content: const Text("Do you really want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Dismiss dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm exit
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }
}

final RegExp emailExp = RegExp("^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]"
    "(?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:/."
    "[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*.[a-zA-Z0-9]");
